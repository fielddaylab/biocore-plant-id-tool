//
//  AppModel.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/16/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

@synthesize coreData;
@synthesize projects;
@synthesize projectComponents;
@synthesize projectIdentifications;

+ (id)sharedAppModel
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

#pragma mark Init/dealloc
- (id) init
{
    self = [super init];
    if(self)
    {
        coreData = [[CoreDataWrapper alloc]init];
	}
    return self;
}

-(void)getAllProjects{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"Project" withHandler:@selector(handleFetchOfAllProjects:)];
        });
    });
}

-(void)handleFetchOfAllProjects:(NSArray *)projects{
    //handle the retrieval of all the projects
    NSLog(@"handleAllProjectsCalled");
}

-(void)getAllProjectComponentsForProjectName:(NSString *)project{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"ProjectComponent" withAttribute:@"project.name" equalTo:project withHandler:@selector(handleFetchAllProjectComponentsForProjectName:)];
        });
    });
}

-(void)handleFetchAllProjectComponentsForProjectName:(NSArray *)components{
    projectComponents = components;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ProjectComponentsResponseReady" object:nil]];
}

-(void)getAllProjectIdentificationsForProjectName:(NSString *)project{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"ProjectIdentification" withAttribute:@"project.name" equalTo:project withHandler:@selector(handleFetchProjectIdentifications:)];
        });
    });

}

-(void)handleFetchProjectIdentifications:(NSArray *)identifications{
    projectIdentifications = identifications;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ProjectIdentificationsResponseReady" object:nil]];
}

-(void)getProjectIdentificationsForProjectName:(NSString *)project withAttributes:(NSDictionary *)attributeNamesAndValues{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchEntities:@"ProjectIdentification" withAttributes:attributeNamesAndValues withHandler:@selector(handleFetchProjectIdentifications:)];
        });
    });
}

@end
