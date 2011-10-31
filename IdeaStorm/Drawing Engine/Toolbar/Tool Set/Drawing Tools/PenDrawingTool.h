//
//  PenDrawingTool.h
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawingTool.h"
#import "ToolbarItem.h"
#import "DrawingEngine.h"

@interface PenDrawingTool : ToolbarItem <DrawingTool>

@property (strong, nonatomic) NSMutableArray *pointBuffer;

@end
