//
//  UserObservationComponentData.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectComponent, User, UserObservation, UserObservationComponentDataJudgement;

@interface UserObservationComponentData : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * data;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) ProjectComponent *projectComponent;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) UserObservation *userObservation;
@property (nonatomic, retain) NSSet *userObservationComponentDataJudgements;
@end

@interface UserObservationComponentData (CoreDataGeneratedAccessors)

- (void)addUserObservationComponentDataJudgementsObject:(UserObservationComponentDataJudgement *)value;
- (void)removeUserObservationComponentDataJudgementsObject:(UserObservationComponentDataJudgement *)value;
- (void)addUserObservationComponentDataJudgements:(NSSet *)values;
- (void)removeUserObservationComponentDataJudgements:(NSSet *)values;

@end
