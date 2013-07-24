//
//  ProjectComponent.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/24/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Media, Project, ProjectComponentPossibility, UserObservationComponentData;

@interface ProjectComponent : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * required;
@property (nonatomic, retain) NSNumber * observationDataType;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSNumber * observationJudgementType;
@property (nonatomic, retain) NSNumber * wasObserved;
@property (nonatomic, retain) NSNumber * wasJudged;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *userObservationComponentData;
@property (nonatomic, retain) NSSet *projectComponentPossibilities;
@property (nonatomic, retain) Media *media;
@end

@interface ProjectComponent (CoreDataGeneratedAccessors)

- (void)addUserObservationComponentDataObject:(UserObservationComponentData *)value;
- (void)removeUserObservationComponentDataObject:(UserObservationComponentData *)value;
- (void)addUserObservationComponentData:(NSSet *)values;
- (void)removeUserObservationComponentData:(NSSet *)values;

- (void)addProjectComponentPossibilitiesObject:(ProjectComponentPossibility *)value;
- (void)removeProjectComponentPossibilitiesObject:(ProjectComponentPossibility *)value;
- (void)addProjectComponentPossibilities:(NSSet *)values;
- (void)removeProjectComponentPossibilities:(NSSet *)values;

@end
