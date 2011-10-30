//
//  DrawingViewController.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingEngine.h"

@interface DrawingViewController : UIViewController

@property (strong, nonatomic) DrawingEngine *drawingEngine;

@end
