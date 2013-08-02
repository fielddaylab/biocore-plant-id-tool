//
//  ProjectIdentificationDiscussionPost.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 8/2/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectIdentification, ProjectIdentificationDiscussion, User;

@interface ProjectIdentificationDiscussionPost : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) ProjectIdentificationDiscussion *projectIdentificationDiscussion;
@property (nonatomic, retain) ProjectIdentification *projectIdentification;

@end
