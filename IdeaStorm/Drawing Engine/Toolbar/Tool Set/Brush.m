//
//  Brush.m
//  IdeaStorm
//
//  Created by Robert Cole on 9/28/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "Brush.h"

@implementation Brush

@synthesize textureFilename = _textureFilename;

#pragma mark - Initialization

//Initializes the Brush with a default textureFilename.
- (id)init {
    //default brush texture
    self = [self initWithTexture:@"Particle.png"];
    
    return self;
}

//Initializes the Brush with the textureFilename specified.
- (id)initWithTexture:(NSString *)filename {
    self = [super init];
    
    if (self) {
        self.textureFilename = filename;
    }
    
    return self;
}

@end
