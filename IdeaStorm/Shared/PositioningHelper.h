//
//  PositioningHelper.h
//  IdeaStorm
//
//  Created by Robert Cole on 3/24/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultViewSpace 200.0

@interface PositioningHelper : NSObject
@property (nonatomic) CGSize viewSpace;

- (bool)gridPositionViews:(NSArray *)arrayOfViews usingWidth:(float)width;

@end
