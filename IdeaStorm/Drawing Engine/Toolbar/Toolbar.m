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
        
        self.buttons = [[NSMutableDictionary alloc]init];
        
         self.toolbarItems = [[NSMutableDictionary alloc]init];
        
        //adding buttons (can more this to a different function)
        
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

#pragma mark - Modifing Toolbar Items and Buttons

//FIXME: This is causing the image to be shrinked some to fit the button area
- (NSInteger)addToolbarItem:(ToolbarItem *)toolbarItem {
    NSInteger index = nextIndex;
    
    //detect the button type and add the appropiate action
    
    //create button for item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //set button's id to index
    button.tag = index;
    
    //add button and item to respective arrays with index as the key
    [self.buttons setObject:button forKey:[NSNumber numberWithInt:index]];
    [self.toolbarItems setObject:toolbarItem forKey:[NSNumber numberWithInt:index]];
    
    button.frame = CGRectMake(100 + 50 * index, 40, 40, 60);
    
    button.backgroundColor = [UIColor blackColor];
    
    if (toolbarItem.icon) {
        [button setImage:toolbarItem.icon forState:UIControlStateNormal];
    }
    
    [button addTarget:self action:@selector(toolbarItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    //increment only if a button was added
    nextIndex ++;
    
    return index;
}

//FIXME: The DrawingTool check does not work.
- (bool)setActiveButtonsWithToolset:(ToolSet *)toolset {
    NSLog(@"------------");
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
    
    //This only works for the eraser tool???
    for (int i=0; i<[self.toolbarItems count]; i++) {
        toolbarItem = [allToolBarItems objectAtIndex:i];
        
        if ([toolbarItem conformsToProtocol:@protocol(DrawingTool)]) {
            if (toolbarItem.title == toolset.drawingTool.title) {
                oldActiveButton = [self.buttons objectForKey:[NSNumber numberWithInt:activeDrawingTool]];
                NSArray *keys = [self.toolbarItems allKeysForObject:toolbarItem];
                
                index = [[keys objectAtIndex:0] intValue];
                
                activeDrawingTool = index;
                
                foundDrawingTool = YES;
                
                NSLog(@"DrawingTool Match, index=%i", index);
            }
            
        }
        
        if ([toolbarItem isKindOfClass:[Brush class]]) {
            if (((Brush *)toolbarItem).textureFilename == toolset.brush.textureFilename) {
                oldActiveButton = [self.buttons objectForKey:[NSNumber numberWithInt:activeDrawingTool]];
                NSArray *keys = [self.toolbarItems allKeysForObject:toolbarItem];
                
                index = [[keys objectAtIndex:0] intValue];
                
                activeBrush = index;
                
                foundBrush = YES;
                
                NSLog(@"Brush Match, index=%i", index);
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
                
                NSLog(@"DrawingColor Match, index=%i", index);
            }
        }
        
        if (index != -1) {
            CGRect frame;
            
            newActiveButton = [self.buttons objectForKey:[NSNumber numberWithInt:index]];
            
            if (newActiveButton) {
                NSLog(@"button found, tag = %i", newActiveButton.tag);
                
                frame = newActiveButton.frame;
                
                NSLog(@"old frame h=%f, y=%f", newActiveButton.frame.size.height, newActiveButton.frame.origin.y);
                
                //frame.size.height = 60;
                frame.origin.y = 20;
                
                newActiveButton.frame = frame;
                
                NSLog(@"new frame h=%f, y=%f", newActiveButton.frame.size.height, newActiveButton.frame.origin.y);
            }
            
            if (oldActiveButton) {
                frame = oldActiveButton.frame;
                
                //frame.size.height = 40;
                frame.origin.y = 40;
                
                oldActiveButton.frame = frame;
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
        
        //frame.size.height = 40;
        frame.origin.y = 40;
        
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

//TODO: Set active icons during after switch
- (IBAction)quickSwitchButtonAction:(id)sender {
    [self.drawingEngine switchActiveAndReserveToolSets];
    
    //need to set the active displayed icons
    [self setActiveButtonsWithToolset:self.drawingEngine.activeToolSet];
    
}

- (IBAction)newDrawingButtonAction:(id)sender {
    [self.drawingEngine eraseScreen];
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
        
        //this check is not working
        if ([toolbarItem isKindOfClass:[DrawingColor class]]) {
            self.drawingEngine.activeToolSet.drawingColor = (DrawingColor *)toolbarItem;
            
            oldActivebutton = [self.buttons objectForKey:[NSNumber numberWithInt:activeDrawingColor]];
            
            activeDrawingColor = button.tag;
        }
        
        if (toolbarItem) {
            CGRect frame;
            
            if (button) {
                frame = button.frame;
                
                //frame.size.height = 60;
                frame.origin.y = 20;
                
                button.frame = frame;
            }
            
            if (oldActivebutton) {
                frame = oldActivebutton.frame;
                
                //frame.size.height = 40;
                frame.origin.y = 40;
                
                oldActivebutton.frame = frame;
            }
        }
    }
}

#pragma mark - Memory Management

- (void)dealloc {
    [self.buttons release];
    [self.toolbarItems release];
}

@end
