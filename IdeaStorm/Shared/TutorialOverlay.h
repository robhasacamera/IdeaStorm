//
//  TutorialOverlay.h
//  IdeaStorm
//
//  Created by Robert Cole on 11/14/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialOverlay : UIView

@property (strong, nonatomic) UIImageView *overlay;
@property (strong, nonatomic) UIImage *portraitImage;
@property (strong, nonatomic) UIImage *portraitUpsideDownImage;
@property (strong, nonatomic) UIImage *landscapeLeftImage;
@property (strong, nonatomic) UIImage *landscapeRightImage;

- (void)changeToOrientation:(UIInterfaceOrientation)orientation;

- (void)displayOverlayWithDuration:(float)duration;

- (void)hideOverlayWithDuration:(float)duration;

- (void)toggleHidden:(NSTimer *)timer;

@end
