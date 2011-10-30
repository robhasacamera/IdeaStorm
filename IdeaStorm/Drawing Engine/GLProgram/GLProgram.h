//
//  GLProgram.h
//  GLProgram
//
//  Created by Robert Cole on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


@interface GLProgram : NSObject {
    
}

- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename fragmentShaderFilename:(NSString *)fShaderFilename;

- (void)addAttribute:(NSString *)attributeName;

- (GLuint)attributeIndex:(NSString *)attributeName;

- (GLuint)uniformIndex:(NSString *)uniformName;

- (BOOL)link;

- (void)use;

- (NSString *)vertexShaderLog;

- (NSString *)fragmentShaderLog;

- (NSString *)programLog;

@end
