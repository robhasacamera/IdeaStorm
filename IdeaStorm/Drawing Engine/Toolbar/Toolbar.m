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
        
        activeDrawingTool = -1;
        activeBrush = -1;
        activeDrawingColor = -1;
        
        UIButton *quickSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        quickSwitchButton.frame = CGRectMake(10.0, 10.0, 70.0, 70.0);
        
        quickSwitchButton.backgroundColor = [UIColor blueColor];
        
        [quickSwitchButton addTarget:self action:@selector(quickSwitchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:quickSwitchButton];
        
        UIButton *newDrawingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        newDrawingButton.frame = CGRectMake(668.0, 30.0, 50.0, 50.0);
        
        newDrawingButton.backgroundColor = [UIColor redColor];
        
        [newDrawingButton addTarget:self action:@selector(newDrawingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:newDrawingButton];
    }
    return self;
}

#pragma mark - Modifing Toolbar Items

- (NSInteger)addToolbarItem:(ToolbarItem *)toolbarItem {
    NSInteger index = nextIndex;
    
    //detect the button type and add the appropiate action
    
    //create button for item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //set button's id to index
    button.tag = index;
    
    //add button and item to respective arrays with index as the key
    [self.buttons setObject:button forKey:[NSNumber numberWithInt:index]];
    
    button.frame = CGRectMake(100 + 50 * index, 40, 40, 40);
    
    button.backgroundColor = [UIColor blackColor];
    
    [button addTarget:self action:@selector(toolbarItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
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
    
    //need to set the active displayed icons
}

- (IBAction)newDrawingButtonAction:(id)sender {
    [self.drawingEngine eraseScreen];
}

//TODO: the isKindOf: method is not working
- (IBAction)toolbarItemButtonAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    ToolbarItem *toolbarItem = [self.toolbarItems objectForKey:[NSNumber numberWithInt:button.tag]];
    
    UIButton *oldActivebutton;
    
    NSLog(@"toolbarItemButtonAction tag = %i", button.tag);
    
    if (button.tag != activeDrawingTool && button.tag != activeBrush && button.tag != activeDrawingColor) {
        NSLog(@"processing");
        
        if ([sender conformsToProtocol:@protocol(DrawingTool)]) {
            self.drawingEngine.activeToolSet.drawingTool = (ToolbarItem <DrawingTool> *) toolbarItem;
            
            oldActivebutton = [self.buttons objectForKey:[NSNumber numberWithInt:activeDrawingTool]];
            
            activeDrawingTool = button.tag;
        }
        
        if ([toolbarItem isKindOfClass:[Brush class]]) {
            //<#statements#>
            
            oldActivebutton = [self.buttons objectForKey:[NSNumber numberWithInt:activeBrush]];
            
            activeBrush = button.tag;
        }
        
        //this check is not working
        if ([toolbarItem isKindOfClass:[DrawingColor class]]) {
            NSLog(@"DrawingColor");
            self.drawingEngine.activeToolSet.drawingColor = (DrawingColor *)toolbarItem;
            
            oldActivebutton = [self.buttons objectForKey:[NSNumber numberWithInt:activeDrawingColor]];
            
            activeDrawingColor = button.tag;
        }
        
        if (toolbarItem) {
            CGRect frame = button.frame;
            
            frame.size.height = 60;
            frame.origin.y += 20;
            
            button.frame = frame;
            
            if (oldActivebutton) {
                frame = oldActivebutton.frame;
                
                frame.size.height = 40;
                frame.origin.y -= 20;
                
                oldActivebutton.frame = frame;
            }
        }
    }
}

@end
