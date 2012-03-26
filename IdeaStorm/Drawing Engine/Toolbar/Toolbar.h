//
//  Toolbar.h
//  IdeaStorm
//
//  Created by Robert Cole on 11/7/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolbarItem.h"
#import "DrawingEngine.h"
#import "DrawingTool.h"
#import "Brush.h"
#import "DrawingColor.h"
#import "TutorialOverlay.h"

#define kToolbarButtonUpYPosition 10.0
#define kToolbarButtonDownYPosition 30.0
#define kToolbarButtonWidth 50.0
#define kToolbarButtonHieght 75.0
#define kToolbarButtonSpacing 0.0
#define kToolbarButtonsStartX 75.0

@interface Toolbar : UIView {
    NSInteger nextIndex;
    
    float portraitAngle;
    float portraitUpsideDownAngle;
    float landscapeLeftAngle;
    float landscapeRightAngle;
    
    NSInteger activeDrawingTool;
    NSInteger activeBrush;
    NSInteger activeDrawingColor;
}

@property (strong, nonatomic) DrawingEngine *drawingEngine;
@property (strong, nonatomic) NSMutableDictionary *buttons;
@property (strong, nonatomic) NSMutableDictionary *toolbarItems;
@property (nonatomic) CGPoint portraitOrigin;
@property (nonatomic) CGPoint portraitUpsideDownOrigin;
@property (nonatomic) CGPoint landscapeLeftOrigin;
@property (nonatomic) CGPoint landscapeRightOrigin;
@property (strong, nonatomic) TutorialOverlay *tutorialOverlay;

#pragma mark - Modifing Toolbar Items and Buttons

- (void)setupDefaultButtons;

- (NSInteger)addToolbarItem:(ToolbarItem *)toolbarItem;

- (bool)setActiveButtonsWithToolset:(ToolSet *)toolset;

- (void)resetButtonPositions;

#pragma mark - Handle Orientation Change

- (void)changeToOrientation:(UIInterfaceOrientation)orientation withDuration:(float)duration;

#pragma mark - Button Action Handlers

- (IBAction)quickSwitchButtonAction:(id)sender;

- (IBAction)newDrawingButtonAction:(id)sender;

- (IBAction)helpButtonAction:(id)sender;

- (IBAction)toolbarItemButtonAction:(id)sender;

- (IBAction)dismissViewButtonAction:(id)sender;

@end
