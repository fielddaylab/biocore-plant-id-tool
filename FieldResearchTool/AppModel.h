//
//  AppModel.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/16/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataWrapper.h"
#import "Project.h"
#import "UserObservation.h"
#import "User.h"
#import "UserObservationComponentData.h"
#import "ProjectComponentPossibility.h"
#import "Media.h"
#import "MediaType.h"
#import "ProjectIdentificationDiscussionPost.h"

@interface AppModel : NSObject

@property (nonatomic, strong) CoreDataWrapper *coreData;
@property (nonatomic, strong) Project *currentProject;
@property (nonatomic, strong) NSArray *currentProjectComponents;
@property (nonatomic, strong) NSArray *allProjectIdentifications;
@property (nonatomic, strong) UserObservation *currentUserObservation;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSMutableArray *likelyIdentificationImages;
@property (nonatomic, strong) NSMutableArray *unlikelyIdentificationImages;

+ (AppModel *)sharedAppModel;

//save
-(BOOL)save;
//fetch
-(void)getAllProjectsWithHandler:(SEL)handler target:(id)target;
-(void)getAllProjectComponentsWithHandler:(SEL)handler target:(id)target;
-(void)getAllProjectIdentificationsWithHandler:(SEL)handler target:(id)target;
-(void)getProjectIdentificationsWithAttributes:(NSDictionary *)attributeNamesAndValues withHandler:(SEL)handler target:(id)target;
-(void)getUserObservationsWithHandler:(SEL)handler target:(id)target;
-(void)getUserObservationsForCurrentUserWithHandler:(SEL)handler target:(id)target;
-(void)getProjectComponentPossibilitiesWithAttributes:(NSDictionary *)attributeNamesAndValies withHandler:(SEL)handler target:(id)target;
-(void)getUserObservationComponentsDataWithHandler:(SEL)handler target:(id)target;
-(void)getUserForName:(NSString *)username password:(NSString *)password withHandler:(SEL)handler target:(id)target;
-(void)getUserForName:(NSString *)username withHandler:(SEL)handler target:(id)target;
-(void)getProjectIdentificationComponentPossibilitiesForPossibility:(ProjectComponentPossibility *)possibility withHandler:(SEL)handler target:(id)target;
-(void)getProjectIdentificationDiscussionsWithHandler:(SEL)handler target:(id)target;
-(void)getProjectIdentificationDiscussionPostsWithAttributes:(NSDictionary *)attributes withHandler:(SEL)handler target:(id)target;

//create
-(User *)createNewUserWithAttributes:(NSDictionary *)attributes;
-(UserObservation *)createNewUserObservationWithAttributes:(NSDictionary *)attributes;
-(UserObservationComponentData *)createNewObservationDataWithAttributes:(NSDictionary *)attributes;
-(UserObservationComponentDataJudgement *)createNewJudgementWithData:(UserObservationComponentData *)data withProjectComponentPossibility:(ProjectComponentPossibility *)possibility withAttributes:(NSDictionary *)attributes;
-(Media *)createNewMediaWithAttributes:(NSDictionary *)attributes;
-(ProjectIdentificationDiscussionPost *)createNewProjectIdentificationDiscussionPostWithAttributes:(NSDictionary *)attributes;
-(UserObservationIdentification *)createNewUserObservationIdentificationWithProjectIdentification:(ProjectIdentification *) projectIdentification withAttributes:(NSDictionary *)attributes;

//delete
-(void)deleteObject:(NSManagedObject *)objectToDelete;
-(void)deleteObjects:(NSArray *)objectsToDelete;

@end
