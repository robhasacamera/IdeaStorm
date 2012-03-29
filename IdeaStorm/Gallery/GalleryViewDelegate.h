//
//  GalleryViewDelegate.h
//  IdeaStorm
//
//  Created by Robert Cole on 3/19/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GalleryItem.h"
#import "Drawing.h"
#import "Stack.h"

@protocol GalleryViewDelegate <NSObject>

- (void)openDrawing:(Drawing *)drawing;

- (bool)exportGalleryItem:(NSObject <GalleryItem> *)galleryItem;

- (bool)deleteGalleryItem:(NSObject <GalleryItem> *)galleryItem;

- (void)newDrawingForStack:(Stack *)stack;

- (Stack *)createStackFromDrawing:(Drawing *)drawing;

@end
