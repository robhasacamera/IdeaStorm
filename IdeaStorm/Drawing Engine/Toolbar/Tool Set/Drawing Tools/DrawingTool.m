//
//  DrawingTool.m
//  IdeaStorm
//
//  Created by Robert Cole on 9/28/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "DrawingTool.h"

@implementation DrawingTool

@synthesize brush = _brush;
@synthesize drawingColor;

#pragma mark - Initialization

//Initializes the DrawingTool with a default color of black and defualt brush.
- (id)init {
    Color defaultColor;
    defaultColor.r = 0.0;
    defaultColor.g = 0.0;
    defaultColor.b = 0.0;
    defaultColor.a = 1.0;
    
    //initialize with default brush and drawing color
    self = [self initWithBrush:[[Brush alloc]init] andDrawingColor:defaultColor];
    
    return self;
}

//Initializes DrawingTool with the Brush and drawingColor specified.
- (id)initWithBrush:(Brush *)aBrush andDrawingColor:(Color)aColor {
    self = [super init];
    
    if (self) {
        self.brush = aBrush;
        self.drawingColor = aColor;
    }
    
    return self;
}

#pragma mark - Memory Managment

- (void)dealloc {
    [self.brush release];
    
    [super dealloc];
}

@end
