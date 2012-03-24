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
@synthesize tutorialOverlay = _tutorialOverlay;

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
        
        activeDrawingTool = -1;
        activeBrush = -1;
        activeDrawingColor = -1;
        
        self.buttons = [[NSMutableDictionary alloc]init];
        
        self.toolbarItems = [[NSMutableDictionary alloc]init];
        
        [self setupDefaultButtons];
    }
    return self;
}

#pragma mark - Modifing Toolbar Items and Buttons

//TODO: Need to set the image for the dimissViewButton.
- (void)setupDefaultButtons {
    //Quick Switch Button
    UIButton *quickSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [quickSwitchButton setImage:[UIImage imageNamed:@"Quick_Switch_Icon.png"] forState:UIControlStateNormal];
    
    quickSwitchButton.frame = CGRectMake(10.0, 10.0, 70.0, 70.0);
    
    quickSwitchButton.backgroundColor = [UIColor blueColor];
    
    [quickSwitchButton addTarget:self action:@selector(quickSwitchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:quickSwitchButton];
    
    //New Drawing Button
    UIButton *newDrawingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [newDrawingButton setImage:[UIImage imageNamed:@"New_Drawing_Icon.png"] forState:UIControlStateNormal];
    
    newDrawingButton.frame = CGRectMake(600.0, 30.0, 50.0, 50.0);
    
    newDrawingButton.backgroundColor = [UIColor grayColor];
    
    [newDrawingButton addTarget:self action:@selector(newDrawingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:newDrawingButton];
    
    //Dimiss View Button
    UIButton *dismissViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //TODO: set image here
    
    dismissViewButton.frame = CGRectMake(668.0, 30.0, 50.0, 50.0);
    
    dismissViewButton.backgroundColor = [UIColor blackColor];
    
    [dismissViewButton addTarget:self action:@selector(dismissViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:dismissViewButton];
    
    //Help Button
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [helpButton setImage:[UIImage imageNamed:@"Help_Icon.png"] forState:UIControlStateNormal];
    
    helpButton.frame = CGRectMake(733.0, 55.0, 25.0, 25.0);
    
    helpButton.backgroundColor = [UIColor purpleColor];
    
    [helpButton addTarget:self action:@selector(helpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:helpButton];
}

- (NSInteger)addToolbarItem:(ToolbarItem *)toolbarItem {
    NSInteger index = nextIndex;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.tag = index;
    
    [self.buttons setObject:button forKey:[NSNumber numberWithInt:index]];
    [self.toolbarItems setObject:toolbarItem forKey:[NSNumber numberWithInt:index]];
    
    button.frame = CGRectMake(kToolbarButtonsStartX + (kToolbarButtonWidth + kToolbarButtonSpacing) * index, kToolbarButtonDownYPosition, kToolbarButtonWidth, kToolbarButtonHieght);
    
    button.backgroundColor = [UIColor blackColor];
    
    if (toolbarItem.icon) {
        [button setImage:toolbarItem.icon forState:UIControlStateNormal];
    }
    
    [button addTarget:self action:@selector(toolbarItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    nextIndex ++;
    
    return index;
}

- (bool)setActiveButtonsWithToolset:(ToolSet *)toolset {
    bool found = NO;
    
    bool foundDrawingTool = NO;
    bool foundBrush = NO;
    bool foundDrawingColor = NO;
    
    ToolbarItem *toolbarItem;
    
    NSArray *allToolBarItems = [self.toolbarItems allValues];
    
    UIButton *oldActiveButton;
    
    UIButton *newActiveButton;
    
    NSInteger index = -1;
    
    [self resetButtonPositions];
    
    for (int i=0; i<[self.toolbarItems count]; i++) {
        toolbarItem = [allToolBarItems objectAtIndex:i];
        
        if ([toolbarItem conformsToProtocol:@protocol(DrawingTool)]) {
            if (toolbarItem.title == toolset.drawingTool.title) {
                oldActiveButton = [self.buttons objectForKey:[NSNumber numberWithInt:activeDrawingTool]];
                NSArray *keys = [self.toolbarItems allKeysForObject:toolbarItem];
                
                index = [[keys objectAtIndex:0] intValue];
                
                activeDrawingTool = index;
                
                foundDrawingTool = YES;
            }
        }
        
        if ([toolbarItem isKindOfClass:[Brush class]]) {
            if (((Brush *)toolbarItem).textureFilename == toolset.brush.textureFilename) {
                oldActiveButton = [self.buttons objectForKey:[NSNumber numberWithInt:activeDrawingTool]];
                NSArray *keys = [self.toolbarItems allKeysForObject:toolbarItem];
                
                index = [[keys objectAtIndex:0] intValue];
                
                activeBrush = index;
                
                foundBrush = YES;
            }
        }
        
        if ([toolbarItem isKindOfClass:[DrawingColor class]]) {
            if (((DrawingColor *)toolbarItem).color.r == toolset.drawingColor.color.r && 
                ((DrawingColor *)toolbarItem).color.g == toolset.drawingColor.color.g && 
                ((DrawingColor *)toolbarItem).color.b == toolset.drawingColor.color.b &&
                ((DrawingColor *)toolbarItem).color.a == toolset.drawingColor.color.a) {
                oldActiveButton = [self.buttons objectForKey:[NSNumber numberWithInt:activeDrawingTool]];
                NSArray *keys = [self.toolbarItems allKeysForObject:toolbarItem];
                
                index = [[keys objectAtIndex:0] intValue];
                
                activeDrawingColor = index;
                
                foundDrawingColor = YES;
            }
        }
        
        if (index != -1) {
            CGRect frame;
            
            newActiveButton = [self.buttons objectForKey:[NSNumber numberWithInt:index]];
            
            if (newActiveButton) {frame = newActiveButton.frame;
                
                frame.origin.y = kToolbarButtonUpYPosition;
                
                newActiveButton.frame = frame;
            }
            
            newActiveButton = NULL;
            oldActiveButton = NULL;
            
            index = -1;
        }
    }
    
    if (foundDrawingTool && foundBrush && foundDrawingColor) {
        found = YES;
    }
    
    return found;
}

- (void)resetButtonPositions {
    NSArray *allButtons = [self.buttons allValues];
    
    UIButton *button;
    
    for (int i=0; i<[allButtons count]; i++) {
        button = [allButtons objectAtIndex:i];
        
        CGRect frame = button.frame;
        
        frame.origin.y = kToolbarButtonDownYPosition;
        
        button.frame = frame;
    }
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
    
    [self setActiveButtonsWithToolset:self.drawingEngine.activeToolSet];
}

//TODO: need to save the drawing here.
- (IBAction)newDrawingButtonAction:(id)sender {
    [self.drawingEngine saveAndAddDrawing];
}

- (IBAction)helpButtonAction:(id)sender {
    if (self.tutorialOverlay) {
        [self.tutorialOverlay displayOverlayWithDuration:.5];
    }
}

- (IBAction)toolbarItemButtonAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    ToolbarItem *toolbarItem = [self.toolbarItems objectForKey:[NSNumber numberWithInt:button.tag]];
    
    
    UIButton *oldActivebutton;
    
    if (button.tag != activeDrawingTool && button.tag != activeBrush && button.tag != activeDrawingColor) {
        
        if ([toolbarItem conformsToProtocol:@protocol(DrawingTool)]) {
            self.drawingEngine.activeToolSet.drawingTool = (ToolbarItem <DrawingTool> *) toolbarItem;
            
            oldActivebutton = [self.buttons objectForKey:[NSNumber numberWithInt:activeDrawingTool]];
            
            activeDrawingTool = button.tag;
        }
        
        if ([toolbarItem isKindOfClass:[Brush class]]) {
            self.drawingEngine.activeToolSet.brush = (Brush *)toolbarItem;
            
            oldActivebutton = [self.buttons objectForKey:[NSNumber numberWithInt:activeBrush]];
            
            activeBrush = button.tag;
        }
        
        if ([toolbarItem isKindOfClass:[DrawingColor class]]) {
            self.drawingEngine.activeToolSet.drawingColor = (DrawingColor *)toolbarItem;
            
            oldActivebutton = [self.buttons objectForKey:[NSNumber numberWithInt:activeDrawingColor]];
            
            activeDrawingColor = button.tag;
        }
        
        if (toolbarItem) {
            CGRect frame;
            
            if (button) {
                frame = button.frame;
                
                frame.origin.y = kToolbarButtonUpYPosition;
                
                button.frame = frame;
            }
            
            if (oldActivebutton) {
                frame = oldActivebutton.frame;
                
                frame.origin.y = kToolbarButtonDownYPosition;
                
                oldActivebutton.frame = frame;
            }
        }
    }
}
//TODO: Need to save the drawing here as well.
- (IBAction)dismissViewButtonAction:(id)sender {
    [self.drawingEngine saveCurrentDrawing];
    
    [self.drawingEngine eraseScreen];
    
    [self.drawingEngine.viewController.presentingViewController viewDidLoad];
    
    [self.drawingEngine.viewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Memory Management

- (void)dealloc {
    [self.buttons release];
    [self.toolbarItems release];
    [super dealloc];
}

@end
