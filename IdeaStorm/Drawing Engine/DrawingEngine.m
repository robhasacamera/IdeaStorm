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
@synthesize activeToolSet = _activeToolSet;
@synthesize reserveToolSet = _reserveToolSet;

#pragma mark - Initialization

//Initializes with a default frame equal to the bounds of the main screen.
- (id)init {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    self = [self initWithFrame:screenBounds];
    
    return self;
}

//TODO: Initiaize reserveToolSet.
//Initializes the drawing engine with a custom frame.
- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    
    if (self) {
        self.renderView = [[GLView alloc]initWithFrame:frame];
        self.pointBuffer = [[NSMutableArray alloc]initWithCapacity:4];
        self.spaceBetweenPoints = 1.0;
        
        NSObject <DrawingTool> *aDrawingTool = [[PenDrawingTool alloc]init];
        
        Brush *aBrush = [[Brush alloc]initWithTexture:@"Particle.png"];
        
        Color color;
        
        color.r = 0.0;
        color.g = 0.0;
        color.b = 0.0;
        color.a = 1.0;
        
        DrawingColor *aDrawingColor = [[DrawingColor alloc]initWithColor:color];
        
        self.activeToolSet = [[ToolSet alloc]initWithDrawingTool:aDrawingTool andBrush:aBrush andDrawingColor:aDrawingColor andPointSize:10.0];
        
        [aDrawingColor release];
        
        [aBrush release];
        
        [aDrawingTool release];
    }
    
    return self;
}

#pragma mark - Touch Data Handling

//Creates a drawing in the renderView (GLView) using the ouch data provided.
- (void)drawWithTouch:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    
    //touch began is ignored as it creates extra points for a drawing made of dots
    if (touch.phase != UITouchPhaseBegan) {
        
        CGPoint point = [touch locationInView:self.renderView];
        
        int tapCount = touch.tapCount;
        
        bool lastTouch = NO;
        
        if (touch.phase == UITouchPhaseEnded) {
            lastTouch = YES;
        }
        
        [self.renderView setupTexture:self.activeToolSet.brush.textureFilename];
        
        Vertex *vertices = [self.activeToolSet.drawingTool verticesFromPoint:point andDrawingColor:self.activeToolSet.drawingColor.color andPointSize:self.activeToolSet.pointSize isLastPoint:lastTouch];
        
        [self.renderView addVertices:vertices withCount:self.activeToolSet.drawingTool.numVerticesCreated];
        
        if (tapCount == 2) {
            [self eraseScreen];
        }
    }//END if (touch.phase != UITouchPhaseBegan)
}

#pragma mark - Point Calculations

//TODO: Update this comment
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

//This method calls the clearScreen method of the renderView (GLView).
- (void)eraseScreen {
    [self.renderView clearScreen];
}

#pragma mark - Memory Management

- (void)dealloc {
    [self.renderView release];
    [self.pointBuffer release];
    [self.activeToolSet release];
    [self.reserveToolSet release];
    
    [super dealloc];
}

@end
