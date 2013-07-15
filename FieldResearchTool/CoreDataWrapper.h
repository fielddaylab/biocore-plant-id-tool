//
//  CoreDataWrapper.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataWrapper : NSObject

+ (CoreDataWrapper *)sharedCoreData;

//this will need to be called asyncronously
-(NSArray *)getProjectComponentsForProjectName:(NSString *)project;
-(NSArray *)getProjectIdentificationsForProjectName:(NSString *)project;

@end
