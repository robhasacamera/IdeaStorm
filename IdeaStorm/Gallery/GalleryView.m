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
@synthesize displayedStack = _displayedStack;
@synthesize scrollView = _scrollView;
@synthesize toolbar = _toolbar;
@synthesize selectedGalleryItem = _selectedGalleryItem;
@synthesize delegate = _delegate;
@synthesize positioningHelper = _positioningHelper;
@synthesize galleryItemButtons = _galleryItemButtons;

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
        
        self.scrollView.backgroundColor = [UIColor blackColor];
        
        self.positioningHelper = [[PositioningHelper alloc]init];
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
        self.toolbar.galleryToolbarDelegate = self;
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
    
    if (self.displayedStack) {
        [self positionGalleryItemButtons];
    }
}

- (void)positionGalleryItemButtons {
    [self.positioningHelper gridPositionViews:self.galleryItemButtons usingWidth:self.scrollView.frame.size.width];
    
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
    UIButton *lastButton = ((UIButton *)[self.galleryItemButtons lastObject]);
    
    scrollViewContentSize.height = lastButton.center.y + self.positioningHelper.viewSpace.height;
    
    self.scrollView.contentSize = scrollViewContentSize;
}

#pragma mark - GalleryToolbarDelegate Methods

- (void)exportSelected {
    NSLog(@"export");
}

- (void)deleteSelected {
    NSLog(@"Delete");
}

- (void)makeStackFromSelected {
    NSLog(@"Make Stack");
}

- (void)createNewStack {
    NSLog(@"New Stack");
    //creat new stack
    //add as child of current stack
    //call newDrawingForStack: using the new stack.
}

//TODO: This is incomplete.
- (void)createNewDrawing {
    [self.delegate newDrawingForStack:self.displayedStack];
}

- (void)showNormalTutorial {
    NSLog(@"Normal Tutorial");
}

- (void)showEditTutorial {
    NSLog(@"Edit Tutorial");
}


#pragma mark - Data Management

//overrides the setter to display the contents of the root stack after setting the property
- (void)setRootStack:(Stack *)rootStack {
    _rootStack = rootStack;
    
    //display contents of root stack.
    self.displayedStack = rootStack;
}

//TODO: Need to add button actions, add thumbnail to the buttons and add up stack level button
- (void)setDisplayedStack:(Stack *)displayedStack {
    bool notRootStack = YES;
    
    if (displayedStack.pathID == self.rootStack.pathID) {
        notRootStack = NO;
    }
    
    //get and display contents of stack.
    
    if (!self.galleryItemButtons) {
        self.galleryItemButtons = [[NSMutableArray alloc]initWithCapacity:[self.displayedStack.children count]];
    }
    
    UIButton *button;
    NSObject <GalleryItem> *galleryItem;
    
    //removing buttons from scrollview
    for (int i=0; i<[self.galleryItemButtons count]; i++) {
        button = ((UIButton *)[self.galleryItemButtons objectAtIndex:i]);
        
        [button removeFromSuperview];
    }
    
    //releasing stored buttons to free memory
    [self.galleryItemButtons removeAllObjects];
    
    //releasing stored thumbnail images to free memory
    if (_displayedStack.children) {
        
        
        for (int i=0; i<[_displayedStack.children count]; i++) {
            galleryItem = ((NSObject <GalleryItem> *)[_displayedStack.children objectAtIndex:i]);
            
            if (galleryItem.thumbnailImage) {
                [galleryItem.thumbnailImage release];
            }
        }
    }
    
    _displayedStack = displayedStack;
    
    //build buttons for galleryItems in stack
    for (int i=0; i<[self.displayedStack.children count]; i++) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.backgroundColor = [UIColor grayColor];
        
        button.frame = CGRectMake(0.0, 0.0, kThumbWidth, kThumbHeight);
        
        //add button action here!
        
        //might need to set id too
        
        [self.galleryItemButtons addObject:button];
    }
    
    //insert the up stack level button if this is not the root stack
    if (notRootStack) {
        //insert upstack button at index 0
    }
    
    //position the gallery buttons
    [self positionGalleryItemButtons];
    
    //add the buttons to the scrollView.
    for (int i=0; i<[self.galleryItemButtons count]; i++) {
        button = ((UIButton *)[self.galleryItemButtons objectAtIndex:i]);
        
        [self.scrollView addSubview:button];
    }
    
    int buttonIndex = 0;
    
    //will need to start at the second button if the up stack level button is present
    if (notRootStack) {
        buttonIndex++;
    }
    
    //load button images here!
    for (int i=0; i<[self.displayedStack.children count]; i++) {
        button = [((UIButton *)[self.galleryItemButtons objectAtIndex:buttonIndex]) retain];
        galleryItem = ((NSObject <GalleryItem> *)[_displayedStack.children objectAtIndex:i]);
        
        [button setImage:galleryItem.fullImage forState:UIControlStateNormal];
        
        buttonIndex++;
    }
}

- (void)dealloc {
    if (self.toolbar) {
        [self.toolbar release];
    }
    
    if (self.scrollView) {
        [self.scrollView release];
    }
    
    if (self.positioningHelper) {
        [self.positioningHelper release];
    }
    
    [super dealloc];
}

@end
