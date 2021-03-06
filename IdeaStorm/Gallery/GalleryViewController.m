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
        
        self.view.backgroundColor = [UIColor blackColor];
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
    
    [self.galleryView fitToSize:self.view.bounds.size];
    
    if (self.galleryView.displayedStack) {
        self.galleryView.displayedStack = self.galleryView.displayedStack;
    }
    
    //if ((self.galleryView.frame.size.width != self.view.bounds.size.width) || (self.galleryView.frame.size.height != self.view.bounds.size.height)) {
        
    //}
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
    [self.galleryView fitToSize:self.view.bounds.size];
    
    [self.galleryView.normalTutorial changeToOrientation:interfaceOrientation];
    
    [self.galleryView.editTutorial changeToOrientation:interfaceOrientation];
    
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

- (bool)deleteGalleryItem:(NSObject <GalleryItem> *)galleryItem {
    NSObject <GalleryItem> * parent = galleryItem.parent;
    
    bool success = [parent deleteChild:galleryItem];
    
    if (success) {
        //save gallery item
        [self.database saveGalleryItem:parent];
        
        //need to have a method in the databse to delete a gallery item, so the child that was removed can have its resources deleted in the file system.
        [self.database deleteGalleryItem:galleryItem];
        
        //release selectedGalleryItem and set it to nil
        
        
    }
    
    
    return success;
}

- (void)newDrawingForStack:(Stack *)stack {
    [self.drawingViewController.drawingEngine newDrawingForStack:stack];
    
    [self presentModalViewController:self.drawingViewController animated:YES];
}

- (Stack *)createStackFromDrawing:(Drawing *)drawing {
    return nil;
}

- (bool)saveGalleryItem:(NSObject <GalleryItem> *)galleryItem {
    return [self.database saveGalleryItem:galleryItem];
}

- (bool)makeStackFromDrawing:(Drawing *)drawing {
    bool success = false;
    
    NSObject <GalleryItem> *oldParent = drawing.parent;
    
    Stack *newStack = [[Stack alloc]init];
    
    [oldParent addChild:newStack];
    
    success = [self.database saveGalleryItem:newStack];
    
    if (success) {
        success = [self.database moveGalleryItem:drawing intoGalleryItem:newStack];
    }
    
    return success;
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
