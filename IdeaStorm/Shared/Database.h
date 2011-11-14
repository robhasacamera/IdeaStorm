//
//  Database.h
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//
//TODO: Need to add the rest of the needed methods, pragma marks and comments

#define FIRST_RUN_KEY_VALUE 0
#define DRAWING_ENGINE_KEY_VALUE 1

#import <Foundation/Foundation.h>

@interface Database : NSObject

@property (strong, nonatomic) NSUserDefaults *defaults;

+ (UIImage *)getImageForFilename:(NSString *)filename;

+ (NSString *)documentsPath;

@end
