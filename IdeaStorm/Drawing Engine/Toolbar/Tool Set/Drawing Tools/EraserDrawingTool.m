//
//  EraserDrawingTool.m
//  IdeaStorm
//
//  Created by Robert Cole on 11/7/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "EraserDrawingTool.h"

@implementation EraserDrawingTool

@synthesize pointBuffer = _pointBuffer;
@synthesize numVerticesCreated;

- (id)init {
    self = [super init];
    
    if (self) {
        self.title = @"Eraser";
    }
    
    return self;
}

- (Vertex *)verticesFromPoint:(CGPoint)point andDrawingColor:(Color)color andPointSize:(CGFloat)size isLastPoint:(_Bool)lastPoint {
    
    Vertex * vertices;
    
    NSMutableArray *points = NULL;
    
    //if the pointBuffer hasn't been allocated yet, allocate it
    if (!self.pointBuffer) {
        self.pointBuffer = [[NSMutableArray alloc]initWithCapacity:4];
    }
    
    //if buffer is too big remove first item in buffer
    while ([self.pointBuffer count] >= 4) {
        [self.pointBuffer removeObjectAtIndex:0];
    }
    
    //add point to buffer
    [self.pointBuffer addObject:[NSValue valueWithCGPoint:point]];
    
    //last point check to determine if straight line or dot will be drawn
    
    //check for dot
    if ([self.pointBuffer count] == 1 && lastPoint) {
        //add single point to points array
        points = [[[NSMutableArray alloc]initWithCapacity:1] autorelease];
        
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //check for straight line
    if ([self.pointBuffer count] == 2 && lastPoint) {
        //get interpolated line points using half the point size as the spacing
        points = [DrawingEngine interpolateLinePoints:self.pointBuffer withSpace:(size / 20)];
    }
    
    if ([self.pointBuffer count] >= 3) {
        points = [DrawingEngine interpolateCurvePointsWithCurvePoints:self.pointBuffer withSpace:(size / 20) andLastPoint:lastPoint];
    }
    
    if (lastPoint) {
        [self.pointBuffer removeAllObjects];
    }
    
    //build vertices from calculated points
    
    vertices = malloc([points count] * sizeof(Vertex));
    
    Vertex vertex;
    
    for (int i=0; i<[points count]; i++) {
        
        CGPoint pointForVertex = [[points objectAtIndex:i] CGPointValue];
        
        vertex.position.x = pointForVertex.x;
        vertex.position.y = -pointForVertex.y;
        
        vertex.color.r = 1.0;
        vertex.color.g = 1.0;
        vertex.color.b = 1.0;
        vertex.color.a = 1.0;
        
        vertex.pointSize = size;
        
        vertices[i] = vertex;
    }
    
    self.numVerticesCreated = [points count];
    
    return vertices;
}

- (void)dealloc {
    if (self.pointBuffer) {
        [self.pointBuffer release];
    }
    
    [super dealloc];
}


@end
