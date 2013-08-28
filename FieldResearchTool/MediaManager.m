//
//  MediaManager.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/23/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "MediaManager.h"

@implementation MediaManager

+ (MediaManager *)sharedMediaManager{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

//this is a test, and doesn't currently work
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

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//replace this method with code to find the image
-(UIImage *)getImageNamed:(NSString *)imageName{
    //keep in mind this will cache the image, dont know when it will be deallocated
    return [UIImage imageNamed:imageName];
}

@end
