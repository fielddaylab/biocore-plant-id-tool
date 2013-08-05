//
//  ProjectComponent.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 8/5/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Media, Project, ProjectComponentPossibility, UserObservationComponentData;

@interface ProjectComponent : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * filter;
@property (nonatomic, retain) NSNumber * observationDataType;
@property (nonatomic, retain) NSNumber * observationJudgementType;
@property (nonatomic, retain) NSNumber * required;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) Media *media;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *projectComponentPossibilities;
@property (nonatomic, retain) NSSet *userObservationComponentData;
@end

@interface ProjectComponent (CoreDataGeneratedAccessors)

- (void)addProjectComponentPossibilitiesObject:(ProjectComponentPossibility *)value;
- (void)removeProjectComponentPossibilitiesObject:(ProjectComponentPossibility *)value;
- (void)addProjectComponentPossibilities:(NSSet *)values;
- (void)removeProjectComponentPossibilities:(NSSet *)values;

- (void)addUserObservationComponentDataObject:(UserObservationComponentData *)value;
- (void)removeUserObservationComponentDataObject:(UserObservationComponentData *)value;
- (void)addUserObservationComponentData:(NSSet *)values;
- (void)removeUserObservationComponentData:(NSSet *)values;

@end
