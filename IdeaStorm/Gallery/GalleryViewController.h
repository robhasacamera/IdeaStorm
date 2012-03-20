//
//  GalleryViewController.h
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingViewController.h"
#import "GalleryView.h"
#import "Database.h"
#import "GalleryViewDelegate.h"

@interface GalleryViewController : UIViewController <GalleryViewDelegate>

@property (nonatomic, retain) DrawingViewController *drawingViewController;
@property (nonatomic, retain) GalleryView *galleryView;
@property (nonatomic, retain) Database *database;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDatabase:(Database *)database;

@end
