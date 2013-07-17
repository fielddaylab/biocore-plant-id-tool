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
-(void)getAllProjects;
-(void)getAllProjectComponentsForProjectName:(NSString *)project;
-(void)getAllProjectIdentificationsForProjectName:(NSString *)project;
-(void)getProjectIdentificationsForProjectName:(NSString *)project withAttributes:(NSDictionary *)attributeNamesAndValues;


@end
