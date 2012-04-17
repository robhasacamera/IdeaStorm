//
//  Brush.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/28/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToolbarItem.h"

@interface Brush : ToolbarItem

@property (nonatomic, strong) NSString *textureFilename;

#pragma mark - Initialization

- (id)initWithTexture:(NSString *)filename;

@end
