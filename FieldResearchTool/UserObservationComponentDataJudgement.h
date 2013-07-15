//
//  UserObservationComponentDataJudgement.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectComponentPossibility, User, UserObservationComponentData;

@interface UserObservationComponentDataJudgement : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) ProjectComponentPossibility *projectComponentPossibility;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) UserObservationComponentData *userObservationComponentData;

@end