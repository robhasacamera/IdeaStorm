//
//  Drawing.m
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "Drawing.h"

@implementation Drawing

@synthesize parent = _parent;
@synthesize children = _children;
@synthesize pathID = _pathID;
@synthesize thumbnailImage = _thumbnailImage;
@synthesize fullImage = _fullImage;
@synthesize stroke = _stroke;

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
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_pathID forKey:kPathIDKey];
}

- (NSString *)getFullPathWithExtension:(bool)yesOrNo {
    NSString *fullPath = [self.pathID stringByAppendingPathExtension:[Drawing extention]];
    
    if (self.parent) {
        //build full path from parent's full path
        fullPath = [[self.parent getFullPathWithExtension:NO] stringByAppendingPathComponent:fullPath];
    } else {
        //invalid, as a drawing must always have a parent
        [NSException raise:@"Drawing getFullPathWithExtention: A Drawing object must always have a parent." format:@"Drawing parent is nil"];
        return nil;
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

- (NSString *)saveStroke {
    
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
    return @"drawing";
}

- (NSMutableArray *)stroke {
    
    return nil;
}

@end
