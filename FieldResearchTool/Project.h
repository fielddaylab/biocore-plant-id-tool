//
//  Project.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/16/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectComponent, ProjectIdentification, UserObservation;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * allowedInterpretations;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * iconMediaUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * splashMediaUrl;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *projectComponents;
@property (nonatomic, retain) NSSet *projectIdentifications;
@property (nonatomic, retain) NSSet *userObservations;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addProjectComponentsObject:(ProjectComponent *)value;
- (void)removeProjectComponentsObject:(ProjectComponent *)value;
- (void)addProjectComponents:(NSSet *)values;
- (void)removeProjectComponents:(NSSet *)values;

- (void)addProjectIdentificationsObject:(ProjectIdentification *)value;
- (void)removeProjectIdentificationsObject:(ProjectIdentification *)value;
- (void)addProjectIdentifications:(NSSet *)values;
- (void)removeProjectIdentifications:(NSSet *)values;

- (void)addUserObservationsObject:(UserObservation *)value;
- (void)removeUserObservationsObject:(UserObservation *)value;
- (void)addUserObservations:(NSSet *)values;
- (void)removeUserObservations:(NSSet *)values;

@end
