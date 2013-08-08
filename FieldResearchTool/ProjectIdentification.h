//
//  ProjectIdentification.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/7/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Media, Project, ProjectIdentificationComponentPossibility, ProjectIdentificationDiscussionPost, UserObservationIdentification;

@interface ProjectIdentification : NSManagedObject

@property (nonatomic, retain) NSString * alternateName;
@property (nonatomic, retain) NSNumber * authorCreated;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * identificationDescription;
@property (nonatomic, retain) NSNumber * numOfNils;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *media;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *projectIdentificationComponentPossibilities;
@property (nonatomic, retain) NSSet *projectIdentificationDiscussionPosts;
@property (nonatomic, retain) NSSet *userObservationIdentifications;
@end

@interface ProjectIdentification (CoreDataGeneratedAccessors)

- (void)addMediaObject:(Media *)value;
- (void)removeMediaObject:(Media *)value;
- (void)addMedia:(NSSet *)values;
- (void)removeMedia:(NSSet *)values;

- (void)addProjectIdentificationComponentPossibilitiesObject:(ProjectIdentificationComponentPossibility *)value;
- (void)removeProjectIdentificationComponentPossibilitiesObject:(ProjectIdentificationComponentPossibility *)value;
- (void)addProjectIdentificationComponentPossibilities:(NSSet *)values;
- (void)removeProjectIdentificationComponentPossibilities:(NSSet *)values;

- (void)addProjectIdentificationDiscussionPostsObject:(ProjectIdentificationDiscussionPost *)value;
- (void)removeProjectIdentificationDiscussionPostsObject:(ProjectIdentificationDiscussionPost *)value;
- (void)addProjectIdentificationDiscussionPosts:(NSSet *)values;
- (void)removeProjectIdentificationDiscussionPosts:(NSSet *)values;

- (void)addUserObservationIdentificationsObject:(UserObservationIdentification *)value;
- (void)removeUserObservationIdentificationsObject:(UserObservationIdentification *)value;
- (void)addUserObservationIdentifications:(NSSet *)values;
- (void)removeUserObservationIdentifications:(NSSet *)values;

@end
