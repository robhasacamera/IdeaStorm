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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        //initialize with data from coder
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (NSString *)getFullPath {
    
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

- (bool)exportToCameraRoll {
    
    return nil;
}

@end
