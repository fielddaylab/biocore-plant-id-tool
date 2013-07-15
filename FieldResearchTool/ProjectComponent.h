//
//  ProjectComponent.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, ProjectComponentPossibility, UserObservationComponentData;

@interface ProjectComponent : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * mediaUrl;
@property (nonatomic, retain) NSNumber * observationType;
@property (nonatomic, retain) NSString * required;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updated;
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
