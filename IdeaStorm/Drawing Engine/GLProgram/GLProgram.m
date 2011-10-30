//
//  GLProgram.m
//  GLProgram
//
//  Created by Robert Cole on 8/12/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "GLProgram.h"

#pragma mark Function pointer Definitions

//This code is used to make the code for the log functions easier to write and read. These basically create pointers for functions (hench the data types that follow them) this way data an be sent the same way while dynamically using a function.
typedef void (*GLInfoFunction) (GLuint program,
                                GLenum pname,
                                GLint* params);

typedef void (*GLLogFunction) (GLuint program,
                               GLsizei bufsize,
                               GLsizei* length,
                               GLchar* infolog);

#pragma mark -

#pragma mark Private Extention Method Declaration

//declaring private instance variables and functions
@interface GLProgram() {
    NSMutableArray *attributes;
    NSMutableArray *uniforms;
    GLuint program, vertShader, fragShader;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;

- (NSString *)logForOpenGLObject:(GLuint)object infoCallback:(GLInfoFunction)infoFunc logFunc:(GLLogFunction)logFunc;

@end

#pragma mark -

@implementation GLProgram

//will init this object and attempt to compile the two shaders and attach them to the program
- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename fragmentShaderFilename:(NSString *)fShaderFilename {
    if (self = [super init]) {
        attributes = [[NSMutableArray alloc]init];
        uniforms = [[NSMutableArray alloc]init];
        NSString *vertShaderPathname, *fragShaderPathname;
        //create an empty program for the shaders
        program = glCreateProgram();
        
        //get the path of the vertex shader, then attempt to load and compile it
        vertShaderPathname = [[NSBundle mainBundle]pathForResource:vShaderFilename ofType:@"vsh"];
        
        if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
            NSLog(@"Failed to compile vertex shader");
        }
        
        //get the path of the fragment shader, then attempt to load and compile it
        fragShaderPathname = [[NSBundle mainBundle]pathForResource:fShaderFilename ofType:@"fsh"];
        
        if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
            NSLog(@"Failed to compile fragment shader");
        }
        
        //attach both shaders to the program
        glAttachShader(program, vertShader);
        glAttachShader(program, fragShader);
    }
    
    return self;
}

//loads and compiles a shader
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    GLint status;
    const GLchar *source;
    NSError *error;
    
    //get the shader's source code
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error] UTF8String];
    
    if (!source) {
        NSLog(@"Failed to load shader: %@", error.localizedDescription);
        NSLog(@"Check to see how the file is displaying in XCode, if it has color formatting this could be the issue due to a bug in XCode. Instead recreate the file with a glsl extention, then copy and paste the code into the new file. This file should display the code with only black text.");
        return NO;
    }
    
    //create empty shader using the pointer provided
    *shader = glCreateShader(type);
    //load the shader source code into the shader
    glShaderSource(*shader, 1, &source, NULL);
    //compile the shader source code
    glCompileShader(*shader);
    
    //check to make sure there were no errors
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    
    return status == GL_TRUE;
}

#pragma mark -
//this should be the first thing called after initialization, this will add ne attributes to the array and bind the attribute to let OpenGL know that it should expect that attribute in the vertex shader. This should be done before linking the program
- (void)addAttribute:(NSString *)attributeName {
    if (![attributes containsObject:attributeName]) {
        [attributes addObject:attributeName];
        //here we are binding the attribute to the index number of the attribute in the attribute array
        glBindAttribLocation(program, [attributes indexOfObject:attributeName], [attributeName UTF8String]);
        glEnableVertexAttribArray([attributes indexOfObject:attributeName]);
    }
}

//gets the index of an attribute that was added. This function should only be used once for each index that needs to be looked up (IE. not in a loop) as its a costly opperation
- (GLuint)attributeIndex:(NSString *)attributeName {
    return [attributes indexOfObject:attributeName];
}

//gets the index of an uniform that exist, OpenGL will automatically find all uniforms that exist and bind them to a unique index, thus we only need to find the index number for a value that we know exist. This function should only be used once for each index that needs to be looked up (IE. not in a loop) as its a costly opperation
- (GLuint)uniformIndex:(NSString *)uniformName {
    return glGetUniformLocation(program, [uniformName UTF8String]);
}

#pragma mark -

//links the program and deletes the shaders since they are now stored in memory. This should only be called after adding all attributes
- (BOOL)link {
    GLint status;
    
    //linking and validating program
    glLinkProgram(program);
    glValidateProgram(program);
    
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    
    if (status == GL_FALSE) {
        return NO;
    }
    
    //deleting shaders to free up space
    if (vertShader) {
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDeleteShader(fragShader);
    }
    
    return YES;
}

//states to use this program for rendering. This replaces the previoous program that OpenGL was using.
- (void)use {
    glUseProgram(program);
}

#pragma mark -

//gets the log and returns it as a string
- (NSString *)logForOpenGLObject:(GLuint)object infoCallback:(GLInfoFunction)infoFunc logFunc:(GLLogFunction)logFunc {
    GLint logLength = 0, charsWritten = 0;
    
    //gets the length of the log message
    infoFunc(object, GL_INFO_LOG_LENGTH, &logLength);
    
    if (logLength < 1) {
        return nil;
    }
    
    //allocates the memory needed to hold the log message
    char *logBytes = malloc(logLength);
    //retrieves the log in characters
    logFunc(object, logLength, &charsWritten, logBytes);
    //converts the log into a string
    NSString *log = [[[NSString alloc]initWithBytes:logBytes length:logLength encoding:NSUTF8StringEncoding] autorelease];
    //releasing memory
    free(logBytes);
    
    return log;
}

//gets the log for the vertex shader in case there is an issue
- (NSString *)vertexShaderLog {
    GLchar message[256];
    glGetShaderInfoLog(vertShader, sizeof(message), 0, &message[0]);
    NSString *messageString = [NSString stringWithUTF8String:message];
    NSLog(@"%@", messageString);
    
    return [self logForOpenGLObject:vertShader infoCallback:(GLInfoFunction)&glGetProgramiv logFunc:(GLLogFunction)&glGetProgramInfoLog];
}

//gets the log for the fragment shader in case there is an issue
- (NSString *)fragmentShaderLog {
    GLchar message[256];
    glGetShaderInfoLog(fragShader, sizeof(message), 0, &message[0]);
    NSString *messageString = [NSString stringWithUTF8String:message];
    NSLog(@"%@", messageString);
    
    return [self logForOpenGLObject:fragShader infoCallback:(GLInfoFunction)&glGetProgramiv logFunc:(GLLogFunction)&glGetProgramInfoLog];
}

//gets the log for the program in case there is an issue
- (NSString *)programLog {
    return [self logForOpenGLObject:program infoCallback:(GLInfoFunction)&glGetProgramiv logFunc:(GLLogFunction)&glGetProgramInfoLog];
}

#pragma mark -

//memory management
- (void)dealloc {
    [attributes release];
    [uniforms release];
    
    if (vertShader) {
        glDeleteShader(vertShader);
    }
    
    if (fragShader) {
        glDeleteShader(fragShader);
    }
    
    if (program) {
        glDeleteProgram(program);
    }
    
    [super dealloc];
}

@end
