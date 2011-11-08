//
//  EraserDrawingTool.h
//  IdeaStorm
//
//  Created by Robert Cole on 11/7/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawingTool.h"
#import "ToolbarItem.h"
#import "DrawingEngine.h"

@interface EraserDrawingTool : ToolbarItem <DrawingTool>

@property (nonatomic, strong) NSMutableArray *pointBuffer;

@end
