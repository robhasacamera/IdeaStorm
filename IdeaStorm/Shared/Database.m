//
//  Database.m
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "Database.h"

@implementation Database

+ (UIImage *)getImageForFilename:(NSString *)filename {
    UIImage *image = nil;
    
    NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:filename];
    
    image = [[[UIImage alloc]initWithContentsOfFile:filePath] autorelease];
    
    return image;
}

+ (NSString *)documentsPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	return documentsDirectory;
}

@end
