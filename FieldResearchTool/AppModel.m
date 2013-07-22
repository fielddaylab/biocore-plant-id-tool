//
//  AppModel.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/16/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "AppModel.h"
#import "UserObservation.h"
#import "UserObservationComponentData.h"

@implementation AppModel

@synthesize coreData;
@synthesize currentProject;
@synthesize currentProjectComponents;
@synthesize currentProjectIdentifications;
@synthesize currentUserObservation;

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

-(void)getAllProjectsWithHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"Project" withHandler:@selector(handleFetchOfAllProjects:) target:target];
        });
    });
}

-(void)getAllProjectComponentsForProjectName:(NSString *)project withHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"ProjectComponent" withAttribute:@"project.name" equalTo:project withHandler:@selector(handleFetchAllProjectComponentsForProjectName:) target:target];
        });
    });
}

-(void)handleFetchAllProjectComponentsForProjectName:(NSArray *)components{
    self.currentProjectComponents = components;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ProjectComponentsResponseReady" object:nil]];
}

-(void)getAllProjectIdentificationsForProjectName:(NSString *)project withHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"ProjectIdentification" withAttribute:@"project.name" equalTo:project withHandler:@selector(handleFetchProjectIdentifications:) target:target];
        });
    });

}

-(void)handleFetchProjectIdentifications:(NSArray *)identifications{
    self.currentProjectIdentifications = identifications;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ProjectIdentificationsResponseReady" object:nil]];
}

-(void)getProjectIdentificationsForProjectName:(NSString *)project withAttributes:(NSDictionary *)attributeNamesAndValues withHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchEntities:@"ProjectIdentification" withAttributes:attributeNamesAndValues withHandler:@selector(handleFetchProjectIdentifications:) target:target];
        });
    });
}

-(void)getUserObservationsForProjectName:(NSString *)project withHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"UserObservation" withHandler:@selector(handleFetchUserObservations:) target:target];
        });
    });
}

-(void)handleFetchUserObservations:(NSArray *)observations{
    NSLog(@"handleFetchUserObservations");
}

-(BOOL)save{
    return [coreData save];
}

-(void)createNewUserObservationForProject:(Project *)project withAttributes:(NSDictionary *)attributes withHandler:(SEL)handler target:(id)target{
    UserObservation *userObservation = (UserObservation *)[NSEntityDescription insertNewObjectForEntityForName:@"UserObservation" inManagedObjectContext:coreData.managedObjectContext];
    userObservation.project = project;
    for (NSString *key in attributes) {
        id value = [attributes objectForKey:key];
        [userObservation setValue:value forKey:key];
    }
    [self save];
    currentUserObservation = userObservation;
}

-(void)createNewUserObservationComponentDataForUserObservation:(UserObservation *)userObservation withProjectComponent:(ProjectComponent *)projectComponent withAttributes:(NSDictionary *)attributes withHandler:(SEL)handler target:(id)target{
    UserObservationComponentData *userObservationComponentData = (UserObservationComponentData *)[NSEntityDescription insertNewObjectForEntityForName:@"UserObservationComponentData" inManagedObjectContext:coreData.managedObjectContext];
    userObservationComponentData.userObservation = userObservation;
    userObservationComponentData.projectComponent = projectComponent;
    for (NSString *key in attributes) {
        id value = [attributes objectForKey:key];
        [userObservationComponentData setValue:value forKey:key];
    }
    [self save];
    //save to array or something
}

@end
