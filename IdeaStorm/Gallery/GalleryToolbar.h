//
//  GalleryToolbar.h
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryToolbarDelegate.h"
#import "GalleryItem.h"
#import "Stack.h"
#import "Drawing.h"

typedef enum {
    EDIT_MODE,
    NORMAL_MODE
} GalleryToolbarMode;

@interface GalleryToolbar : UIToolbar {
    UIBarButtonItem *doneButton;
    UIBarButtonItem *editTutorialButton;
    UIBarButtonItem *spacer;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *exportButton;
    UIBarButtonItem *makeStackButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *normalTutorialButton;
    UIBarButtonItem *newStackButton;
    UIBarButtonItem *newDrawingButton;
}

@property (strong, nonatomic) NSArray *editModeButtons;
@property (strong, nonatomic) NSArray *normalModeButtons;
@property (nonatomic, readonly) GalleryToolbarMode mode;
@property (nonatomic, retain) NSObject <GalleryToolbarDelegate> *galleryToolbarDelegate;

- (bool)switchToMode:(GalleryToolbarMode)mode;

- (bool)switchToNormalMode;

- (bool)switchToEditMode;

- (void)setButtonsForSelection:(id)selection;

- (void)setDefaultsForEditMode;

@end
