//
//  ProjectComponentPossibility.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 8/13/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Media, ProjectComponent, ProjectIdentificationComponentPossibility, UserObservationComponentDataJudgement;

@interface ProjectComponentPossibility : NSManagedObject

@property (nonatomic, retain) NSNumber * boolValue;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * enumValue;
@property (nonatomic, retain) NSString * longText;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * stdDev;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) Media *media;
@property (nonatomic, retain) ProjectComponent *projectComponent;
@property (nonatomic, retain) NSSet *projectIdentificationComponentPossibilities;
@property (nonatomic, retain) NSSet *userObservationComponentDataJudgement;
@end

@interface ProjectComponentPossibility (CoreDataGeneratedAccessors)

- (void)addProjectIdentificationComponentPossibilitiesObject:(ProjectIdentificationComponentPossibility *)value;
- (void)removeProjectIdentificationComponentPossibilitiesObject:(ProjectIdentificationComponentPossibility *)value;
- (void)addProjectIdentificationComponentPossibilities:(NSSet *)values;
- (void)removeProjectIdentificationComponentPossibilities:(NSSet *)values;

- (void)addUserObservationComponentDataJudgementObject:(UserObservationComponentDataJudgement *)value;
- (void)removeUserObservationComponentDataJudgementObject:(UserObservationComponentDataJudgement *)value;
- (void)addUserObservationComponentDataJudgement:(NSSet *)values;
- (void)removeUserObservationComponentDataJudgement:(NSSet *)values;

@end
