//
//  User.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserObservationComponentData, UserObservationComponentDataJudgement, UserObservationIdentification;

@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * mediaUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *userObservationComponentDataJudgements;
@property (nonatomic, retain) NSSet *userObservationComponetData;
@property (nonatomic, retain) NSSet *userObservationIdentifications;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addUserObservationComponentDataJudgementsObject:(UserObservationComponentDataJudgement *)value;
- (void)removeUserObservationComponentDataJudgementsObject:(UserObservationComponentDataJudgement *)value;
- (void)addUserObservationComponentDataJudgements:(NSSet *)values;
- (void)removeUserObservationComponentDataJudgements:(NSSet *)values;

- (void)addUserObservationComponetDataObject:(UserObservationComponentData *)value;
- (void)removeUserObservationComponetDataObject:(UserObservationComponentData *)value;
- (void)addUserObservationComponetData:(NSSet *)values;
- (void)removeUserObservationComponetData:(NSSet *)values;

- (void)addUserObservationIdentificationsObject:(UserObservationIdentification *)value;
- (void)removeUserObservationIdentificationsObject:(UserObservationIdentification *)value;
- (void)addUserObservationIdentifications:(NSSet *)values;
- (void)removeUserObservationIdentifications:(NSSet *)values;

@end
