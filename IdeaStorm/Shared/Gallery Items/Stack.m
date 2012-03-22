//
//  Stack.m
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "Stack.h"

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
    NSString *pathID = [[aDecoder decodeObjectForKey:kPathIDKey] retain];
    
    self = [self initWithPathID:pathID];
    
    if (self) {
        //initialize with data from coder
        
        //get paths to all children from aDecoder
        
        //init children and add them as a child
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    //encode pathID
    [aCoder encodeObject:_pathID forKey:kPathIDKey];
    //call save thumnail and get the path
    //encode thumbnail path
    //encode children's pathID, or maybe their full path, because I might need the extention as well to determine their type
}

- (NSString *)getFullPathWithExtention:(bool)yesOrNo {
    NSString *fullPath = [self.pathID stringByAppendingPathExtension:[Stack extention]];
    
    if (self.parent) {
        //build full path from parent's full path
        fullPath = [[self.parent getFullPathWithExtention:NO] stringByAppendingPathComponent:fullPath]; 
    } else {
        //root case, this is the root object
        fullPath = [[Database libraryPath] stringByAppendingPathComponent:fullPath];
    }
    
    NSError *error;
    
    bool success = [[NSFileManager defaultManager] createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (success) {
        if (yesOrNo) {
            return [fullPath stringByAppendingPathComponent:kGalleryItemDataFileName];
        } else {
            return fullPath;
        }
    }
    
    NSLog(@"getFullPath Error: %@", error);
    NSLog(@"getFullPath Error userInfo: %@", [error userInfo]);
    
    return nil;
}

- (bool)addChild:(NSObject <GalleryItem> *)galleryItem {
    
    if (!self.children) {
        _children = [[NSMutableArray alloc]initWithCapacity:1];
    }
    
    [_children addObject:galleryItem];
    
    galleryItem.parent = self;
    
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

//TODO: Make sure to set release statements here for all objects
- (void)dealloc {
    [_pathID release];
    
    if (self.children) {
        [_children release];
    }
    
    [super dealloc];
}

@end
