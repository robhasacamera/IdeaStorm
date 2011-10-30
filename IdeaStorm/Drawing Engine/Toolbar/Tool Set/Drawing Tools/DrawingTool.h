//
//  DrawingTool.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brush.h"

typedef struct {
    float r;
    float g;
    float b;
    float a;
} Color;

@interface DrawingTool : NSObject

@property (nonatomic, strong) Brush *brush;
@property (nonatomic) Color drawingColor;

#pragma mark - Initialization

- (id)initWithBrush:(Brush *)aBrush andDrawingColor:(Color)aColor;

@end
