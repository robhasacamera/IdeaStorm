//
//  GalleryViewController.m
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "GalleryViewController.h"

@implementation GalleryViewController

@synthesize drawingEngine = _drawingEngine;
@synthesize galleryView = _galleryView;
@synthesize database = _database;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDatabase:(Database *)database {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

//overrides the setter to load the rootStack into the galleryView after setting the database.
- (void)setDatabase:(Database *)database {
    _database = database;
    
    //load the rootStack into the galleryView
}

@end
