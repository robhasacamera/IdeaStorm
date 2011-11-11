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

@interface Toolbar : UIView {
    int nextIndex;
    
    float portraitAngle;
    float portraitUpsideDownAngle;
    float landscapeLeftAngle;
    float landscapeRightAngle;
}

@property (strong, nonatomic) DrawingEngine *drawingEngine;
@property (strong, nonatomic) NSMutableDictionary *buttons;
@property (strong, nonatomic) NSMutableDictionary *toolbarItems;
@property (nonatomic) CGPoint portraitOrigin;
@property (nonatomic) CGPoint portraitUpsideDownOrigin;
@property (nonatomic) CGPoint landscapeLeftOrigin;
@property (nonatomic) CGPoint landscapeRightOrigin;
@property (nonatomic, readonly) bool autoRotate;

#pragma mark - Modifing Toolbar Items

- (NSInteger *)addToolbarItem:(ToolbarItem *)toolbarItem;

#pragma mark - Handle Orientation Change

- (void)changeToOrientation:(UIInterfaceOrientation)orientation withDuration:(float)duration;

#pragma mark - Button Action Handlers

- (IBAction)quickSwitchButtonAction:(id)sender;

@end
