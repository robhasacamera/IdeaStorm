//
//  DrawingColor.m
//  IdeaStorm
//
//  Created by Robert Cole on 10/29/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "DrawingColor.h"

@implementation DrawingColor

@synthesize color = _color;

- (id)initWithColor:(Color)color {
    self = [super init];
    
    if (self) {
        self.color = color;
    }
    
    return self;
}

@end
