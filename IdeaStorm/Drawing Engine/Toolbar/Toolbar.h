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
}

@property (strong, nonatomic) DrawingEngine *drawingEngine;
@property (strong, nonatomic) NSMutableDictionary *buttons;
@property (strong, nonatomic) NSMutableDictionary *toolbarItems;

- (NSInteger *)addToolbarItem:(ToolbarItem *)toolbarItem;

@end
