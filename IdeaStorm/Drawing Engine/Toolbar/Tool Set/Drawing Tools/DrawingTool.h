//
//  DrawingTool.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/28/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//
//TODO change init to work with ToolbarItem init.

#import <Foundation/Foundation.h>
#import "Brush.h"
#import "GLView.h"
#import "ToolbarItem.h"

@interface DrawingTool : ToolbarItem

@property (nonatomic, strong) Brush *brush;
@property (nonatomic) Color drawingColor;

#pragma mark - Initialization

- (id)initWithBrush:(Brush *)aBrush andDrawingColor:(Color)aColor;

@end
