//
//  GalleryView.m
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "GalleryView.h"

@implementation GalleryView

@synthesize rootStack = _rootStack;
@synthesize scrollView = _scrollView;
@synthesize toolbar = _toolbar;

#pragma mark - Initialization

//Initializes with a default frame equal to the bounds of the main screen.
- (id)init {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    self = [self initWithFrame:screenBounds];
    
    return self;
}


//Initializes the gallery view with a custom frame.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fitToSize:frame.size];
        
        self.scrollView.backgroundColor = [UIColor blueColor];
    }
    return self;
}

//Initializes the gallery view with a custom frame and the root stack provided.
- (id)initWithFrame:(CGRect)frame andRootStack:(Stack *)rootStack {
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - View Management

//TODO: Need a method to reposition the gallery icons.

//TODO: Need add repositioning the galleryitem icons.
- (void)fitToSize:(CGSize)size {
    
    //resizing the GalleryView
    CGRect galleryViewFrame;
    
    galleryViewFrame.size = size;
    
    self.frame = galleryViewFrame;
    
    //reszing the toolbar
    float toolbarHeight = 44;
    CGRect toolbarFrame;
    
    toolbarFrame.size.height = toolbarHeight;
    toolbarFrame.size.width = size.width;
    toolbarFrame.origin.x = 0;
    toolbarFrame.origin.y = size.height - toolbarFrame.size.height;
    
    if (!self.toolbar) {
        self.toolbar = [[GalleryToolbar alloc]initWithFrame:toolbarFrame];
        [self addSubview:self.toolbar];
    } else {
        self.toolbar.frame = toolbarFrame;
    }
    
    [self.toolbar sizeToFit];
    
    //correction for toolbar sizing in case the toolbar height property is ever changed for sizeThatFits methods.
    if (toolbarFrame.size.height != self.toolbar.frame.size.height) {
        toolbarFrame.origin.y = size.height - self.toolbar.frame.size.height;
    }
    
    CGRect scrollViewFrame;
    
    scrollViewFrame.origin.x = 0;
    scrollViewFrame.origin.y = 0;
    scrollViewFrame.size = size;
    scrollViewFrame.size.height -= self.toolbar.frame.size.height;
    
    //resizing the scrollView
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:scrollViewFrame];
        [self addSubview:self.scrollView];
    } else {
        self.scrollView.frame = scrollViewFrame;
    }
    
    //need to reposition all the GalleryItem Icons here.
}


#pragma mark - Data Management

//overrides the setter to display the contents of the root stack after setting the property
- (void)setRootStack:(Stack *)rootStack {
    _rootStack = rootStack;
    
    //display contents of root stack.
}

- (void)dealloc {
    if (self.toolbar) {
        [self.toolbar release];
    }
    
    if (self.scrollView) {
        [self.scrollView release];
    }
}

@end
