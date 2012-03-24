//
//  PositioningHelper.m
//  IdeaStorm
//
//  Created by Robert Cole on 3/24/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "PositioningHelper.h"

@implementation PositioningHelper

@synthesize viewSpace = _viewSpace;

- (id)init {
    self = [super init];
    
    if (self) {
        self.viewSpace = CGSizeMake(kDefaultViewSpace, kDefaultViewSpace);
    }
    
    return self;
}

- (bool)gridPositionViews:(NSArray *)arrayOfViews usingWidth:(float)width {
    bool success = YES;
    
    for (int i=0; i<[arrayOfViews count]; i++) {
        if (![[arrayOfViews objectAtIndex:i] isKindOfClass:[UIView class]]) {
            success = NO;
        }
    }
    
    if (success) {
        //calculate the number of items for the width
        int viewsPerRow = (int)floorf(width / kDefaultViewSpace);
        
        float remainder = width - (viewsPerRow * self.viewSpace.width);
        
        CGPoint startPoint = CGPointMake(((self.viewSpace.width / 2) + (remainder / 2)), (self.viewSpace.height / 2));
        
        CGPoint point = startPoint;
        
        UIView *view;
        
        int viewCount = 0;
        
        for (int i=0; i<[arrayOfViews count]; i++) {
            viewCount++;
            
            //get view
            view = (UIView *)[arrayOfViews objectAtIndex:i];
            
            //get rect
            view.center = point;
            
            //if not last item in the row, shift over some, otherwise shift down
            if (viewCount < viewsPerRow) {
                point.x += self.viewSpace.width;
            } else {
                point.x = startPoint.x;
                point.y += self.viewSpace.height;
                
                viewCount = 0;
            }
        }
    }
    
    return success;
}

@end
