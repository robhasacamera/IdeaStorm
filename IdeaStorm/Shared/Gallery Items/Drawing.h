//
//  Drawing.h
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GalleryItem.h"
#import "Database.h"

@interface Drawing : NSObject <GalleryItem>

@property (nonatomic, retain) NSMutableArray *stroke;

- (NSString *)saveStroke;

@end
