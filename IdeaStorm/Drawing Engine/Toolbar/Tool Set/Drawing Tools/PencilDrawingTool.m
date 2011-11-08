//
//  PencilDrawingTool.m
//  IdeaStorm
//
//  Created by Robert Cole on 11/7/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "PencilDrawingTool.h"

@implementation PencilDrawingTool

@synthesize pointBuffer = _pointBuffer;
@synthesize numVerticesCreated = _numVerticesCreated;

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
    
    //check for dot
    if ([self.pointBuffer count] == 1 && lastPoint) {
        //add single point to points array
        points = [[[NSMutableArray alloc]initWithCapacity:1] autorelease];
        
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //check for straight line
    if ([self.pointBuffer count] == 2 && lastPoint) {
        //get interpolated line points using half the point size as the spacing
        points = [DrawingEngine interpolateLinePoints:self.pointBuffer withSpace:(size / 30)];
    }
    
    if ([self.pointBuffer count] >= 3) {
        points = [DrawingEngine interpolateCurvePointsWithCurvePoints:self.pointBuffer withSpace:(size / 30) andLastPoint:lastPoint];
    }
    
    [self calculateStartAndEndPointSizesUsingSize:size];
    
    //build vertices from calculated points
    
    vertices = malloc([points count] * sizeof(Vertex));
    
    Vertex vertex;
    
    float pointSizeDifference = endPointSize - startPointSize;
    
    float pointSizeStep = pointSizeDifference / (float)[points count];
    
    float pointSize = startPointSize;
    
    for (int i=0; i<[points count]; i++) {
        CGPoint pointForVertex = [[points objectAtIndex:i] CGPointValue];
        
        vertex.position.x = pointForVertex.x;
        vertex.position.y = -pointForVertex.y;
        
        vertex.color.r = color.r;
        vertex.color.g = color.g;
        vertex.color.b = color.b;
        vertex.color.a = color.a;
        
        vertex.pointSize = pointSize;
        
        pointSize += pointSizeStep;
        
        if (pointSizeStep > 0 && pointSize > endPointSize) {
            pointSize = endPointSize;
        }
        
        if (pointSizeStep < 0 && pointSize < endPointSize) {
            pointSize = endPointSize;
        }
        
        vertices[i] = vertex;
    }
    
    self.numVerticesCreated = [points count];
    
    if (lastPoint) {
        [self.pointBuffer removeAllObjects];
    }
    
    startPointSize = endPointSize;
    
    return vertices;
}

- (void)calculateStartAndEndPointSizesUsingSize:(GLfloat)size {
    float distanceBetweenPoints;
    float minPointSize = size / 5;
    float maxPointSize = size;
    
    if (minPointSize < kPointSizeMin) {
        minPointSize = kPointSizeMin;
    }
    
    if (minPointSize > maxPointSize) {
        minPointSize = maxPointSize;
    }
    
    if ([self.pointBuffer count] > 1) {
        if ([self.pointBuffer count] == 2) {
            distanceBetweenPoints = [DrawingEngine distanceBetweenPoint1:[[self.pointBuffer objectAtIndex:0] CGPointValue] andPoint2:[[self.pointBuffer objectAtIndex:1] CGPointValue]];
            
            startPointSize = size / distanceBetweenPoints * kPointSizeFactor;// * (size / kPointSizeFactor);
            
            if (startPointSize < minPointSize) {
                startPointSize = minPointSize;
            }
            
            if (startPointSize > maxPointSize) {
                startPointSize = maxPointSize;
            }
        } else {
            distanceBetweenPoints = [DrawingEngine distanceBetweenPoint1:[[self.pointBuffer objectAtIndex:1] CGPointValue] andPoint2:[[self.pointBuffer objectAtIndex:2] CGPointValue]];
        }
        
        endPointSize = size / distanceBetweenPoints * kPointSizeFactor;
        
        if (endPointSize < minPointSize) {
            endPointSize = minPointSize;
        }
        
        if (endPointSize > maxPointSize) {
            endPointSize = maxPointSize;
        }
        
        
    } else {
        startPointSize = size;
        endPointSize = size;
    }
}

- (void)dealloc {
    if (self.pointBuffer) {
        [self.pointBuffer release];
    }
    
    [super dealloc];
}

@end
