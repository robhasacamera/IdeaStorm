//
//  PencilDrawingTool.h
//  IdeaStorm
//
//  Created by Robert Cole on 11/7/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawingTool.h"
#import "ToolbarItem.h"
#import "DrawingEngine.h"

#define kPointSizeFactor 30
#define kPointSizeMin 3

@interface PencilDrawingTool : ToolbarItem <DrawingTool> {
    float startPointSize;
    float endPointSize;
}

@property (strong, nonatomic) NSMutableArray *pointBuffer;

@end
