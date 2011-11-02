//
//  DrawingTool.h
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLView.h"

@protocol DrawingTool <NSObject>

@required

//This property should be read after the verticesFromPoint:andDrawingColor:andPointSize:isLastPoint: to get the size of the array produced. This is done instead of putting both the vertices array and the size in a NSDictionary as this is more efficient then wrapping the vertices array into an object for the NSDictionary and then unpacking the vertices to render them.
@property (nonatomic) int numVerticesCreated;

- (Vertex *)verticesFromPoint:(CGPoint)point andDrawingColor:(Color)color andPointSize:(CGFloat)size isLastPoint:(bool)lastPoint;

@end
