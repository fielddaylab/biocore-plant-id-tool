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

@interface AppModel : NSObject

@property (nonatomic, strong) CoreDataWrapper *coreData;
@property (nonatomic, strong) Project *currentProject;
@property (nonatomic, strong) NSArray *currentProjectComponents;
@property (nonatomic, strong) NSArray *currentProjectIdentifications;
@property (nonatomic, strong) UserObservation *currentUserObservation;
@property (nonatomic, strong) User *currentUser;

+ (AppModel *)sharedAppModel;

-(BOOL)save;
-(void)getAllProjectsWithHandler:(SEL)handler target:(id)target;
-(void)getAllProjectComponentsWithHandler:(SEL)handler target:(id)target;
-(void)getAllProjectIdentificationsWithHandler:(SEL)handler target:(id)target;
-(void)getProjectIdentificationsWithAttributes:(NSDictionary *)attributeNamesAndValues withHandler:(SEL)handler target:(id)target;
-(void)getUserObservationsWithHandler:(SEL)handler target:(id)target;

//Nick's faulty attempt at testing...
-(void)getUserObservationComponentsDataWithHandler:(SEL)handler target:(id)target;

-(void)getUserForName:(NSString *)username password:(NSString *)password withHandler:(SEL)handler target:(id)target;


-(Media *)createNewMediaWithAttributes:(NSDictionary *)attributes forPath:(NSString *)path withType:(MediaType)type;


@end