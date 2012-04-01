//
//  GLView.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/22/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GLProgram.h"
#import "CC3GLMatrix.h"

typedef struct {
    GLfloat r;
    GLfloat g;
    GLfloat b;
    GLfloat a;
} Color;

typedef struct {
    GLfloat x;
    GLfloat y;
} Position;

typedef struct {
    Position position;
    Color color;
    GLfloat pointSize;
} Vertex;

@interface GLView : UIView {
    CAEAGLLayer *eaGLLayer;
    
    EAGLContext *context;
    
    GLuint colorBuffer;
    GLuint frameBuffer;
    GLuint vertexBuffer;
    
    GLProgram *program;
    
    GLuint attribPosition;
    GLuint attribColor;
    GLuint attribPointSize;
    GLuint uniformProjection;
    GLuint uniformTexture;
    
    GLuint texture;
    NSString *textureFilename;
    
    int numPoints;
    int vertexBufferSize;
}

@property (nonatomic) GLubyte *buffer;

#pragma mark - Setup

#pragma mark -

- (void)setupLayer;

- (void)setupContext;

#pragma mark -

- (void)setupBuffers;

- (void)setupColorBuffer;

- (void)setupFrameBuffer;

- (void)setupVertexBuffer;

#pragma mark -

- (void)setupTexture:(NSString *)fileName;

#pragma mark -

- (void)setupProgram;

- (void)setupRender;

#pragma mark - Drawing

- (void)clearScreen;

- (void)render;

#pragma mark - Getting Rendering Data

- (void)addVertices:(Vertex *)vertices withCount:(int)count;

#pragma mark - Saving Rendered Data

- (UIImage *)getRenderedImage;

void myProviderReleaseFunction (void *info, const void *data, size_t size);

@end
