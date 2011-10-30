//
//  ToolbarItem.h
//  IdeaStorm
//
//  Created by Robert Cole on 10/29/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolbarItem : NSObject

@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *title;

- (id)initWithImageName:(NSString *)imageFilename andTitle:(NSString *)title;

- (bool)setIconWithImageName:(NSString *)imageFilename;

@end
