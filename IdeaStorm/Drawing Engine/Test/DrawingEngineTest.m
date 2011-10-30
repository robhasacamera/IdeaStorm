//
//  DrawingEngineTest.m
//  IdeaStorm
//
//  Created by Robert Cole on 9/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawingEngineTest.h"

@implementation DrawingEngineTest

- (id)init {
    self = [super init];
    
    if (self) {
        //setup
    }
    
    return self;
}

+ (BOOL)testCalculateCurveControlPoints:(BOOL)dumpToConsole {
    BOOL pass = NO;
    
    CGPoint p0;
    CGPoint p1;
    CGPoint p2;
    CGPoint p3;
    
    p0.x = -1;
    p0.y = -3;
    
    p1.x = 1;
    p1.y = 4;
    
    p2.x = 6;
    p2.y = 6;
    
    p3.x = 10;
    p3.y = 3;
    
    NSMutableArray *testInput = [[[NSMutableArray alloc]initWithObjects:[NSValue valueWithCGPoint:p0], [NSValue valueWithCGPoint:p1], [NSValue valueWithCGPoint:p2], [NSValue valueWithCGPoint:p3], nil] autorelease];
    
    NSMutableArray *testOutput = [DrawingEngine calculateCurveControlPoints:testInput];
    
    if (testOutput && [testOutput count] == 2) {
        pass = YES;
    }
    
    if (dumpToConsole) {
        NSLog(@"--BEGIN testCalculateCurveControlPoints Dump");
        
        CGPoint point;
        
        for (int i=0; i < [testOutput count]; i++) {
            point = [[testOutput objectAtIndex:i] CGPointValue];
            
            NSLog(@"control point %i x = %f, y = %f", i, point.x, point.y);
        }
        
        NSLog(@"--END testCalculateCurveControlPoints Dump");
    }
    
    return pass;
}

+ (BOOL)testInterpolateLinePoints:(BOOL)dumpToConsole {
    BOOL pass = NO;
    
    NSMutableArray *testInput = [[[NSMutableArray alloc]initWithCapacity:2] autorelease];
    
    NSMutableArray *testOutput = NULL;
    
    CGPoint point1;
    CGPoint point2;
    
    float spaceBetweenPoints = 1.0;
    
    int expectedPointCount = 6;
    
    point1.x = 2.0;
    point1.y = 1.0;
    
    point2.x = 6.0;
    point2.y = 4.0;
    
    [testInput addObject:[NSValue valueWithCGPoint:point1]];
    [testInput addObject:[NSValue valueWithCGPoint:point2]];
    
    testOutput = [DrawingEngine interpolateLinePoints:testInput withSpace:spaceBetweenPoints];
    
    if (testOutput && [testOutput count] == expectedPointCount) {
        pass = YES;
    }
    
    if (dumpToConsole) {
        NSLog(@"--BEGIN testInterpolateLinePoints Dump");
        
        CGPoint point;
        
        for (int i=0; i < [testOutput count]; i++) {
            point = [[testOutput objectAtIndex:i] CGPointValue];
            
            NSLog(@"line point %i x = %f, y = %f", i, point.x, point.y);
        }
        
        NSLog(@"--END testInterpolateLinePoints Dump");
    }
    
    return pass;
}

+ (BOOL)testInterpolateCurveControlPoints:(BOOL)dumpToConsole {
    BOOL pass = NO;
    
    CGPoint p0;
    CGPoint p1;
    CGPoint p2;
    CGPoint p3;
    
    p0.x = -1;
    p0.y = -3;
    
    p1.x = 1;
    p1.y = 4;
    
    p2.x = 6;
    p2.y = 6;
    
    p3.x = 10;
    p3.y = 3;
    
    float spaceBetweenPoints = 1.0;
    
    NSMutableArray *testInput = [[[NSMutableArray alloc]initWithObjects:[NSValue valueWithCGPoint:p0], [NSValue valueWithCGPoint:p1], [NSValue valueWithCGPoint:p2], [NSValue valueWithCGPoint:p3], nil] autorelease];
    
    NSMutableArray *testOuput = [DrawingEngine interpolateCurvePoints:testInput withSpace:spaceBetweenPoints];
    
    if (testOuput && [testOuput count] == 13) {
        pass = YES;
    }
    
    if (dumpToConsole) {
        NSLog(@"--BEGIN testInterpolateCurveControlPoints Dump");
        
        NSLog(@"Curve Point Count = %i", [testOuput count]);
        
        CGPoint point;
        
        for (int i=0; i<[testOuput count]; i++) {
            point = [[testOuput objectAtIndex:i] CGPointValue];
            
            NSLog(@"curve point %i x = %f, y = %f", i, point.x, point.y);
        }
        
        NSLog(@"--END testInterpolateCurveControlPoints Dump");
    }
    
    return pass;
}

@end
