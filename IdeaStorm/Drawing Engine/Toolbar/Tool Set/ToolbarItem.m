//
//  ToolbarItem.m
//  IdeaStorm
//
//  Created by Robert Cole on 10/29/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.

#import "ToolbarItem.h"

@implementation ToolbarItem

@synthesize icon = _icon;
@synthesize title = _title;

- (id)initWithImageName:(NSString *)imageFilename andTitle:(NSString *)title {
    self = [super init];
    
    if (self) {
        self.title = title;
        
        [self setIconWithImageName:imageFilename];
    }
    
    return self;
}

//TODO: Need to finish this stub method
- (bool)setIconWithImageName:(NSString *)imageFilename {
    bool imageLoaded = NO;
    
    
    
    return imageLoaded;
}

- (void)dealloc {
    [self.icon release];
    [self.title release];
    
    [super dealloc];
}

@end
