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

#define kGalleryItemWidthSpacing 150.0
#define kGalleryItemHeightSpacing 200.0
#define kWaitingIconWidth 200.0
#define kWaitingIconHeight 200.0

@interface GalleryView : UIView <GalleryToolbarDelegate>

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

- (id)initWithFrame:(CGRect)frame andRootStack:(Stack *)rootStack;

- (void)fitToSize:(CGSize)size;

- (void)positionGalleryItemButtons;

- (IBAction)galleryItemButtonAction:(id)sender;

- (void)unselectAll;

- (void)openGalleryItem:(NSObject <GalleryItem> *)galleryItem;

- (void)displayDrawing:(Drawing *)drawing;

- (void)hideDisplayedDrawing;

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo;

@end
