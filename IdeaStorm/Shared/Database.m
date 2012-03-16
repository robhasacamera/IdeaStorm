//
//  Database.m
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "Database.h"

@implementation Database

@synthesize defaults = _defaults;
@synthesize drawingEngineFirstRun = _drawingEngineFirstRun;

#pragma mark - Initialization

- (id)init {
    self = [super init];
    
    if (self) {
        self.defaults = [[NSUserDefaults alloc]init];
        
        drawingEngineNotFirstRunKey = @"DrawingEngine Not First Run";
        
        bool drawingEngineNotFirstRun = [self.defaults boolForKey:drawingEngineNotFirstRunKey];
        
        if (drawingEngineNotFirstRun) {
            _drawingEngineFirstRun = NO;
        } else {
            _drawingEngineFirstRun = YES;
        }
    }
    
    return self;
}

#pragma mark - User Defaults

- (void)setDrawingEngineFirstRun:(_Bool)drawingEngineFirstRun {
    _drawingEngineFirstRun = drawingEngineFirstRun;
    
    bool drawingEngineNotFirstRun;
    
    if (self.drawingEngineFirstRun) {
        drawingEngineNotFirstRun = NO;
    } else {
        drawingEngineNotFirstRun = YES;
    }
    
    [self.defaults setBool:drawingEngineNotFirstRun forKey:drawingEngineNotFirstRunKey];
}

#pragma mark - Getting Presaved Files

+ (UIImage *)getImageForFilename:(NSString *)filename {
    UIImage *image = nil;
    
    NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:filename];
    
    image = [[[UIImage alloc]initWithContentsOfFile:filePath] autorelease];
    
    return image;
}

#pragma mark - Help Methods

+ (NSString *)documentsPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	return documentsDirectory;
}

+ (NSString *)generateUniqueID {
    return nil;
}

#pragma mark - GalleryItem Management

- (bool)saveGalleryItem:(NSObject <GalleryItem> *)galleryItem {
    return nil;
}

- (NSObject <GalleryItem> *)getRootGalleryItem {
    return nil;
}

- (bool)moveGalleryItem:(NSObject <GalleryItem> *)child intoGalleryItem:(NSObject <GalleryItem> *)parent {
    return nil;
}

- (bool)deleteGalleryItem:(NSObject <GalleryItem> *)galleryIten {
    return nil;
}

- (void)dealloc {
    [self.defaults release];
    
    [super dealloc];
}

@end