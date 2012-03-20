//
//  GalleryViewController.m
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "GalleryViewController.h"

@implementation GalleryViewController

@synthesize drawingViewController = _drawingViewController;
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
        self.galleryView = [[GalleryView alloc]initWithFrame:self.view.frame];
        self.galleryView.delegate = self;
        
        if (database) {
            self.database = database;
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
    Stack *rootStack = (Stack *)[self.database getRootGalleryItem];
    
    self.galleryView.rootStack = rootStack;
}

#pragma mark - GalleryViewDelegate Methods

- (void)openDrawing:(Drawing *)drawing {
    
}

- (bool)exportGalleryItem:(NSObject <GalleryItem> *)galleryItem {
    return nil;
}

- (bool)deleteGalleryItem:(NSObject <GalleryItem> *)galleryIten {
    return nil;
}

- (void)newDrawingForStack:(Stack *)stack {
    
}

- (Stack *)createStackFromDrawing:(Drawing *)drawing {
    return nil;
}

- (void)dealloc {
    [self.galleryView release];
    if (self.database) {
        [self.database release];
    }
    if (self.drawingViewController) {
        [self.drawingViewController release];
    }

    [super dealloc];
}

@end
