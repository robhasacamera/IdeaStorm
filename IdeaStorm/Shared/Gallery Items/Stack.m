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

- (id)init {
    self = [self initWithPathID:[Database generateUniqueID]];
    
    if (self) {
        
    }
    
    return self;
}

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
        NSMutableArray *childrenDataFilePaths = [[aDecoder decodeObjectForKey:kChildrenKey] retain];
        
        for (int i=0; i < [childrenDataFilePaths count]; i++) {
            [self addChild:[Database getGalleryItemForPath:(NSString *)[childrenDataFilePaths objectAtIndex:i]]];
        }
        
        [childrenDataFilePaths release];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    //encode pathID
    [aCoder encodeObject:_pathID forKey:kPathIDKey];
    //call save thumnail and get the path
    //encode thumbnail path
    //encode children's pathID, or maybe their full path, because I might need the extention as well to determine their type
    
    //instead of saving the array of children, saving an array of their paths, this way only the path is save each time the stack is saved instead of the whole child
    
    NSMutableArray *childrenDataFilePaths = [[NSMutableArray alloc]initWithCapacity:[self.children count]];
    
    for (int i=0; i<[self.children count]; i++) {
        [childrenDataFilePaths addObject:[((NSObject <GalleryItem> *)[self.children objectAtIndex:i]) getFullPathWithDataFilename:YES]];
    }
    
    [aCoder encodeObject:childrenDataFilePaths forKey:kChildrenKey];
    
    [childrenDataFilePaths release];
}

- (NSString *)getFullPathWithDataFilename:(bool)yesOrNo {
    NSString *fullPath = [self.pathID stringByAppendingPathExtension:[Stack extention]];
    
    if (self.parent) {
        //build full path from parent's full path
        fullPath = [[self.parent getFullPathWithDataFilename:NO] stringByAppendingPathComponent:fullPath]; 
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
    
    NSLog(@"getFullP ath Error: %@", error);
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
    
    int index = [_children indexOfObject:galleryItem];
    
    bool success = NO;
    
    if (index >= 0) {
        success = YES;
        
        [_children removeObjectAtIndex:index];
    }
    
    return success;
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
    
    if ([_children count] > 0) {
        return ((NSObject <GalleryItem> *)[_children objectAtIndex:0]).thumbnailImage;
    }
    
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
