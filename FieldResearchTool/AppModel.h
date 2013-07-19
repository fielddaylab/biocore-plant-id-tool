//
//  AppModel.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/16/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataWrapper.h"

@interface AppModel : NSObject

@property (nonatomic, strong) CoreDataWrapper *coreData;
@property (nonatomic, strong) NSArray *projects;
@property (nonatomic, strong) NSArray *projectComponents;
@property (nonatomic, strong) NSArray *projectIdentifications;

+ (AppModel *)sharedAppModel;

-(BOOL)save;
-(void)getAllProjectsWithHandler:(SEL)handler target:(id)target;
-(void)getAllProjectComponentsForProjectName:(NSString *)project withHandler:(SEL)handler target:(id)target;
-(void)getAllProjectIdentificationsForProjectName:(NSString *)project withHandler:(SEL)handler target:(id)target;
-(void)getProjectIdentificationsForProjectName:(NSString *)project withAttributes:(NSDictionary *)attributeNamesAndValues withHandler:(SEL)handler target:(id)target;
-(void)getUserObservationsForProjectName:(NSString *)project withHandler:(SEL)handler target:(id)target;


@end
