//
//  Database.h
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//
//TODO: Need to add the rest of the needed methods, pragma marks and comments

#import <Foundation/Foundation.h>

@interface Database : NSObject

+ (UIImage *)getImageForFilename:(NSString *)filename;

+ (NSString *)documentsPath;

@end
