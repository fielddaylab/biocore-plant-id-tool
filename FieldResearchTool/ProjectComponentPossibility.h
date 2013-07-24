//
//  ProjectComponentPossibility.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/24/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectComponent, ProjectIdentificationComponentPossibility, UserObservationComponentDataJudgement;

@interface ProjectComponentPossibility : NSManagedObject

@property (nonatomic, retain) NSString * enumValue;
@property (nonatomic, retain) NSNumber * boolValue;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * longText;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * stdDev;
@property (nonatomic, retain) ProjectComponent *projectComponent;
@property (nonatomic, retain) UserObservationComponentDataJudgement *userObservationComponentDataJudgement;
@property (nonatomic, retain) NSSet *projectIdentificationComponentPossibilities;
@end

@interface ProjectComponentPossibility (CoreDataGeneratedAccessors)

- (void)addProjectIdentificationComponentPossibilitiesObject:(ProjectIdentificationComponentPossibility *)value;
- (void)removeProjectIdentificationComponentPossibilitiesObject:(ProjectIdentificationComponentPossibility *)value;
- (void)addProjectIdentificationComponentPossibilities:(NSSet *)values;
- (void)removeProjectIdentificationComponentPossibilities:(NSSet *)values;

@end
