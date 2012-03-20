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
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(switchToNormalMode)];
        
        UIBarButtonItem *editTutorialButton = [[UIBarButtonItem alloc]initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(showEditTutorial)];
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(deleteSelected)];
        
        UIBarButtonItem *exportButton = [[UIBarButtonItem alloc]initWithTitle:@"Export" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(exportSelected)];
        
        UIBarButtonItem *makeStackButton = [[UIBarButtonItem alloc]initWithTitle:@"Make Stack" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(makeStackFromSelected)];
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(switchToEditMode)];
        
        UIBarButtonItem *normalTutorialButton = [[UIBarButtonItem alloc]initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(showNormalTutorial)];
        
        UIBarButtonItem *newStackButton = [[UIBarButtonItem alloc]initWithTitle:@"New Stack" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(createNewStack)];
        
        UIBarButtonItem *newDrawingButton = [[UIBarButtonItem alloc]initWithTitle:@"New Drawing" style:UIBarButtonItemStyleBordered target:self.galleryToolbarDelegate action:@selector(createNewDrawing)];
        
        self.editModeButtons = [[NSArray alloc]initWithObjects:doneButton, editTutorialButton, spacer, deleteButton, exportButton, makeStackButton, nil];
        
        self.normalModeButtons = [[NSArray alloc]initWithObjects:editButton, normalTutorialButton, spacer, newStackButton, newDrawingButton, nil];
        
        [self switchToMode:NORMAL_MODE];
        
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
    }
    return self;
}

- (bool)switchToMode:(GalleryToolbarMode)mode {
    if (mode == EDIT_MODE) {
        [self setItems:self.editModeButtons animated:YES];
        _mode = EDIT_MODE;
    }
    
    if (mode == NORMAL_MODE) {
        [self setItems:self.normalModeButtons animated:YES];
        _mode = NORMAL_MODE;
    }
    
    return false;
}

- (bool)switchToNormalMode {
    return [self switchToMode:NORMAL_MODE];
}

- (bool)switchToEditMode {
    return [self switchToMode:EDIT_MODE];
}

- (void)dealloc {
    [self.editModeButtons release];
    [self.normalModeButtons release];
    
    [super dealloc];
}

@end
