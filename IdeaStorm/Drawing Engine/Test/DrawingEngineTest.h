//
//  DrawingEngineTest.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/24/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawingEngine.h"

@interface DrawingEngineTest : NSObject

+ (BOOL)testInterpolateLinePoints:(BOOL)dumpToConsole;

+ (BOOL)testCalculateCurveControlPoints:(BOOL)dumpToConsole;

+ (BOOL)testInterpolateCurveControlPoints:(BOOL)dumpToConsole;

@end
