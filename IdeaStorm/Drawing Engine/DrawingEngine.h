//
//  DrawingEngine.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/22/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

//the higher this is the more curve is applied towards points
#define kCurveCoefficient 0.15
//the higher this is the more accurate the estimate of the curve's length
#define kNumCurveEstimatePoints 10

#import <Foundation/Foundation.h>
#import "GLView.h"
#import "Database.h"
#import "PenDrawingTool.h"
#import "PencilDrawingTool.h"
#import "EraserDrawingTool.h"
#import <malloc/malloc.h>
#import "ToolSet.h"
#import "Stack.h"
#import "Drawing.h"

@interface DrawingEngine : NSObject

@property (strong, nonatomic) GLView *renderView;
@property (strong, nonatomic) NSMutableArray *pointBuffer;
@property (nonatomic) float spaceBetweenPoints;
@property (strong, nonatomic) ToolSet *activeToolSet;
@property (strong, nonatomic) ToolSet *reserveToolSet;
@property (nonatomic, retain) Database *database;
@property (strong, nonatomic) Drawing *drawing;
@property (nonatomic, retain) UIViewController *viewController;
@property (readonly) bool drawingStarted;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame andDatabase:(Database *)database;

#pragma mark - Commands that render points.

- (void)drawWithTouch:(NSSet *)touches;

- (void)eraseScreen;

#pragma mark - Point Calculations

//TODO: Need to rename these to more appropiate names.
+ (NSMutableArray *)interpolateCurvePointsWithCurvePoints:(NSMutableArray *)points withSpace:(float)spaceBetweenPoints andLastPoint:(bool)lastPoint;

+ (NSMutableArray *)interpolateCurvePoints:(NSMutableArray *)points withSpace:(float)spaceBetweenPoints;

+ (NSMutableArray *)interpolateCurvePoints:(NSMutableArray *)points withPointCount:(int)numPoints;

+ (NSMutableArray *)interpolateLinePoints:(NSMutableArray *)points withSpace:(float)spaceBetweenPoints;

#pragma mark -

+ (NSMutableArray *)calculateCurveControlPoints:(NSMutableArray *)points;

+ (float)estimateCurveLength:(NSMutableArray *)points;

+ (float)distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2;

#pragma mark - Tool Commands

- (void)switchActiveAndReserveToolSets;

#pragma mark - Working With Drawing Data

- (bool)saveCurrentDrawing;

- (void)loadDrawing:(Drawing *)drawing;

- (void)newDrawingForStack:(Stack *)stack;

- (bool)saveAndAddDrawing;

@end
