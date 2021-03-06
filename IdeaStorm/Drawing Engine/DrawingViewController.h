//
//  DrawingViewController.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/22/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingEngine.h"
#import "Toolbar.h"
#import "TutorialOverlay.h"
#import "Database.h"

@interface DrawingViewController : UIViewController

@property (strong, nonatomic) DrawingEngine *drawingEngine;
@property (strong, nonatomic) Toolbar *toolbar;
@property (strong, nonatomic) TutorialOverlay *tutorialOverlay;
@property (retain, nonatomic) Database *database;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDatabase:(Database *)database;

- (void)didRotate:(NSNotification *)notification;

- (void)setupDrawingTools;

- (void)setupBrushes;

- (void)setupDrawingColors;

@end
