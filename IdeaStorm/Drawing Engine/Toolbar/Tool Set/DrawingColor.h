//
//  DrawingColor.h
//  IdeaStorm
//
//  Created by Robert Cole on 10/29/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToolbarItem.h"
#import "GLView.h"

@interface DrawingColor : ToolbarItem

@property (nonatomic) Color color;

- (id)initWithColor:(Color)color;

@end
