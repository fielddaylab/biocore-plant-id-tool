//
//  Project.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/24/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Media, ProjectComponent, ProjectIdentification, User;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * allowedInterpretations;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *projectIdentifications;
@property (nonatomic, retain) NSSet *projectComponents;
@property (nonatomic, retain) NSSet *users;
@property (nonatomic, retain) Media *media;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addProjectIdentificationsObject:(ProjectIdentification *)value;
- (void)removeProjectIdentificationsObject:(ProjectIdentification *)value;
- (void)addProjectIdentifications:(NSSet *)values;
- (void)removeProjectIdentifications:(NSSet *)values;

- (void)addProjectComponentsObject:(ProjectComponent *)value;
- (void)removeProjectComponentsObject:(ProjectComponent *)value;
- (void)addProjectComponents:(NSSet *)values;
- (void)removeProjectComponents:(NSSet *)values;

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
