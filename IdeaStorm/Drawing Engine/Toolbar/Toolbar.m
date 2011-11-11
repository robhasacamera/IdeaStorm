//
//  Toolbar.m
//  IdeaStorm
//
//  Created by Robert Cole on 11/7/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "Toolbar.h"

@implementation Toolbar

@synthesize drawingEngine = _drawingEngine;
@synthesize buttons = _buttons;
@synthesize toolbarItems = _toolbarItems;
@synthesize portraitOrigin = _portraitRect;
@synthesize portraitUpsideDownOrigin = _portraitUpsideDownRect;
@synthesize landscapeLeftOrigin = _landscapeLeftRect;
@synthesize landscapeRightOrigin = _landscapeRightRect;
@synthesize autoRotate = _autoRotate;

#pragma mark - Intialization

- (id)init {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    float toolbarWidth = screenWidth;
    float toolbarHeight = 80;
    
    CGPoint aPortraitOrigin = CGPointMake(0.0, screenHeight - toolbarHeight);
    CGPoint aPortraitUpsideDownOrigin = CGPointMake(0.0, 0.0);
    CGPoint aLandscapeLeftOrigin = CGPointMake(screenWidth - toolbarHeight, ((screenHeight - toolbarWidth) / 2));
    CGPoint aLandscapeRightOrigin = CGPointMake(0.0, ((screenHeight - toolbarWidth) / 2));
    
    self = [self initWithFrame:CGRectMake(aPortraitOrigin.x, aPortraitOrigin.y, toolbarWidth, toolbarHeight)];
            
    if (self) {
        self.portraitOrigin = aPortraitOrigin;
        self.portraitUpsideDownOrigin = aPortraitUpsideDownOrigin;
        self.landscapeLeftOrigin = aLandscapeLeftOrigin;
        self.landscapeRightOrigin = aLandscapeRightOrigin;
        
        self.backgroundColor = [UIColor grayColor];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.portraitOrigin = frame.origin;
        self.portraitUpsideDownOrigin = frame.origin;
        self.landscapeLeftOrigin = frame.origin;
        self.landscapeRightOrigin = frame.origin;
        
        portraitAngle = 0;
        portraitUpsideDownAngle = 180 * M_PI / 180;
        landscapeLeftAngle = 270 * M_PI / 180;
        landscapeRightAngle = 90 * M_PI / 180;
        
        nextIndex = 0;
        
        _autoRotate = NO;
        
        UIButton *quickSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        quickSwitchButton.frame = CGRectMake(10.0, 10.0, 70.0, 70.0);
        
        quickSwitchButton.backgroundColor = [UIColor blueColor];
        
        [quickSwitchButton addTarget:self action:@selector(quickSwitchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:quickSwitchButton];
    }
    return self;
}

#pragma mark - Modifing Toolbar Items

- (NSInteger *)addToolbarItem:(ToolbarItem *)toolbarItem {
    NSInteger *index = (NSInteger *)[NSNumber numberWithInt:nextIndex];
    
    //detect the button type and add the appropiate action
    
    //create button for item
    
    //set button's id to index
    
    //add button and item to respective arrays with index as the key
    
    //increment only if a button was added
    nextIndex ++;
    
    return index;
}

#pragma mark - Handle Orientation Change

- (void)changeToOrientation:(UIInterfaceOrientation)orientation withDuration:(float)duration {
    float angle;
    CGPoint origin;
    
    if (orientation == UIInterfaceOrientationPortrait) {
        angle = portraitAngle;
        origin = self.portraitOrigin;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        angle = portraitUpsideDownAngle;
        origin = self.portraitUpsideDownOrigin;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        angle = landscapeLeftAngle;
        origin = self.landscapeLeftOrigin;
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        angle = landscapeRightAngle;
        origin = self.landscapeRightOrigin;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeRotation(angle);
        
        CGRect rect = self.frame;
    
        rect.origin = origin;
    
        self.frame = rect;
    }];
}

#pragma mark - Button Action Handlers

- (IBAction)quickSwitchButtonAction:(id)sender {
    [self.drawingEngine switchActiveAndReserveToolSets];
}

@end
