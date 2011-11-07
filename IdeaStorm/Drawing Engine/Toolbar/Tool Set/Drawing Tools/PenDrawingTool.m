//
//  PenDrawingTool.m
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "PenDrawingTool.h"

@implementation PenDrawingTool

@synthesize pointBuffer = _pointBuffer;
@synthesize numVerticesCreated;

//TODO: Break up method into smaller methods that might be implemented in the DrawingEngine (such as, create curve from points, create line from points, etc), at least the part going from curve points to interpolated segments
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
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //check for straight line
    if ([self.pointBuffer count] == 2 && lastPoint) {
        //get interpolated line points using half the point size as the spacing
        points = [DrawingEngine interpolateLinePoints:self.pointBuffer withSpace:(size / 20)];
    }
    
    int pointIndex0;
    int pointIndex1;
    int pointIndex2;
    int pointIndex3;
    
    //creates all but last curve segment
    if ([self.pointBuffer count] >= 3) {
        pointIndex0 = [self.pointBuffer count] - 4;
        pointIndex1 = [self.pointBuffer count] - 3;
        pointIndex2 = [self.pointBuffer count] - 2;
        pointIndex3 = [self.pointBuffer count] - 1;
        
        if (pointIndex0 < 0) {
            pointIndex0 = 0;
        }
        
        NSMutableArray *pointsToCalculateControlPoints = [[NSMutableArray alloc]initWithObjects:
                                                          [self.pointBuffer objectAtIndex:pointIndex0],
                                                          [self.pointBuffer objectAtIndex:pointIndex1],
                                                          [self.pointBuffer objectAtIndex:pointIndex2],
                                                          [self.pointBuffer objectAtIndex:pointIndex3],
                                                          nil];
        
        NSMutableArray *controlPoints = [DrawingEngine calculateCurveControlPoints:pointsToCalculateControlPoints];
        
        //get curve points for control points, spacing is equal to half the point size
        NSMutableArray *pointsToInterpolate = [[NSMutableArray alloc]initWithObjects:
                                               [self.pointBuffer objectAtIndex:pointIndex1],
                                               [controlPoints objectAtIndex:0],
                                               [controlPoints objectAtIndex:1],
                                               [self.pointBuffer objectAtIndex:pointIndex2],
                                               nil];
        
        points = [DrawingEngine interpolateCurvePoints:pointsToInterpolate withSpace:(size / 20)];
        
        [pointsToCalculateControlPoints release];
        [pointsToInterpolate release];

    }
    
    //check for last segment of curve
    if ([self.pointBuffer count] >= 3 && lastPoint) {
        pointIndex0 = [self.pointBuffer count] - 3;
        pointIndex1 = [self.pointBuffer count] - 2;
        pointIndex2 = [self.pointBuffer count] - 1;
        pointIndex3 = [self.pointBuffer count] - 1;
        
        NSMutableArray *pointsToCalculateControlPoints = [[NSMutableArray alloc]initWithObjects:
                                                          [self.pointBuffer objectAtIndex:pointIndex0],
                                                          [self.pointBuffer objectAtIndex:pointIndex1],
                                                          [self.pointBuffer objectAtIndex:pointIndex2],
                                                          [self.pointBuffer objectAtIndex:pointIndex3],
                                                          nil];
        
        NSMutableArray *controlPoints = [DrawingEngine calculateCurveControlPoints:pointsToCalculateControlPoints];
        
        //get curve points for control points, spacing is equal to half the point size
        NSMutableArray *pointsToInterpolate = [[NSMutableArray alloc]initWithObjects:
                                               [self.pointBuffer objectAtIndex:pointIndex2],
                                               [controlPoints objectAtIndex:0],
                                               [controlPoints objectAtIndex:1],
                                               [self.pointBuffer objectAtIndex:pointIndex3],
                                               nil];
        
        [points addObjectsFromArray:[DrawingEngine interpolateCurvePoints:pointsToInterpolate withSpace:(size / 20)]];
        
        [pointsToCalculateControlPoints release];
        [pointsToInterpolate release];
    }
    
    //need something that will check for the first segment
    
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
        
        vertex.color.r = color.r;
        vertex.color.g = color.g;
        vertex.color.b = color.b;
        vertex.color.a = color.a;
        
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
