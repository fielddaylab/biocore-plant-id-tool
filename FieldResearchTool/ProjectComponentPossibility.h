//
//  ProjectComponentPossibility.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/16/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectComponent, ProjectIdentificationComponentPossibility, UserObservationComponentDataJudgement;

@interface ProjectComponentPossibility : NSManagedObject

@property (nonatomic, retain) NSNumber * boolValue;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * enumDescription;
@property (nonatomic, retain) NSString * mediaUrl;
@property (nonatomic, retain) NSNumber * rangeNumber1;
@property (nonatomic, retain) NSNumber * rangeNumber2;
@property (nonatomic, retain) NSNumber * rangeOperator;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) ProjectComponent *projectComponent;
@property (nonatomic, retain) NSSet *projectIdentificationComponentPossibilities;
@property (nonatomic, retain) NSSet *userObservationComponentDataJudgements;
@end

@interface ProjectComponentPossibility (CoreDataGeneratedAccessors)

- (void)addProjectIdentificationComponentPossibilitiesObject:(ProjectIdentificationComponentPossibility *)value;
- (void)removeProjectIdentificationComponentPossibilitiesObject:(ProjectIdentificationComponentPossibility *)value;
- (void)addProjectIdentificationComponentPossibilities:(NSSet *)values;
- (void)removeProjectIdentificationComponentPossibilities:(NSSet *)values;

- (void)addUserObservationComponentDataJudgementsObject:(UserObservationComponentDataJudgement *)value;
- (void)removeUserObservationComponentDataJudgementsObject:(UserObservationComponentDataJudgement *)value;
- (void)addUserObservationComponentDataJudgements:(NSSet *)values;
- (void)removeUserObservationComponentDataJudgements:(NSSet *)values;

@end
