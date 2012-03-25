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

//TODO: get fullimage path and store it somewhere.
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
    [self saveFullImage];
    [self saveThumbnailImage];
}

- (NSString *)getFullPathWithDataFilename:(bool)yesOrNo {
    NSString *fullPath = [self.pathID stringByAppendingPathExtension:[Drawing extention]];
    
    if (self.parent) {
        //build full path from parent's full path
        fullPath = [[self.parent getFullPathWithDataFilename:NO] stringByAppendingPathComponent:fullPath];
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
    NSString *thumbImagePath = nil;
    
    if (self.thumbnailImage) {
        thumbImagePath = [[self getFullPathWithDataFilename:NO] stringByAppendingPathComponent:kThumbImageFileName];
        
        NSData *thumbImageData = UIImagePNGRepresentation(self.thumbnailImage);
        
        [thumbImageData writeToFile:thumbImagePath atomically:YES];
    }
    
    return thumbImagePath;
}

- (NSString *)saveFullImage {
    NSString *fullImagePath = nil;
    
    if (self.fullImage) {
        fullImagePath = [[self getFullPathWithDataFilename:NO] stringByAppendingPathComponent:kFullImageFileName];
        
        NSData *fullImageData = UIImagePNGRepresentation(self.fullImage);
        
        [fullImageData writeToFile:fullImagePath atomically:YES];
    }
    
    return fullImagePath;
}

- (NSString *)saveStroke {
    
    return nil;
}

- (bool)exportToCameraRoll {
    
    return nil;
}

- (UIImage *)thumbnailImage {
    
    if (_thumbnailImage) {
        return _thumbnailImage;
    }
    
    NSString *thumbnailImagePath = [[self getFullPathWithDataFilename:NO] stringByAppendingPathComponent:kThumbImageFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:thumbnailImagePath]) {
        _thumbnailImage = [UIImage imageWithContentsOfFile:thumbnailImagePath];
        
        return _thumbnailImage;
    }
    
    return nil;
}

- (UIImage *)fullImage {
    
    if (_fullImage) {
        return _fullImage;
    }
    
    NSString *fullImagePath = [[self getFullPathWithDataFilename:NO] stringByAppendingPathComponent:kFullImageFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullImagePath]) {
        _fullImage = [UIImage imageWithContentsOfFile:fullImagePath];
        
        return _fullImage;
    }
    
    return nil;
}

//Overriding the setter for fullImage to create the thumbnail as well.
- (void)setFullImage:(UIImage *)fullImage {
    
    _fullImage = fullImage;
    
    self.thumbnailImage = [[fullImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(kThumbWidth, kThumbHeight) interpolationQuality:kCGInterpolationHigh] retain];
}

+ (NSString *)extention {
    return @"drawing";
}

- (NSMutableArray *)stroke {
    
    return nil;
}

- (void)dealloc {
    if (_thumbnailImage) {
        [_thumbnailImage release];
    }
    
    if (_fullImage) {
        [_fullImage release];
    }
    
    if (_pathID) {
        [_pathID release];
    }
    
    [super dealloc];
}

@end
