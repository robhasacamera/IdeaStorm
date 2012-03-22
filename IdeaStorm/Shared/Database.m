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

+ (NSString *)libraryPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	return documentsDirectory;
}

//TODO: Remove line that is commented out: [uuidString autorelease];
+ (NSString *)generateUniqueID {
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // transfer ownership of the string
    // to the autorelease pool
    //[uuidString autorelease];//commented this out as it was causing issue with the string being released too soon.
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

#pragma mark - GalleryItem Management

- (bool)saveGalleryItem:(NSObject <GalleryItem> *)galleryItem {
    NSError *error;
    bool success;
    
    NSString *dataPath = [galleryItem getFullPathWithExtension:YES];
    
    NSMutableData *data = [[NSMutableData alloc]init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [archiver encodeObject:galleryItem forKey:kGalleryItemDataKey];
    [archiver finishEncoding];
    
    success = [data writeToFile:dataPath options:NSDataWritingAtomic error:&error];
    
    [archiver release];
    [data release];
    
    if (!success) {
        NSLog(@"saveGalleryItem Error: %@", error);
        NSLog(@"saveGalleryItem Error userInfo: %@", [error userInfo]);
    }
    
    return success;
}

- (NSObject <GalleryItem> *)getRootGalleryItem {
    Stack *rootStack;
    
    //build path to root stack
    NSString *pathToRootFile = [Database libraryPath];
    
    NSString *rootFolder = kGalleryItemRoot;
    
    rootFolder = [rootFolder stringByAppendingPathExtension:[Stack extention]];
    
    pathToRootFile = [pathToRootFile stringByAppendingPathComponent:rootFolder];
    
    pathToRootFile = [pathToRootFile stringByAppendingPathComponent:kGalleryItemDataFileName];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:pathToRootFile]) {
        //load root stack
        rootStack = (Stack *)[[self getGalleryItemForPath:pathToRootFile] retain];
    } else {
        //create and save root stack
        rootStack = [[Stack alloc]initWithPathID:kGalleryItemRoot];
        
        [self saveGalleryItem:rootStack];
    }
    
    return rootStack;
}

- (NSObject <GalleryItem> *)getGalleryItemForPath:(NSString *)path {
    NSObject <GalleryItem> *galleryItem;
    
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    
    galleryItem = [[[unarchiver decodeObjectForKey:kGalleryItemDataKey] retain] autorelease];
    
    [unarchiver finishDecoding];
    [unarchiver release];
    [data release];
    
    return galleryItem;
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