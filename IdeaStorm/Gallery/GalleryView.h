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

@interface GalleryView : UIView <GalleryToolbarDelegate>

@property (nonatomic, retain) Stack *rootStack;
@property (nonatomic, retain) Stack *displayedStack;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GalleryToolbar *toolbar;
@property (nonatomic, readonly) NSObject <GalleryItem> *selectedGalleryItem;
@property (nonatomic, retain) NSObject <GalleryViewDelegate> *delegate;
@property (nonatomic, retain) PositioningHelper *positioningHelper;
@property (nonatomic, retain) NSMutableArray *galleryItemButtons;

- (id)initWithFrame:(CGRect)frame andRootStack:(Stack *)rootStack;

- (void)fitToSize:(CGSize)size;

- (void)positionGalleryItemButtons;

@end
