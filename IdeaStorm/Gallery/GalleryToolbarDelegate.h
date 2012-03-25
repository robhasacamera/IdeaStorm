//
//  GalleryToolbarDelegate.h
//  IdeaStorm
//
//  Created by Robert Cole on 3/20/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GalleryToolbarDelegate <NSObject>

- (void)exportSelected;

- (void)deleteSelected;

- (void)makeStackFromSelected;

- (void)createNewStack;

- (void)createNewDrawing;

- (void)showNormalTutorial;

- (void)showEditTutorial;

- (void)modeChange;

@end
