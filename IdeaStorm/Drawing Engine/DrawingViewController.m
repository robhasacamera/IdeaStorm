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
@synthesize tutorialOverlay = _tutorialOverlay;
@synthesize database = _database;

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.database = [[Database alloc]init];
        
        self.drawingEngine = [[DrawingEngine alloc]init];
        
        self.toolbar = [[Toolbar alloc]init];
        
        self.tutorialOverlay = [[TutorialOverlay alloc]initWithFrame:self.drawingEngine.renderView.frame];
        
        if (!self.database.drawingEngineFirstRun) {
            self.tutorialOverlay.hidden = YES;
            self.tutorialOverlay.alpha = 0.0;
        }
        
        [self.database setDrawingEngineFirstRun:NO];
        
        self.tutorialOverlay.portraitImage = [UIImage imageNamed:@"Tutorial_Portrait.png"];
        
        self.tutorialOverlay.portraitUpsideDownImage = [UIImage imageNamed:@"Tutorial_PortraitUpsideDown.png"];
        
        self.tutorialOverlay.landscapeLeftImage = [UIImage imageNamed:@"Tutorial_LandscapeLeft.png"];
        
        self.tutorialOverlay.landscapeRightImage = [UIImage imageNamed:@"Tutorial_LandscapeRight.png"];
        
        self.toolbar.drawingEngine = self.drawingEngine;
        self.toolbar.tutorialOverlay = self.tutorialOverlay;
        
        [self.drawingEngine.renderView addSubview:self.toolbar];
        [self.drawingEngine.renderView addSubview:self.tutorialOverlay];
        
        [self.view addSubview:self.drawingEngine.renderView];
        
        [self setupDrawingTools];
        
        [self setupBrushes];
        
        [self setupDrawingColors];
                
        [self.toolbar setActiveButtonsWithToolset:self.drawingEngine.activeToolSet];
    }
    return self;
}

- (void)setupDrawingTools {
    PenDrawingTool *pen = [[PenDrawingTool alloc]init];
    
    [pen setIconWithImageName:@"Pen_Icon.png"];
    
    [self.toolbar addToolbarItem:pen];
    
    [pen release];
    
    PencilDrawingTool *pencil = [[PencilDrawingTool alloc]init];
    
    [pencil setIconWithImageName:@"Pencil_Icon.png"];
    
    [self.toolbar addToolbarItem:pencil];
    
    [pencil release];
    
    EraserDrawingTool *eraser = [[EraserDrawingTool alloc]init];
    
    [eraser setIconWithImageName:@"Eraser_Icon.png"];
    
    [self.toolbar addToolbarItem:eraser];
    
    [eraser release];

}

- (void)setupBrushes {
    Brush *smallParticle = [[Brush alloc]initWithTexture:@"Small_Particle.png"];
    
    [smallParticle setIconWithImageName:@"Small_Particle_Icon.png"];
    
    [self.toolbar addToolbarItem:smallParticle];
    
    [smallParticle release];
    
    Brush *circle = [[Brush alloc]initWithTexture:@"Circle.png"];
    
    [circle setIconWithImageName:@"Circle_Icon.png"];
    
    [self.toolbar addToolbarItem:circle];
    
    [circle release];
    
    Brush *calligraphy = [[Brush alloc]initWithTexture:@"Calligraphy.png"];
    
    [calligraphy setIconWithImageName:@"Calligraphy_Icon.png"];
    
    [self.toolbar addToolbarItem:calligraphy];
    
    [calligraphy release];
}

- (void)setupDrawingColors {
    Color color;
    
    //black setup
    color.r = 0.0;
    color.g = 0.0;
    color.b = 0.0;
    color.a = 1.0;
    
    DrawingColor *black = [[DrawingColor alloc]initWithColor:color];
    
    [black setIconWithImageName:@"Color_Black_Icon.png"];
    
    [self.toolbar addToolbarItem:black];
    
    [black release]; 
    
    //red setup
    color.r = 1.0;
    color.g = 0.0;
    color.b = 0.0;
    color.a = 1.0;
    
    DrawingColor *red = [[DrawingColor alloc]initWithColor:color];
    
    [red setIconWithImageName:@"Color_Red_Icon.png"];
    
    [self.toolbar addToolbarItem:red];
    
    [red release]; 
    
    //green setup
    color.r = 0.0;
    color.g = 1.0;
    color.b = 0.0;
    color.a = 1.0;
    
    DrawingColor *green = [[DrawingColor alloc]initWithColor:color];
    
    [green setIconWithImageName:@"Color_Green_Icon.png"];
    
    [self.toolbar addToolbarItem:green];
    
    [green release]; 
    
    //blue setup
    color.r = 0.0;
    color.g = 0.0;
    color.b = 1.0;
    color.a = 1.0;
    
    DrawingColor *blue = [[DrawingColor alloc]initWithColor:color];
    
    [blue setIconWithImageName:@"Color_Blue_Icon.png"];
    
    [self.toolbar addToolbarItem:blue];
    
    [blue release]; 
    
    //yellow setup
    color.r = 1.0;
    color.g = 1.0;
    color.b = 0.0;
    color.a = 1.0;
    
    DrawingColor *yellow = [[DrawingColor alloc]initWithColor:color];
    
    [yellow setIconWithImageName:@"Color_Yellow_Icon.png"];
    
    [self.toolbar addToolbarItem:yellow];
    
    [yellow release]; 

}

#pragma mark - Touch Event Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.tutorialOverlay.hidden) {
        [self.tutorialOverlay hideOverlayWithDuration:0.25];
    } else {
        [self.drawingEngine drawWithTouch:touches];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.tutorialOverlay.hidden) {
        [self.drawingEngine drawWithTouch:touches];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.tutorialOverlay.hidden) {
        [self.drawingEngine drawWithTouch:touches];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.tutorialOverlay.hidden) {
        [self.drawingEngine drawWithTouch:touches];
    }
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
        
        [self.tutorialOverlay changeToOrientation:interfaceOrientation];
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
    [self.tutorialOverlay release];
    
    [super dealloc];
}

@end
