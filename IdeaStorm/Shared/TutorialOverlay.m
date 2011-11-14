//
//  TutorialOverlay.m
//  IdeaStorm
//
//  Created by Robert Cole on 11/14/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "TutorialOverlay.h"

@implementation TutorialOverlay

@synthesize overlay = _overlay;
@synthesize portraitImage = _portraitImage;
@synthesize portraitUpsideDownImage = _portraitUpsideDownImage;
@synthesize landscapeLeftImage = _landspaceLeftImage;
@synthesize landscapeRightImage = _landscapeRightImage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect overlayFrame = frame;
        
        overlayFrame.origin.x = 0.0;
        overlayFrame.origin.y = 0.0;
        
        self.overlay = [[UIImageView alloc]initWithFrame:overlayFrame];
        
        [self addSubview:self.overlay];
    }
    return self;
}

- (void)changeToOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        self.overlay.image = self.portraitImage;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.overlay.image = self.portraitUpsideDownImage;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        self.overlay.image = self.landscapeLeftImage;
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        self.overlay.image = self.landscapeRightImage;
    }
}

//FIXME: get the timer to work on this properly, may need to use a timer instead of an anomation block.
- (void)displayOverlayWithDuration:(float)duration {
    if (self.hidden) {
        self.hidden = NO;
        
        [UIView animateWithDuration:duration animations:^{
            self.alpha = 1.0;
        }];
    }
}

- (void)hideOverlayWithDuration:(float)duration {
    NSLog(@"hello");
    if (!self.hidden) {
        NSLog(@"!self.hidden");
        [UIView animateWithDuration:duration animations:^{
            self.alpha = 0.0;
        }];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(toggleHidden:) userInfo:nil repeats:NO];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)toggleHidden:(NSTimer *)timer {
    if (self.hidden) {
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
    
    [timer invalidate];
}

- (void)dealloc {
    [self.overlay release];
    
    [super dealloc];
}

@end
