//
//  GLView.m
//  IdeaStorm
//
//  Created by Robert Cole on 9/22/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "GLView.h"

@implementation GLView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        numPoints = 0;
        vertexBufferSize = 50;
        
        [self setupLayer];
        [self setupContext];
        [self setupBuffers];
        [self setupProgram];
        [self setupRender];
        [self clearScreen];
        //loads default texture
        [self setupTexture:@"Particle.png"];
    }
    return self;
}

#pragma mark - Setup

//Overriding method to make the layer a CAEAGLLayer.
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

#pragma mark -

//Setting up the CAEAGLLayer for rendering
- (void)setupLayer {
    eaGLLayer = (CAEAGLLayer *)self.layer;
    
    //making the layer opaque improves performance
    eaGLLayer.opaque = YES;
    
    //setting up to retain the backing, this will keep the old pixel instead of throwing them away when the new pixels are drawn
    NSMutableDictionary *drawableProperties = [[[NSMutableDictionary alloc]initWithDictionary:eaGLLayer.drawableProperties] autorelease];
    
    NSNumber *boolean = [[NSNumber alloc]initWithBool:YES];
    
    [drawableProperties setObject:boolean forKey:kEAGLDrawablePropertyRetainedBacking];
    
    eaGLLayer.drawableProperties = drawableProperties;
    
    [boolean release];
}

//Sets the context of GLView to use OpenGL ES 2.0.
- (void)setupContext {
    context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!context || ![EAGLContext setCurrentContext:context]) {
        NSLog(@"Unable to setup OpenGL ES2 context!");
    }
}

#pragma mark -

//Makes calls to setup all buffers used by GLView.
- (void)setupBuffers {
    [self setupColorBuffer];
    [self setupFrameBuffer];
    [self setupVertexBuffer];
}

//Sets up the buffer used to store the color data.
- (void)setupColorBuffer {
    glGenRenderbuffers(1, &colorBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorBuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaGLLayer];
}

//Sets up the frame buffer used to render data.
- (void)setupFrameBuffer {
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorBuffer);
}

//Sets up the vertex buffer that will be used to store the Vertex data from the DrawingEngine.
- (void)setupVertexBuffer {
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex) * vertexBufferSize, NULL, GL_DYNAMIC_DRAW);
}

#pragma mark -

//Loads the texture specified by the fileName for rendering on the Point Sprites.
- (void)setupTexture:(NSString *)fileName {
    //if the texture is not defined or not the same as the last texture sent then setup the texture
    if (!fileName || fileName != textureFilename) {
        
        glDeleteTextures(1, &texture);
        
        CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
        
        if (!spriteImage) {
            NSLog(@"Failed to load image %@", fileName);
        }
        
        size_t width = CGImageGetWidth(spriteImage);
        size_t height = CGImageGetHeight(spriteImage);
        
        GLubyte *spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
        
        CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
        
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
        
        CGContextRelease(spriteContext);
        
        glGenTextures(1, &texture);
        glBindTexture(GL_TEXTURE_2D, texture);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
        
        free(spriteData);
    }
}

#pragma mark -

//Sets up the shader program using the GLProgram class.
- (void)setupProgram {
    program = [[GLProgram alloc]initWithVertexShaderFilename:@"Shader" fragmentShaderFilename:@"Shader"];
    
    [program addAttribute:@"Position"];
    [program addAttribute:@"Color"];
    [program addAttribute:@"PointSize"];
    [program link];
    
    attribPosition = [program attributeIndex:@"Position"];
    attribColor = [program attributeIndex:@"Color"];
    attribPointSize = [program attributeIndex:@"PointSize"];
    
    uniformProjection = [program uniformIndex:@"Projection"];
    uniformTexture = [program uniformIndex:@"Texture"];
    
    [program use];
    
    [program vertexShaderLog];
    [program fragmentShaderLog];
}

//Finishing setup before rendering begins.
- (void)setupRender {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    //enables alpha blending
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
}

#pragma mark - Drawing

//Clears the screen of all content.
- (void)clearScreen { 
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

//Renders any vertices currently stored in the vertex buffer.
- (void)render {
    glViewport(self.frame.origin.x, self.frame.origin.x, self.frame.size.width, self.frame.size.height);
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    
    [projection populateFromFrustumLeft:0 andRight:self.frame.size.width andBottom:-self.frame.size.height andTop:0 andNear:4 andFar:10];
    glUniformMatrix4fv(uniformProjection, 1, 0, projection.glMatrix);
    
    glUniform1i(uniformTexture, 0);
        
    glVertexAttribPointer(attribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(attribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *) (sizeof(GLfloat) * 2));
    glVertexAttribPointer(attribPointSize, 1, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *) (sizeof(GLfloat) * 6));
    
    if (numPoints != 0) {
        glActiveTexture(GL_TEXTURE0);
        
        //glBindTexture(GL_TEXTURE_2D, texture);
        
        glEnable(GL_TEXTURE_2D);
        
        glDrawArrays(GL_POINTS, 0, numPoints);
        
        numPoints = 0;
        
        glDisable(GL_TEXTURE_2D);
    }
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - Getting Rendering Data

//Replaces the vertices in the vertex buffer and then renders these vertices.
- (void)addVertices:(Vertex *)vertices withCount:(int)count {
    numPoints = count;
    
    //if the vertex buffer is too small double the size until it can hold all vertices being provided.
    if (numPoints < vertexBufferSize) {
        glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(Vertex) * count, vertices);
    } else {
        while (numPoints > vertexBufferSize) {
            vertexBufferSize *= 2;
        }
        
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex) * vertexBufferSize, vertices, GL_DYNAMIC_DRAW);
    }
          
    [self render];
}

#pragma mark - Save Rendered Data
//FIXME: freeing buffer 2 causes a crash on the iPad 1 and iPad 3, however it does not crash in the simulator. This is casuing a sizable memory leak.
- (UIImage *)getRenderedImage {
    int width = 768;//(int)floorf(self.frame.size.width);
    int height = 1024;//(int)floorf(self.frame.size.height);
    
    NSInteger myDataLength = width * height * 4;
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y <height; y++)
    {
        for(int x = 0; x <width * 4; x++)
        {
            buffer2[((height-1) - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    
    free(buffer);
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    //free(buffer2);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    
    return myImage;
}

#pragma mark - Memory Management

- (void)dealloc {
    if (context) {
        [context release];
    }
    
    if (program) {
        [program release];
    }
    
    glDeleteTextures(1, &texture);
    
    [super dealloc];
}
@end
