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
@property (nonatomic, readonly) bool autoRotate;

#pragma mark - Modifing Toolbar Items and Buttons

- (NSInteger)addToolbarItem:(ToolbarItem *)toolbarItem;

- (bool)setActiveButtonsWithToolset:(ToolSet *)toolset;

- (void)resetButtonPositions;

#pragma mark - Handle Orientation Change

- (void)changeToOrientation:(UIInterfaceOrientation)orientation withDuration:(float)duration;

#pragma mark - Button Action Handlers

- (IBAction)quickSwitchButtonAction:(id)sender;

- (IBAction)newDrawingButtonAction:(id)sender;

- (IBAction)toolbarItemButtonAction:(id)sender;

@end
