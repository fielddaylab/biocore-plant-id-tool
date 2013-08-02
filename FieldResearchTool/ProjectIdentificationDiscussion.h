//
//  ProjectIdentificationDiscussion.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 8/2/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Media, Project;

@interface ProjectIdentificationDiscussion : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) Media *media;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *projectIdentificationDiscussionPosts;
@end

@interface ProjectIdentificationDiscussion (CoreDataGeneratedAccessors)

- (void)addProjectIdentificationDiscussionPostsObject:(NSManagedObject *)value;
- (void)removeProjectIdentificationDiscussionPostsObject:(NSManagedObject *)value;
- (void)addProjectIdentificationDiscussionPosts:(NSSet *)values;
- (void)removeProjectIdentificationDiscussionPosts:(NSSet *)values;

@end
