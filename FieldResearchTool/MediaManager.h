//
//  MediaManager.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/23/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaManager : NSObject

-(NSURL *)getMediaContentsForPath:(NSString *)path;

@end
