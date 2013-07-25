//
//  User.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/24/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, UserObservation;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *userObservations;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addUserObservationsObject:(UserObservation *)value;
- (void)removeUserObservationsObject:(UserObservation *)value;
- (void)addUserObservations:(NSSet *)values;
- (void)removeUserObservations:(NSSet *)values;

@end
