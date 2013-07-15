//
//  UserObservationIdentification.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectIdentification, User, UserObservation;

@interface UserObservationIdentification : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) ProjectIdentification *projectIdentification;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) UserObservation *userObservation;

@end
