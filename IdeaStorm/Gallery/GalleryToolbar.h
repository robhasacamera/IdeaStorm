//
//  GalleryToolbar.h
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EDIT_MODE,
    NORMAL_MODE
} GalleryToolbarMode;

@interface GalleryToolbar : UIToolbar

@property (strong, nonatomic) NSArray *editModeButtons;
@property (strong, nonatomic) NSArray *normalModeButtons;
@property (nonatomic, readonly) GalleryToolbarMode mode;

- (bool)switchToMode:(GalleryToolbarMode)mode;

- (bool)switchToNormalMode;

- (bool)switchToEditMode;

@end
