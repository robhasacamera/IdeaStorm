//
//  DrawingEngine.m
//  IdeaStorm
//
//  Created by Robert Cole on 9/22/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "DrawingEngine.h"

@implementation DrawingEngine

@synthesize renderView = _renderView;
@synthesize pointBuffer = _pointBuffer;
@synthesize spaceBetweenPoints;
@synthesize drawingTool = _drawingTool;

#pragma mark - Initialization

//Initializes with a default frame equal to the bounds of the main screen.
- (id)init {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    self = [self initWithFrame:screenBounds];
    
    return self;
}

//Initializes the drawing engine with a custom frame.
- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    
    if (self) {
        self.renderView = [[GLView alloc]initWithFrame:frame];
        self.pointBuffer = [[NSMutableArray alloc]initWithCapacity:4];
        self.spaceBetweenPoints = 1.0;
        self.drawingTool = [[DrawingTool alloc]init];
    }
    
    return self;
}

#pragma mark - Touch Data Handling

//Creates a drawing in the renderView (GLView) using the ouch data provided.
- (void)drawWithTouch:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    
    //touch began is ignored as it creates extra points for a drawing made of dots
    if (touch.phase != UITouchPhaseBegan) {
        
        NSMutableArray *points = NULL;
        
        CGPoint point = [touch locationInView:self.renderView];
        //since the point buffer capacity is initialized to 4, the first object will be removed if the capacity is full before adding a new object
        while ([self.pointBuffer count] >= 4) {
            [self.pointBuffer removeObjectAtIndex:0];
        }
        
        [self.pointBuffer addObject:[NSValue valueWithCGPoint:point]];
        
        for (int i=0; i<[self.pointBuffer count]; i++) {
            point = [[self.pointBuffer objectAtIndex:i] CGPointValue];
        }
        
        int tapCount = touch.tapCount;
        
        if ([self.pointBuffer count] == 3) {
            //get points for first segment
            //calculateControlPoints with points 0, 0, 1 & 2
            NSMutableArray *pointsToCalcControlPoints = [[[NSMutableArray alloc]initWithObjects:
                                                       [self.pointBuffer objectAtIndex:0], 
                                                       [self.pointBuffer objectAtIndex:0], 
                                                       [self.pointBuffer objectAtIndex:1], 
                                                       [self.pointBuffer objectAtIndex:2],
                                                       nil] autorelease];
            NSMutableArray *controlPoints = [DrawingEngine calculateCurveControlPoints:pointsToCalcControlPoints];
            
            //first control point is discarded and replaced with point 0
            NSMutableArray *pointsToInterpolate = [[NSMutableArray alloc]initWithObjects:
                                                   [self.pointBuffer objectAtIndex:0], 
                                                   [self.pointBuffer objectAtIndex:0], 
                                                   [controlPoints objectAtIndex:1], 
                                                   [self.pointBuffer objectAtIndex:1], 
                                                   nil];
            
            //then pass points 0, 0(CP1), CP2 & 1 to interPolateCurvePoints
            points = [DrawingEngine interpolateCurvePoints:pointsToInterpolate withSpace:spaceBetweenPoints];
            
            [pointsToInterpolate release];
        } else if ([self.pointBuffer count] == 4) {
            //get points for middle segment
            NSMutableArray *controlPoints = [DrawingEngine calculateCurveControlPoints:self.pointBuffer];
            
            NSMutableArray *pointsToInterpolate = [[NSMutableArray alloc]initWithObjects:
                                                   [self.pointBuffer objectAtIndex:1], 
                                                   [controlPoints objectAtIndex:0], 
                                                   [controlPoints objectAtIndex:1], 
                                                   [self.pointBuffer objectAtIndex:2], 
                                                   nil];
            
            //then pass points 0, 0(CP1), CP2 & 1 to interPolateCurvePoints
            points = [DrawingEngine interpolateCurvePoints:pointsToInterpolate withSpace:spaceBetweenPoints];
            
            [pointsToInterpolate release];
            
            if (points) {
                [self drawWithPoints:points];
            }
        }//END if (touchCount == 3)
        
        if (points) {
            [self drawWithPoints:points];
            [points removeAllObjects];
        }
        
        if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled) {
            //interpolate last points if needed
            if ([self.pointBuffer count] == 1) {
                //draw a dot
                CGPoint point = [touch locationInView:self.renderView];
                
                points = [[[NSMutableArray alloc]initWithObjects:[NSValue valueWithCGPoint:point], nil] autorelease];
            } else if ([self.pointBuffer count] == 2) {
                //draw a line
                points = [DrawingEngine interpolateLinePoints:self.pointBuffer withSpace:self.spaceBetweenPoints];
            } else if ([self.pointBuffer count] == 3) {
                //get points for last segment
                //calculateControlPoints with points points 0, 1, 2 & 2
                NSMutableArray *pointsToCalcControlPoints = [[[NSMutableArray alloc]initWithObjects:
                                                              [self.pointBuffer objectAtIndex:0], 
                                                              [self.pointBuffer objectAtIndex:1], 
                                                              [self.pointBuffer objectAtIndex:2], 
                                                              [self.pointBuffer objectAtIndex:2],
                                                              nil] autorelease];
                NSMutableArray *controlPoints = [DrawingEngine calculateCurveControlPoints:pointsToCalcControlPoints];
                
                //second control point is replaced with point 2
                NSMutableArray *pointsToInterpolate = [[NSMutableArray alloc]initWithObjects:
                                                       [self.pointBuffer objectAtIndex:1], 
                                                       [controlPoints objectAtIndex:0], 
                                                       [self.pointBuffer objectAtIndex:2], 
                                                       [self.pointBuffer objectAtIndex:2], 
                                                       nil];
                
                //then pass points 1, CP1, 2(CP2) & 2 to interPolateCurvePoints
                points = [DrawingEngine interpolateCurvePoints:pointsToInterpolate withSpace:spaceBetweenPoints];
                
                [pointsToInterpolate release];
            } else if ([self.pointBuffer count] == 4) {
                //get points for last segment
                //calculateControlPoints with points points 1, 2, 3 & 3
                NSMutableArray *pointsToCalcControlPoints = [[[NSMutableArray alloc]initWithObjects:
                                                              [self.pointBuffer objectAtIndex:1], 
                                                              [self.pointBuffer objectAtIndex:2], 
                                                              [self.pointBuffer objectAtIndex:3], 
                                                              [self.pointBuffer objectAtIndex:3],
                                                              nil] autorelease];
                NSMutableArray *controlPoints = [DrawingEngine calculateCurveControlPoints:pointsToCalcControlPoints];
                
                //second control point is replaced with point 3
                NSMutableArray *pointsToInterpolate = [[NSMutableArray alloc]initWithObjects:
                                                       [self.pointBuffer objectAtIndex:2], 
                                                       [controlPoints objectAtIndex:0], 
                                                       [self.pointBuffer objectAtIndex:3], 
                                                       [self.pointBuffer objectAtIndex:3], 
                                                       nil];
                
                //then pass points 2, CP1, 3(CP2) & 3 to interPolateCurvePoints
                points = [DrawingEngine interpolateCurvePoints:pointsToInterpolate withSpace:spaceBetweenPoints];
                
                [pointsToInterpolate release];
            }
            
            //clear the buffer to perpare for a new line, curve or point
            [self.pointBuffer removeAllObjects];
        } //END if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled)
        
        if (points) {
            [self drawWithPoints:points];
            [points removeAllObjects];
        }
        
        if (tapCount == 2) {
            [self eraseScreen];
        }
        
    }//END if (touch.phase != UITouchPhaseBegan)
;}

#pragma mark - Point Calculations

//This method provides an array of curve points based off a startPoint, two control points, an end point and a set space to have between points. The spacing placed between the points is an approximation and not 100% accurate. This method will leave off the end point so the begining point of the next curve segment doesn't overlap it.
+ (NSMutableArray *)interpolateCurvePoints:(NSMutableArray *)points withSpace:(float)spaceBetweenPoints {
    NSMutableArray *interpolatedPoints = NULL;
    
    //only do work if the data provided is valid
    if ([points count] == 4 && spaceBetweenPoints > 0) {
        CGPoint point;
        
        for (int i=0; i<[points count]; i++) {
            point = [[points objectAtIndex:i] CGPointValue];
        }
        
        float curveLength = [DrawingEngine estimateCurveLength:points];
        
        int numSteps = floorf(curveLength / spaceBetweenPoints);
        
        //need to generate at least one point
        if (numSteps == 0) {
            numSteps = 1;
        }
        
        interpolatedPoints = [DrawingEngine interpolateCurvePoints:points withPointCount:numSteps];
    }
    
    return interpolatedPoints;
}

//This method provides an array of curve points based off a startPoint, two control points, an end point and a set number of points to calculate. This method will leave off the end point so the begining point of the next curve segment doesn't overlap it.
+ (NSMutableArray *)interpolateCurvePoints:(NSMutableArray *)points withPointCount:(int)numPoints {
    NSMutableArray *interpolatedPoints = NULL;
    
    //check for valid data
    if ([points count] == 4 && numPoints > 0) {
        interpolatedPoints = [[[NSMutableArray alloc]initWithCapacity:numPoints] autorelease];
        
        CGPoint p0 = [[points objectAtIndex:0] CGPointValue];
        CGPoint p1 = [[points objectAtIndex:1] CGPointValue];
        CGPoint p2 = [[points objectAtIndex:2] CGPointValue];
        CGPoint p3 = [[points objectAtIndex:3] CGPointValue];
        
        CGPoint point;
        
        float step = 0;
        
        //this uses the bezier curve algorithm for calculating points
        for (int i=0; i<numPoints; i++) {
            point.x = (1.0 - step) * (1.0 - step) * (1.0 - step) * p0.x + 3 * (1 - step) * (1 - step) * step * p1.x + 3 * (1 - step) * (step * step) * p2.x + (step * step * step) * p3.x;
            
            point.y = (1.0 - step) * (1.0 - step) * (1.0 - step) * p0.y + 3 * (1 - step) * (1 - step) * step * p1.y + 3 * (1 - step) * (step * step) * p2.y + (step * step * step) * p3.y;
            
            [interpolatedPoints addObject:[NSValue valueWithCGPoint:point]];
            
            step += 1.0 / numPoints;
        }
    }
    
    return interpolatedPoints;
}

//This method will calculate an array of points between a start and and end point that have the same spacing between them. In the case that this spacing cannot be a consistent distance when including the end point, the end point will be left off.
+ (NSMutableArray *)interpolateLinePoints:(NSMutableArray *)points withSpace:(float)spaceBetweenPoints {
    NSMutableArray *interpolatedPoints = NULL;
    
    //only interpolate points if there is valid data
    if ([points count] == 2 && spaceBetweenPoints > 0) {
        CGPoint point1 = [[points objectAtIndex:0] CGPointValue];
        CGPoint point2 = [[points objectAtIndex:1] CGPointValue];
        
        float lineLength = [DrawingEngine distanceBetweenPoint1:point1 andPoint2:point2];
        
        float unroundedNumSteps = lineLength / spaceBetweenPoints;
        
        //the floor function rounds down, this means the last point will be left off in most cases, this is done to maintain even spacing between points
        int numSteps = floorf(unroundedNumSteps);
        
        //getting the amount that will need to be added each step to new point
        float xStep = (point2.x - point1.x) / unroundedNumSteps;
        float yStep = (point2.y - point1.y) / unroundedNumSteps;
        
        CGPoint interPoint = point1;
        
        interpolatedPoints = [[[NSMutableArray alloc]initWithObjects:[NSValue valueWithCGPoint:interPoint], nil] autorelease];
        
        for (int i=0; i < numSteps; i++) {
            interPoint.x += xStep;
            interPoint.y += yStep;
            
            [interpolatedPoints addObject:[NSValue valueWithCGPoint:interPoint]];
        }
    }
    
    return interpolatedPoints;
}

#pragma mark -

//This will calculate the bezier curve control points for a curve segment BC given curve points A, B, C and D.
+ (NSMutableArray *)calculateCurveControlPoints:(NSMutableArray *)points {
    NSMutableArray *controlPoints = NULL;
    
    //check for valid data
    if ([points count] == 4) {
        controlPoints = [[[NSMutableArray alloc]initWithCapacity:2] autorelease];
        
        CGPoint cp1;
        CGPoint cp2;
        
        CGPoint p0 = [[points objectAtIndex:0] CGPointValue];
        CGPoint p1 = [[points objectAtIndex:1] CGPointValue];
        CGPoint p2 = [[points objectAtIndex:2] CGPointValue];
        CGPoint p3 = [[points objectAtIndex:3] CGPointValue];
        
        cp1.x = p1.x + kCurveCoefficient * (p2.x - p0.x);
        cp1.y = p1.y + kCurveCoefficient * (p2.y - p0.y);
        
        cp2.x = p2.x - kCurveCoefficient * (p3.x - p1.x);
        cp2.y = p2.y - kCurveCoefficient * (p3.y - p1.y);
        
        [controlPoints addObject:[NSValue valueWithCGPoint:cp1]];
        [controlPoints addObject:[NSValue valueWithCGPoint:cp2]];
    }
    
    return controlPoints;
}

//This method estimates the length of a curve using line segments from kNumCurvePoints along the curve.
+ (float)estimateCurveLength:(NSMutableArray *)points {
    float length = 0;
    
    //check that the data provided is valid
    if ([points count] == 4) {
        NSMutableArray *pointsForEstimate = [DrawingEngine interpolateCurvePoints:points withPointCount:kNumCurveEstimatePoints];
        
        CGPoint point1;
        
        CGPoint point2;
        
        int numLineSegments = kNumCurveEstimatePoints - 1;
        
        for (int i=0; i<numLineSegments; i++) {
            point1 = [[pointsForEstimate objectAtIndex:i] CGPointValue];
            point2 = [[pointsForEstimate objectAtIndex:i + 1] CGPointValue];
            
            length += [DrawingEngine distanceBetweenPoint1:point1 andPoint2:point2];
        }
    }
    
    return length;
}

//Calculates the distance between two points.
+ (float)distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    return sqrtf((point2.x - point1.x) * (point2.x - point1.x) + 
                 (point2.y - point1.y) * (point2.y - point1.y));
}

#pragma mark - Sending Commands to Render Points

//This method send point data to the renderView (GLView) as a Vertex array using the drawingColor and brush stored in the drawingTool.
- (void)drawWithPoints:(NSMutableArray *)points {
    [self.renderView setupTexture:self.drawingTool.brush.textureFilename];
    
    int numPoints = [points count];
    
    Vertex *vertices = malloc(sizeof(Vertex) * numPoints);
    
    Vertex vertex;
    
    CGPoint point;
    
    for (int i=0; i<numPoints; i++) {
        point = [[points objectAtIndex:i] CGPointValue];
        
        vertex.position.x = point.x;
        vertex.position.y = -point.y;
        vertex.color.r = self.drawingTool.drawingColor.r;
        vertex.color.g = self.drawingTool.drawingColor.g;
        vertex.color.b = self.drawingTool.drawingColor.b;
        vertex.color.a = self.drawingTool.drawingColor.a;
        
        vertices[i] = vertex;
    }
    
    [self.renderView addVertices:vertices withCount:numPoints];
    
    free(vertices);
}

//This method calls the clearScreen method of the renderView (GLView).
- (void)eraseScreen {
    [self.renderView clearScreen];
}

#pragma mark - Memory Management

- (void)dealloc {
    [self.renderView release];
    [self.pointBuffer release];
    [self.drawingTool release];
    
    [super dealloc];
}

@end
