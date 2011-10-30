//
//  GLView.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GLProgram.h"
#import "CC3GLMatrix.h"

typedef struct {
    float Position[2];
    float Color[4];
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
    GLuint uniformProjection;
    GLuint uniformTexture;
    
    GLuint texture;
    NSString *textureFilename;
    
    int numPoints;
    int vertexBufferSize;
}

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

@end
