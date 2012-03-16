//
//  GalleryView.h
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stack.h"
#import "GalleryToolbar.h"

@interface GalleryView : UIView

@property (nonatomic, retain) Stack *rootStack;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GalleryToolbar *toolbar;
@property (nonatomic, readonly) GalleryView *selectedGalleryItem;

- (id)initWithFrame:(CGRect)frame andRootStack:(Stack *)rootStack;


- (void)fitToSize:(CGSize)size;

@end
