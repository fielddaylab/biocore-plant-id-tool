//
//  UserObservationComponentDataJudgement.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 8/13/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectComponentPossibility, UserObservationComponentData;

@interface UserObservationComponentDataJudgement : NSManagedObject

@property (nonatomic, retain) NSNumber * boolValue;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * enumValue;
@property (nonatomic, retain) NSString * longText;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) ProjectComponentPossibility *projectComponentPossibility;
@property (nonatomic, retain) UserObservationComponentData *userObservationComponentData;

@end
