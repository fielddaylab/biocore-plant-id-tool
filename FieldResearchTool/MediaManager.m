//
//  MediaManager.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/23/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "MediaManager.h"

@implementation MediaManager

#warning implement media manger
-(NSURL *)getMediaContentsForPath:(NSString *)path{
    if([path isEqualToString:@""]){
        //this means the media doesn't exist yet, go get it from the server
        NSLog(@"Path is invalid, go get it from server");
        //file downloaded!
        path = @"/Users/jgmoeller/iOS Development/Field Research Platform/FieldResearchTool/FieldResearchTool/Assets/page.png";
    }
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if([fileManager fileExistsAtPath:path]){
        NSLog(@"File exists at the path given!");
        return [NSURL fileURLWithPath:path];
    }
    else{
        NSLog(@"Path exists, but the file does not. Go get it from the server.");
    }
    
    
    return nil;
}

@end
