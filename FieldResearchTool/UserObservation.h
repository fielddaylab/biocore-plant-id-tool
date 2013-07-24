//
//  UserObservation.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/24/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User, UserObservationComponentData, UserObservationIdentification;

@interface UserObservation : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *userObservationIdentifications;
@property (nonatomic, retain) NSSet *userObservationComponentData;
@end

@interface UserObservation (CoreDataGeneratedAccessors)

- (void)addUserObservationIdentificationsObject:(UserObservationIdentification *)value;
- (void)removeUserObservationIdentificationsObject:(UserObservationIdentification *)value;
- (void)addUserObservationIdentifications:(NSSet *)values;
- (void)removeUserObservationIdentifications:(NSSet *)values;

- (void)addUserObservationComponentDataObject:(UserObservationComponentData *)value;
- (void)removeUserObservationComponentDataObject:(UserObservationComponentData *)value;
- (void)addUserObservationComponentData:(NSSet *)values;
- (void)removeUserObservationComponentData:(NSSet *)values;

@end
