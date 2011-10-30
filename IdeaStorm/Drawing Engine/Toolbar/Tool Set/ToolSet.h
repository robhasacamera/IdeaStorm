//
//  ToolSet.h
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawingTool.h"
#import "Brush.h"
#import "DrawingColor.h"

@interface ToolSet : NSObject

@property (strong, nonatomic) DrawingTool *drawingTool;
@property (strong, nonatomic) Brush *brush;
@property (strong, nonatomic) DrawingColor *drawingColor;
@property (nonatomic) GLfloat pointSize;

- (id)initWithDrawingTool:(DrawingTool *)drawingTool andBrush:(Brush *)brush andDrawingColor:(DrawingColor *)drawingColor andPointSize:(GLfloat)pointSize;

@end
