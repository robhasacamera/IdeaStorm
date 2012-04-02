//
//  GalleryView.m
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "GalleryView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GalleryView

@synthesize rootStack = _rootStack;
@synthesize displayedStack = _displayedStack;
@synthesize scrollView = _scrollView;
@synthesize toolbar = _toolbar;
@synthesize selectedGalleryItem = _selectedGalleryItem;
@synthesize delegate = _delegate;
@synthesize positioningHelper = _positioningHelper;
@synthesize galleryItemButtons = _galleryItemButtons;
@synthesize drawingView = _drawingView;
@synthesize waitingIcon = _waitingIcon;
@synthesize normalTutorial = _normalTutorial;
@synthesize editTutorial = _editTutorial;

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
        
        self.positioningHelper.viewSpace = CGSizeMake(kGalleryItemWidthSpacing, kGalleryItemHeightSpacing);
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
    
    CGRect fullFrame = CGRectMake(0.0, 0.0, size.width, size.height);
    
    //init the drawingView if needed and set the frame
    if (!self.drawingView) {
        self.drawingView = [[UIImageView alloc]initWithFrame:fullFrame];
        
        [self addSubview:self.drawingView];
        
        self.drawingView.backgroundColor = [UIColor blackColor];
        
        self.drawingView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.drawingView.hidden = YES;
        
        self.drawingView.userInteractionEnabled = YES;
    }
    
    self.drawingView.frame = fullFrame;
    
    //init the normalTutorial if needed and set the frame
    if (!self.normalTutorial) {
        self.normalTutorial = [[TutorialOverlay alloc]initWithFrame:fullFrame];
        
        [self addSubview:self.normalTutorial];
        
        self.normalTutorial.portraitImage = [UIImage imageNamed:@"galleryNormalTutorialPortrait.png"];
        
        self.normalTutorial.portraitUpsideDownImage = [UIImage imageNamed:@"galleryNormalTutorialPortrait.png"];
        
        self.normalTutorial.landscapeLeftImage = [UIImage imageNamed:@"galleryNormalTutorialLandscape.png"];
        
        self.normalTutorial.landscapeRightImage = [UIImage imageNamed:@"galleryNormalTutorialLandscape.png"];
        
        self.normalTutorial.hidden = YES;
    }
    
    self.normalTutorial.frame = fullFrame;
    
    //init the editTutorial if needed and set the frame
    if (!self.editTutorial) {
        self.editTutorial = [[TutorialOverlay alloc]initWithFrame:fullFrame];
        
        [self addSubview:self.editTutorial];
        
        self.editTutorial.portraitImage = [UIImage imageNamed:@"galleryEditTutorialPortrait.png"];
        
        self.editTutorial.portraitUpsideDownImage = [UIImage imageNamed:@"galleryEditTutorialPortrait.png"];
        
        self.editTutorial.landscapeLeftImage = [UIImage imageNamed:@"galleryEditTutorialLandscape.png"];
        
        self.editTutorial.landscapeRightImage = [UIImage imageNamed:@"galleryEditTutorialLandscape.png"];
        
        self.editTutorial.hidden = YES;
    }
    
    self.editTutorial.frame = fullFrame;
    
    CGRect waitingIconFrame = CGRectMake(((size.width - kWaitingIconWidth) / 2), ((size.height - kWaitingIconHeight) / 2), kWaitingIconWidth, kWaitingIconHeight);
    
    if (!self.waitingIcon) {
        self.waitingIcon = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        self.waitingIcon.hidesWhenStopped = YES;
        
        [self addSubview:self.waitingIcon];
    }
    
    self.waitingIcon.frame = waitingIconFrame;
}

- (void)positionGalleryItemButtons {
    [self.positioningHelper gridPositionViews:self.galleryItemButtons usingWidth:self.scrollView.frame.size.width];
    
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
    UIButton *lastButton = ((UIButton *)[self.galleryItemButtons lastObject]);
    
    scrollViewContentSize.height = lastButton.center.y + (self.positioningHelper.viewSpace.height / 2);
    
    self.scrollView.contentSize = scrollViewContentSize;
}

- (void)displayDrawing:(Drawing *)drawing {
    if (self.drawingView.hidden) {
        [self.drawingView setImage:drawing.fullImage];
        self.drawingView.hidden = NO;
        self.drawingView.alpha = 0.0;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.drawingView.alpha = 1.0;
        }];
    }
}

- (void)hideDisplayedDrawing {
    if (!self.drawingView.hidden) {
        self.drawingView.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.drawingView.hidden) {
        [self hideDisplayedDrawing];
    }
    
    if (!self.normalTutorial.hidden) {
        [self showNormalTutorial];
    }
    
    if (!self.editTutorial.hidden) {
        [self showEditTutorial];
    }
}

#pragma mark - GalleryToolbarDelegate Methods

- (void)exportSelected {
    if ([self.selectedGalleryItem isKindOfClass:[Drawing class]]) {
        [self.waitingIcon startAnimating];
        
        UIImage *image = self.selectedGalleryItem.fullImage;
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)deleteSelected {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kDeleteGalleryItemAlertTitle message:@"Are you sure you want to delete this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:kDeleteGalleryItemAlertButtonTitle, nil];
    
    [alert show];
    
    [alert release];
}

- (void)makeStackFromSelected {
    if ([self.selectedGalleryItem isKindOfClass:[Drawing class]]) {
        [self.delegate makeStackFromDrawing:(Drawing *)self.selectedGalleryItem];
        
        self.displayedStack = self.displayedStack;
    }
}

- (void)createNewStack {
    //creat new stack
    Stack *stack = [[Stack alloc]init];
    
    //add as child of current stack
    [self.displayedStack addChild:stack];
    
    if (![self.delegate saveGalleryItem:self.displayedStack]) {
        NSLog(@"Error: There was issue saving the displayed stack.");
    }
    
    //save current stack
    if (![self.delegate saveGalleryItem:stack]) {
        NSLog(@"Error: There was an issue trying to save new stack.");
    }
    
    //set displayed stack to new stack
    self.displayedStack = stack;
    
    //call newDrawingForStack: using the new stack.
    [self.delegate newDrawingForStack:self.displayedStack];
}

- (void)createNewDrawing {
    [self.delegate newDrawingForStack:self.displayedStack];
}

- (void)showNormalTutorial {
    if (self.normalTutorial.hidden) {
        [self.normalTutorial displayOverlayWithDuration:kGalleryTutorialFadeTime];
    } else {
        [self.normalTutorial hideOverlayWithDuration:kGalleryTutorialFadeTime];
    }
}

- (void)showEditTutorial {
    if (self.editTutorial.hidden) {
        [self.editTutorial displayOverlayWithDuration:kGalleryTutorialFadeTime];
    } else {
        [self.editTutorial hideOverlayWithDuration:kGalleryTutorialFadeTime];
    }
}

- (void)modeChange {
    if (self.toolbar.mode != EDIT_MODE) {
        [self unselectAll];
    }
}

#pragma mark - Gallery Item Button Actions

- (IBAction)galleryItemButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (self.toolbar.mode == NORMAL_MODE) {
        [self openGalleryItem:(NSObject <GalleryItem> *)[self.displayedStack.children objectAtIndex:button.tag]];
    }
    
    bool buttonWasSelected = NO;
    
    if (self.toolbar.mode == EDIT_MODE) {
        
        if (button.layer.borderColor == [[UIColor redColor] CGColor]) {
            buttonWasSelected = YES;
        }
        
        [self unselectAll];
        
        if (!buttonWasSelected) {
            button.layer.borderColor = [[UIColor redColor] CGColor];
            button.layer.borderWidth = 3.0;
            
            _selectedGalleryItem = [(NSObject <GalleryItem> *)[self.displayedStack.children objectAtIndex:button.tag] retain];
            
            [self.toolbar setButtonsForSelection:self.selectedGalleryItem];
        }
    }
}

- (IBAction)upStackLevelButtonAction:(id)sender {
    if ([self.displayedStack.parent isKindOfClass:[Stack class]]) {
        self.displayedStack = (Stack *)self.displayedStack.parent;
        
        if (_selectedGalleryItem) {
            [_selectedGalleryItem release];
            
            _selectedGalleryItem = nil;
        }
        
        [self.toolbar setButtonsForSelection:nil];
    } else {
        NSLog(@"Error: Display Stack's parent is not a stack");
    }
}

#pragma mark - Data Management

//overrides the setter to display the contents of the root stack after setting the property
- (void)setRootStack:(Stack *)rootStack {
    _rootStack = rootStack;
    
    //display contents of root stack.
    self.displayedStack = rootStack;
}

//overrides the setter to display the contents of the stack after setting the property
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
        
        [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
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
    
    UIImage *stackBackground = [UIImage imageNamed:@"StackBackground.png"];
    
    //build buttons for galleryItems in stack
    for (int i=0; i<[self.displayedStack.children count]; i++) {
        float buttonWidth = kThumbWidth;
        float buttonHeight = kThumbHeight;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([[self.displayedStack.children objectAtIndex:i] isKindOfClass:[Stack class]]) {
            buttonWidth +=20;
            buttonHeight +=20;
            //set background image
            [button setBackgroundImage:stackBackground forState:UIControlStateNormal];
        } else {
            button.backgroundColor = [UIColor grayColor];
        }
        
        button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonHeight);
        
        //setting the button to reference the galleryItem is was created for.
        button.tag = i;
        
        [button addTarget:self action:@selector(galleryItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.galleryItemButtons addObject:button];
    }
    
    //insert the up stack level button if this is not the root stack
    if (notRootStack) {
        //insert upstack button at index 0
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.backgroundColor = [UIColor grayColor];
        
        button.frame = CGRectMake(0.0, 0.0, kThumbWidth, kThumbHeight);
        
        [button addTarget:self action:@selector(upStackLevelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setImage:[UIImage imageNamed:@"UpStackLevelIcon.png"] forState:UIControlStateNormal];
        
        [self.galleryItemButtons insertObject:button atIndex:0];
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
        
        [button setImage:galleryItem.thumbnailImage forState:UIControlStateNormal];
        
                
        buttonIndex++;
    }
}

- (void)unselectAll {
    UIButton *button;
    
    for (int i=0; i<[self.galleryItemButtons count]; i++) {
        button = (UIButton *)[self.galleryItemButtons objectAtIndex:i];
        
        button.layer.borderColor = [[UIColor clearColor] CGColor];
        button.layer.borderWidth = 0.0;
        
        [_selectedGalleryItem release];
        
        _selectedGalleryItem = nil;
        
        [self.toolbar setButtonsForSelection:self.selectedGalleryItem];
    }
    
    _selectedGalleryItem = nil;
}

- (void)openGalleryItem:(NSObject <GalleryItem> *)galleryItem {
    if ([galleryItem isKindOfClass:[Stack class]]) {
        self.displayedStack = (Stack *)galleryItem;
    }
    
    if ([galleryItem isKindOfClass:[Drawing class]]) {
        [self displayDrawing:(Drawing *)galleryItem];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo {
    UIAlertView *alert;
    
    if (error != nil) {
        alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an issue saving the selected drawing, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    } else {
        alert = [[UIAlertView alloc]initWithTitle:@"Exported Drawing" message:@"The drawing has been saved to your camera roll." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    [self.waitingIcon stopAnimating];
    
    [alert show];
    
    [alert release];
}

#pragma mark - UIAlertViewDelegateMethods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.title == kDeleteGalleryItemAlertTitle && [alertView buttonTitleAtIndex:buttonIndex] == kDeleteGalleryItemAlertButtonTitle) {
        [self.delegate deleteGalleryItem:self.selectedGalleryItem];
        
        _selectedGalleryItem = nil;
        
        [self.toolbar setButtonsForSelection:self.selectedGalleryItem];
        
        //refresh the display
        self.displayedStack = self.displayedStack;
    }
}

#pragma mark - Memory Management

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
    
    if (self.drawingView) {
        [self.drawingView release];
    }
    
    if (self.waitingIcon) {
        [self.waitingIcon release];
    }
    
    if (self.normalTutorial) {
        [self.normalTutorial release];
    }
    
    if (self.editTutorial) {
        [self.editTutorial release];
    }
    
    [super dealloc];
}

@end
