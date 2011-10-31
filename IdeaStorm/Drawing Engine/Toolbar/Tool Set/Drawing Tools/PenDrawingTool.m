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

//TODO: Finish stub
//TODO: Break up method into smaller methods that might be implemented in the DrawingEngine (such as, create curve from points, create line from points, etc), at least the part going from curve points to interpolated segments
//TODO: Need to find a way to pass the number of Vertex structs that are in the pointer, remember that malloc_size(vertices) does not provide an accurate size
//FIXME: The curve this produces looks a bit flat, this is likely caused by the fact it is only using 3 points to calculate the curve, I will need to switch this back to 4 points to fix it. Also I already tried to use a higher curve coefficeient but this does not work.
- (Vertex *)verticesFromPoint:(CGPoint)point andDrawingColor:(Color)color andPointSize:(CGFloat)size isLastPoint:(_Bool)lastPoint {
    
    Vertex * vertices;
    
    NSMutableArray *points = NULL;
    
    //if the pointBuffer hasn't been allocated yet, allocate it
    if (!self.pointBuffer) {
        self.pointBuffer = [[NSMutableArray alloc]initWithCapacity:3];
    }
    
    //if buffer is too big remove first item in buffer
    while ([self.pointBuffer count] >= 3) {
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
    
    //check for 3 points in buffer
    if ([self.pointBuffer count] >= 3) {
        
        //get control points for points 0, 1, 2, 2 (will keep up with the finger while drawing
        NSMutableArray *pointsToCalculateControlPoints = [[NSMutableArray alloc]initWithArray:self.pointBuffer copyItems:YES];
        
        [pointsToCalculateControlPoints addObject:[[self.pointBuffer objectAtIndex:2] copy]];
        
        NSMutableArray *controlPoints = [DrawingEngine calculateCurveControlPoints:pointsToCalculateControlPoints];
        
        //get curve points for control points, spacing is equal to half the point size
        NSMutableArray *pointsToInterpolate = [[NSMutableArray alloc]initWithObjects:
                                               [self.pointBuffer objectAtIndex:1],
                                               [controlPoints objectAtIndex:0],
                                               [controlPoints objectAtIndex:1],
                                               [self.pointBuffer objectAtIndex:2],
                                               nil];
        
        points = [DrawingEngine interpolateCurvePoints:pointsToInterpolate withSpace:(size / 20)];
        
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
    
    return vertices;
}
            
- (void)dealloc {
    if (self.pointBuffer) {
        [self.pointBuffer release];
    }
    
    [super dealloc];
}

@end
