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

//these will need to be called asyncronously
-(void)getAllProjects;
-(void)getAllProjectComponentsForProjectName:(NSString *)project;
-(void)getAllProjectIdentificationsForProjectName:(NSString *)project;


@end
