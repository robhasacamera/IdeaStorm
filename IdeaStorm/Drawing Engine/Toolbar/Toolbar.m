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

- (id)init {
    self = [self initWithFrame:CGRectMake(0.0, 0.0, 768.0, 80.0)];
            
    if (self) {
        //do nothing
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        nextIndex = 0;
        
        UIButton *quickSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        quickSwitchButton.frame = CGRectMake(10.0, 10.0, 70.0, 70.0);
        
        quickSwitchButton.backgroundColor = [UIColor blueColor];
        
        [quickSwitchButton addTarget:self action:@selector(quickSwitchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:quickSwitchButton];
    }
    return self;
}

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

- (IBAction)quickSwitchButtonAction:(id)sender {
    [self.drawingEngine switchActiveAndReserveToolSets];
}

@end
