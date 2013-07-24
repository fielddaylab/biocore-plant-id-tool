//
//  UserObservationComponentDataJudgement.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/24/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectComponentPossibility, UserObservationComponentData;

@interface UserObservationComponentDataJudgement : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * enumValue;
@property (nonatomic, retain) NSNumber * boolValue;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * longText;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) UserObservationComponentData *userObservationComponentData;
@property (nonatomic, retain) NSSet *projectComponentPossibilities;
@end

@interface UserObservationComponentDataJudgement (CoreDataGeneratedAccessors)

- (void)addProjectComponentPossibilitiesObject:(ProjectComponentPossibility *)value;
- (void)removeProjectComponentPossibilitiesObject:(ProjectComponentPossibility *)value;
- (void)addProjectComponentPossibilities:(NSSet *)values;
- (void)removeProjectComponentPossibilities:(NSSet *)values;

@end
