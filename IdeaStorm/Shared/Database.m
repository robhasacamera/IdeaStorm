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

- (void)setDrawingEngineFirstRun:(_Bool)drawingEngineFirstRun {
    NSLog(@"writing");
    _drawingEngineFirstRun = drawingEngineFirstRun;
    
    bool drawingEngineNotFirstRun;
    
    if (self.drawingEngineFirstRun) {
        drawingEngineNotFirstRun = NO;
    } else {
        drawingEngineNotFirstRun = YES;
    }
    
    [self.defaults setBool:drawingEngineNotFirstRun forKey:drawingEngineNotFirstRunKey];
}

+ (UIImage *)getImageForFilename:(NSString *)filename {
    UIImage *image = nil;
    
    NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:filename];
    
    image = [[[UIImage alloc]initWithContentsOfFile:filePath] autorelease];
    
    return image;
}

+ (NSString *)documentsPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	return documentsDirectory;
}

- (void)dealloc {
    [self.defaults release];
    
    [super dealloc];
}

@end