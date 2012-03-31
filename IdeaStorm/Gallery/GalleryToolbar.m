//
//  GalleryToolbar.m
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "GalleryToolbar.h"

@implementation GalleryToolbar

@synthesize editModeButtons = _editModeButtons;
@synthesize normalModeButtons = _normalModeButtons;
@synthesize mode = _mode;
@synthesize galleryToolbarDelegate = _galleryToolbarDelegate;

//TODO: Need to add targets and actions for other buttons.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(switchToNormalMode)];
        
        editTutorialButton = [[UIBarButtonItem alloc]initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(showEditTutorial)];
        
        spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(deleteSelected)];
        
        exportButton = [[UIBarButtonItem alloc]initWithTitle:@"Export" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(exportSelected)];
        
        makeStackButton = [[UIBarButtonItem alloc]initWithTitle:@"Make Stack" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(makeStackFromSelected)];
        
        editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(switchToEditMode)];
        
        normalTutorialButton = [[UIBarButtonItem alloc]initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(showNormalTutorial)];
        
        newStackButton = [[UIBarButtonItem alloc]initWithTitle:@"New Stack" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(createNewStack)];
        
        newDrawingButton = [[UIBarButtonItem alloc]initWithTitle:@"New Drawing" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(createNewDrawing)];
        
        self.editModeButtons = [[NSArray alloc]initWithObjects:doneButton, editTutorialButton, spacer, deleteButton, exportButton, makeStackButton, nil];
        
        self.normalModeButtons = [[NSArray alloc]initWithObjects:editButton, normalTutorialButton, spacer, newStackButton, newDrawingButton, nil];
        
        [self switchToMode:NORMAL_MODE];
    }
    return self;
}

- (bool)switchToMode:(GalleryToolbarMode)mode {
    bool success = NO;
    
    if (mode == EDIT_MODE) {
        [self setItems:self.editModeButtons animated:YES];
        _mode = EDIT_MODE;
        
        success = YES;
    }
    
    if (mode == NORMAL_MODE) {
        [self setItems:self.normalModeButtons animated:YES];
        _mode = NORMAL_MODE;
        
        success = YES;
    }
    
    if (success) {
        [self setDefaultsForEditMode];
    }
    
    return false;
}

- (bool)switchToNormalMode {
    bool success = [self switchToMode:NORMAL_MODE];
    
    [self.galleryToolbarDelegate modeChange];
    
    return success;
}

- (bool)switchToEditMode {
    bool success = [self switchToMode:EDIT_MODE];
    
    [self.galleryToolbarDelegate modeChange];
    
    return success;
}

- (void)setButtonsForSelection:(id)selection {
    
    
    if (self.mode == EDIT_MODE && [selection conformsToProtocol:@protocol(GalleryItem)]) {
        if ([selection isKindOfClass:[Drawing class]]) {
            exportButton.enabled = YES;
            makeStackButton.enabled = YES;
        }
        
        deleteButton.enabled = YES;
    } else {
        [self setDefaultsForEditMode];
    }
}

- (void)setDefaultsForEditMode {
    deleteButton.enabled = NO;
    exportButton.enabled = NO;
    makeStackButton.enabled = NO;
}

- (void)dealloc {
    [self.editModeButtons release];
    [self.normalModeButtons release];
    
    [doneButton release];
    
    [editTutorialButton release];
    
    [spacer release];
    
    [deleteButton release];
    
    [exportButton release];
    
    [makeStackButton release];
    
    [editButton release];
    
    [normalTutorialButton release];
    
    [newStackButton release];
    
    [newDrawingButton release];
    
    [super dealloc];
}

@end
