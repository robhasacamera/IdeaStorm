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

//TODO: need to get and display contents of stack here.
- (void)setDisplayedStack:(Stack *)displayedStack {
    
    
    //get and display contents of stack.
    
    if (!self.galleryItemButtons) {
        self.galleryItemButtons = [[NSMutableArray alloc]initWithCapacity:[self.displayedStack.children count]];
    }
    
    UIButton *button;
    
    //releasing stored buttons to free memory
    for (int i=0; i<[self.galleryItemButtons count]; i++) {
        button = ((UIButton *)[self.galleryItemButtons objectAtIndex:i]);
        
        [self.galleryItemButtons removeObjectAtIndex:i];
        
        [button release];
    }
    
    //releasing stored thumbnail images to free memory
    if (_displayedStack.children) {
        NSObject <GalleryItem> *galleryItem;
        
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
        
        [self.galleryItemButtons addObject:button];
    }
    
    //insert the up stack level button if this is not the root stack
    if (displayedStack.pathID != self.rootStack.pathID) {
        //insert upstack button at index 0
    }
    
    //position the gallery buttons
    [self positionGalleryItemButtons];
    
    //add the buttons to the scrollView.
    for (int i=0; i<[self.galleryItemButtons count]; i++) {
        button = ((UIButton *)[self.galleryItemButtons objectAtIndex:i]);
        
        [self.scrollView addSubview:button];
    }
    
    
    
    //create new buttons
        //if this is not the rootStack add the up level button first
        //set background of buttons to grey
        //set hieght and width using a constant height and width
        //set action of buttons to open the child the are related to
            //maybe by setting the id of the button to the index of the corresponding child.
    
    //set position of all the buttons
        //need to make a method or class that can do this
    
    //set the contentHeight of the scrollView depending on the last buttons position
    
    //add buttons to the scrollView
    
    //load the thumbImages into the buttons.
    
    
    
    //NOTES
    //if there are elements that are currently displayed, released them to free up memory
    //so [button.image release] and then [button release]
    
    //build the new buttons with a gray background, add their functionality, position them and then add the images last
    //this way the buttons are there immediately even if it takes the images a while to load.
    //need to have an array of the buttons that can be tracked and repositioned when in the fitToSize method
    
    //then build new array of buttons, getting the thumb images from the children of the displayedStack
    //get the current size of the scrollview
    //set the position of the buttons according to the width of the scrollview
    
    //set the max content hieght of the scrollview to be a little longer then the last button's y position plus hieght
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
