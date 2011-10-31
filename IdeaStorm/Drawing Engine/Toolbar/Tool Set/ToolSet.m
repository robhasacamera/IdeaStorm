//
//  ToolSet.m
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ToolSet.h"

@implementation ToolSet

@synthesize drawingTool = _drawingTool;
@synthesize brush = _brush;
@synthesize drawingColor = _drawingColor;
@synthesize pointSize = _pointSize;

- (id)initWithDrawingTool:(NSObject <DrawingTool> *)drawingTool andBrush:(Brush *)brush andDrawingColor:(DrawingColor *)drawingColor andPointSize:(GLfloat)pointSize {
    self = [super init];
    
    if (self) {
        self.drawingTool = drawingTool;
        self.brush = brush;
        self.drawingColor = drawingColor;
        self.pointSize = pointSize;
    }
    
    return self;
}

- (void)dealloc {
    [self.drawingTool release];
    [self.brush release];
    [self.drawingColor release];
    
    [super dealloc];
}

@end
