//
//  DrawingViewController.m
//  IdeaStorm
//
//  Created by Robert Cole on 9/22/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "DrawingViewController.h"

@implementation DrawingViewController

@synthesize drawingEngine = _drawingEngine;
@synthesize toolbar = _toolbar;

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.drawingEngine = [[DrawingEngine alloc]init];
        
        self.toolbar = [[Toolbar alloc]init];
        
        self.toolbar.drawingEngine = self.drawingEngine;
        
        [self.drawingEngine.renderView addSubview:self.toolbar];
        
        [self.view addSubview:self.drawingEngine.renderView];
        
        Color color1;
        
        color1.r = 1.0;
        color1.g = 0.0;
        color1.b = 0.0;
        color1.a = 1.0;
        
        [self.toolbar addToolbarItem:[[DrawingColor alloc]initWithColor:color1]];
        
        color1.g = 1.0;
        
        [self.toolbar addToolbarItem:[[DrawingColor alloc]initWithColor:color1]];
    }
    return self;
}

#pragma mark - Touch Event Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.drawingEngine drawWithTouch:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.drawingEngine drawWithTouch:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.drawingEngine drawWithTouch:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.drawingEngine drawWithTouch:touches];
}

#pragma mark - View lifecycle

- (void)didRotate:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    UIInterfaceOrientation interfaceOrientation;
    
    bool orientationFound = YES;
    
    if (deviceOrientation == UIDeviceOrientationPortrait) {
        interfaceOrientation = UIInterfaceOrientationPortrait;
    } else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
    } else if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        interfaceOrientation = UIInterfaceOrientationLandscapeRight;
    } else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
    } else {
        orientationFound = NO;
    }
    
    if (orientationFound) {
        [self.toolbar changeToOrientation:interfaceOrientation withDuration:.25];
    }
    
    
    //need to add the change to gestures here
    
    //need to add the change to the tutorial picture here
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // The drawing area will be kept in the potrait orientation so the app user can rotate their iPad to get a better angle for drawing
    
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory Managment

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [self.drawingEngine release];
    [self.toolbar release];
    
    [super dealloc];
}

@end
