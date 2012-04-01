//
//  GalleryView.h
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stack.h"
#import "Drawing.h"
#import "GalleryItem.h"
#import "GalleryToolbar.h"
#import "GalleryViewDelegate.h"
#import "GalleryToolbarDelegate.h"
#import "PositioningHelper.h"
#import "TutorialOverlay.h"

#define kGalleryItemWidthSpacing 150.0
#define kGalleryItemHeightSpacing 200.0
#define kWaitingIconWidth 200.0
#define kWaitingIconHeight 200.0
#define kDeleteGalleryItemAlertTitle @"Delete"
#define kDeleteGalleryItemAlertButtonTitle @"Delete"
#define kGalleryTutorialFadeTime 0.50

@interface GalleryView : UIView <GalleryToolbarDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) Stack *rootStack;
@property (nonatomic, retain) Stack *displayedStack;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GalleryToolbar *toolbar;
@property (nonatomic, readonly) NSObject <GalleryItem> *selectedGalleryItem;
@property (nonatomic, retain) NSObject <GalleryViewDelegate> *delegate;
@property (nonatomic, retain) PositioningHelper *positioningHelper;
@property (nonatomic, retain) NSMutableArray *galleryItemButtons;
@property (nonatomic, retain) UIImageView *drawingView;
@property (nonatomic, retain) UIActivityIndicatorView *waitingIcon;
@property (nonatomic, strong) TutorialOverlay *normalTutorial;
@property (nonatomic, strong) TutorialOverlay *editTutorial;

- (id)initWithFrame:(CGRect)frame andRootStack:(Stack *)rootStack;

- (void)fitToSize:(CGSize)size;

- (void)positionGalleryItemButtons;

- (IBAction)galleryItemButtonAction:(id)sender;

- (IBAction)upStackLevelButtonAction:(id)sender;

- (void)unselectAll;

- (void)openGalleryItem:(NSObject <GalleryItem> *)galleryItem;

- (void)displayDrawing:(Drawing *)drawing;

- (void)hideDisplayedDrawing;

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo;

@end
