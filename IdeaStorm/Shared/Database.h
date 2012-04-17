//
//  Database.h
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GalleryItem.h"
#import "Stack.h"
#import "Drawing.h"

#define kGalleryItemRoot @"root"
#define kGalleryItemDataFileName @"data.plist"
#define kGalleryItemDataKey @"galleryItem"

@interface Database : NSObject {
    NSString *drawingEngineNotFirstRunKey;
}

@property (strong, nonatomic) NSUserDefaults *defaults;
@property (nonatomic, readonly) bool drawingEngineFirstRun;

#pragma mark - User Defaults

- (void)setDrawingEngineFirstRun:(_Bool)drawingEngineFirstRun;

#pragma mark - Getting Presaved Files

+ (UIImage *)getImageForFilename:(NSString *)filename;

#pragma mark - Help Methods

+ (NSString *)documentsPath;

+ (NSString *)libraryPath;

+ (NSString *)generateUniqueID;

#pragma mark - GalleryItem Management

- (bool)saveGalleryItem:(NSObject <GalleryItem> *)galleryItem;

- (NSObject <GalleryItem> *)getRootGalleryItem;

+ (NSObject <GalleryItem> *)getGalleryItemForPath:(NSString *)path;

- (bool)moveGalleryItem:(NSObject <GalleryItem> *)child intoGalleryItem:(NSObject <GalleryItem> *)parent;

- (bool)deleteGalleryItem:(NSObject <GalleryItem> *)galleryItem;



@end
