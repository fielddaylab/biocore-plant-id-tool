//
//  UserObservationComponentData.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 8/5/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Media, ProjectComponent, UserObservation, UserObservationComponentDataJudgement;

@interface UserObservationComponentData : NSManagedObject

@property (nonatomic, retain) NSNumber * boolValue;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * enumValue;
@property (nonatomic, retain) NSString * longText;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSNumber * wasJudged;
@property (nonatomic, retain) NSNumber * isFiltered;
@property (nonatomic, retain) Media *media;
@property (nonatomic, retain) ProjectComponent *projectComponent;
@property (nonatomic, retain) UserObservation *userObservation;
@property (nonatomic, retain) NSSet *userObservationComponentDataJudgement;
@end

@interface UserObservationComponentData (CoreDataGeneratedAccessors)

- (void)addUserObservationComponentDataJudgementObject:(UserObservationComponentDataJudgement *)value;
- (void)removeUserObservationComponentDataJudgementObject:(UserObservationComponentDataJudgement *)value;
- (void)addUserObservationComponentDataJudgement:(NSSet *)values;
- (void)removeUserObservationComponentDataJudgement:(NSSet *)values;

@end
