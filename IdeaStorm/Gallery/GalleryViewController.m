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
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil andDatabase:nil];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDatabase:(Database *)database {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (database) {
            //init GalleryView using rootStack from database provide
        } else {
            //init without database
            self.galleryView = [[GalleryView alloc]initWithFrame:self.view.frame];
        }
        
        [self.view addSubview:self.galleryView];
        
        self.view.backgroundColor = [UIColor redColor];
        self.galleryView.backgroundColor = [UIColor grayColor];
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


//TODO: Need to check for and change GalleryView here.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    [self.galleryView fitToSize:self.view.bounds.size];
    
	return YES;
}

//overrides the setter to load the rootStack into the galleryView after setting the database.
- (void)setDatabase:(Database *)database {
    _database = database;
    
    //load the rootStack into the galleryView
}

- (void)dealloc {
    [self.galleryView release];
    [super dealloc];
}

@end
