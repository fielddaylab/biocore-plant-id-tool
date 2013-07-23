//
//  Media.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/23/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MediaManager.h"

@class Project, ProjectComponent, ProjectComponentPossibility, ProjectIdentification, User, UserObservationComponentData;

@interface Media : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * mediaURL;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) ProjectComponent *projectComponent;
@property (nonatomic, retain) ProjectComponentPossibility *projectComponentPossibility;
@property (nonatomic, retain) ProjectIdentification *projectIdentification;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) UserObservationComponentData *userObservationComponentData;
@property (nonatomic, retain) MediaManager *mediaManager;

-(NSURL *)getMedia;

@end
