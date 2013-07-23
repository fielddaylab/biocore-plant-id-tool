//
//  UserObservation.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/23/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, UserObservationComponentData, UserObservationIdentification;

@interface UserObservation : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *userObservationComponentData;
@property (nonatomic, retain) NSSet *userObservationIdentifications;
@end

@interface UserObservation (CoreDataGeneratedAccessors)

- (void)addUserObservationComponentDataObject:(UserObservationComponentData *)value;
- (void)removeUserObservationComponentDataObject:(UserObservationComponentData *)value;
- (void)addUserObservationComponentData:(NSSet *)values;
- (void)removeUserObservationComponentData:(NSSet *)values;

- (void)addUserObservationIdentificationsObject:(UserObservationIdentification *)value;
- (void)removeUserObservationIdentificationsObject:(UserObservationIdentification *)value;
- (void)addUserObservationIdentifications:(NSSet *)values;
- (void)removeUserObservationIdentifications:(NSSet *)values;

@end
