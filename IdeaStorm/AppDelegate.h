//
//  AppDelegate.h
//  IdeaStorm
//
//  Created by Robert Cole on 9/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//set to 1 to run unit test, set to 0 to turn off unit test
#define debug 0

#import <UIKit/UIKit.h>
#import "DrawingViewController.h"

#if debug
#import "DrawingEngineTest.h"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DrawingViewController *viewController;

@end
