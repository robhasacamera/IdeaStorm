//
//  Stack.m
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "Stack.h"
#import "Database.h"

@implementation Stack

@synthesize parent = _parent;
@synthesize children = _children;
@synthesize pathID = _pathID;
@synthesize thumbnailImage = _thumbnailImage;
@synthesize fullImage = _fullImage;

- (id)initWithPathID:(NSString *)pathID {
    self = [super init];
    
    if (self) {
        _pathID = pathID;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *pathID = [aDecoder decodeObjectForKey:kPathIDKey];
    
    self = [self initWithPathID:pathID];
    
    if (self) {
        //initialize with data from coder
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSLog(@"Stack encodeWithCoder:");
    //encode pathID
    [aCoder encodeObject:_pathID forKey:kPathIDKey];
    //call save thumnail and get the path
    //encode thumbnail path
    //encode children's pathID, or maybe their full path, because I might need the extention as well to determine their type
}

- (NSString *)getFullPath {
    NSString *fullPath = [self.pathID stringByAppendingPathExtension:[Stack extention]];
    
    if (self.parent) {
        //build full path from parent's full path
        fullPath = [[self.parent getFullPath] stringByAppendingPathComponent:fullPath]; 
    } else {
        //root case, this is the root object
        fullPath = [[Database libraryPath] stringByAppendingPathComponent:fullPath];
    }
    
    return fullPath;
}

- (bool)addChild:(NSObject <GalleryItem> *)galleryItem {
    
    return nil;
}

- (bool)deleteChild:(NSObject <GalleryItem> *)galleryItem {
    
    return nil;
}

- (NSString *)saveThumbnailImage {
    
    return nil;
}

- (NSString *)saveFullImage {
    
    return nil;
}

- (bool)exportToCameraRoll {
    
    return nil;
}

- (UIImage *)thumbnailImage {
    
    return nil;
}

- (UIImage *)fullImage {
    
    return nil;
}

+ (NSString *)extention {
    return @"stack";
}

@end
