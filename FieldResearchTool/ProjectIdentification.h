//
//  ProjectIdentification.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/24/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Media, Project, ProjectIdentificationComponentPossibility, UserObservationIdentification;

@interface ProjectIdentification : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * identificationDescription;
@property (nonatomic, retain) NSNumber * authorCreated;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) Media *media;
@property (nonatomic, retain) NSSet *userObservationIdentifications;
@property (nonatomic, retain) NSSet *projectIdentificationComponentPossibilities;
@end

@interface ProjectIdentification (CoreDataGeneratedAccessors)

- (void)addUserObservationIdentificationsObject:(UserObservationIdentification *)value;
- (void)removeUserObservationIdentificationsObject:(UserObservationIdentification *)value;
- (void)addUserObservationIdentifications:(NSSet *)values;
- (void)removeUserObservationIdentifications:(NSSet *)values;

- (void)addProjectIdentificationComponentPossibilitiesObject:(ProjectIdentificationComponentPossibility *)value;
- (void)removeProjectIdentificationComponentPossibilitiesObject:(ProjectIdentificationComponentPossibility *)value;
- (void)addProjectIdentificationComponentPossibilities:(NSSet *)values;
- (void)removeProjectIdentificationComponentPossibilities:(NSSet *)values;

@end
