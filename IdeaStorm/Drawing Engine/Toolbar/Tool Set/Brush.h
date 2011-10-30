//
//  Brush.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brush : NSObject

@property (nonatomic, strong) NSString *textureFilename;

#pragma mark - Initialization

- (id)initWithTexture:(NSString *)filename;

@end
