//
//  AppModel.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/16/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "AppModel.h"
#import "UserObservationComponentDataJudgement.h"

@implementation AppModel

@synthesize coreData;
@synthesize currentProject;
@synthesize currentProjectComponents;
@synthesize currentProjectIdentifications;
@synthesize currentUserObservation;
@synthesize currentUser;

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

-(void)getAllProjectComponentsWithHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"ProjectComponent" withAttribute:@"project.name" equalTo:currentProject.name withHandler:@selector(handleFetchAllProjectComponentsForProjectName:) target:target];
        });
    });
}

-(void)handleFetchAllProjectComponentsForProjectName:(NSArray *)components{
    self.currentProjectComponents = components;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ProjectComponentsResponseReady" object:nil]];
}

-(void)getAllProjectIdentificationsWithHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"ProjectIdentification" withAttribute:@"project.name" equalTo:currentProject.name withHandler:@selector(handleFetchProjectIdentifications:) target:target];
        });
    });

}

-(void)handleFetchProjectIdentifications:(NSArray *)identifications{
    self.currentProjectIdentifications = identifications;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ProjectIdentificationsResponseReady" object:nil]];
}

-(void)getProjectIdentificationsWithAttributes:(NSDictionary *)attributeNamesAndValues withHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchEntities:@"ProjectIdentification" withAttributes:attributeNamesAndValues withHandler:@selector(handleFetchProjectIdentifications:) target:target];
        });
    });
}

-(void)getUserObservationsWithHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"UserObservation" withHandler:handler target:target];
        });
    });
}

//////////////////// Nick wrote(copypasta-d) this, so beware...
-(void)getUserObservationComponentsDataWithHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"UserObservationComponentData" withHandler:handler target:target];
        });
    });
}
////////////////////

-(void)getUserForName:(NSString *)username password:(NSString *)password withHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
            [attributes setValue:username forKey:@"name"];
            [attributes setValue:password forKey:@"password"];
            [coreData fetchEntities:@"User" withAttributes:attributes withHandler:handler target:target];
        });
    });
}


-(BOOL)save{
    return [coreData save];
}

-(void)createNewUserWithAttributes:(NSDictionary *)attributes{
    User *newUser = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:coreData.managedObjectContext];
    for (NSString *key in attributes) {
        id value = [attributes objectForKey:key];
        [newUser setValue:value forKey:key];
    }
    [self save];
    currentUser = newUser;
}

-(void)createNewUserObservationWithAttributes:(NSDictionary *)attributes{
    UserObservation *userObservation = (UserObservation *)[NSEntityDescription insertNewObjectForEntityForName:@"UserObservation" inManagedObjectContext:coreData.managedObjectContext];
    userObservation.project = currentProject;
    for (NSString *key in attributes) {
        id value = [attributes objectForKey:key];
        [userObservation setValue:value forKey:key];
    }
    [self save];
    currentUserObservation = userObservation;
}

-(Media *)createNewMediaWithAttributes:(NSDictionary *)attributes forPath:(NSString *)path withType:(MediaType)type{
    Media *media = (Media *)[NSEntityDescription insertNewObjectForEntityForName:@"Media" inManagedObjectContext:coreData.managedObjectContext];
    media.created = [NSDate date];
    media.updated = [NSDate date];
    media.mediaURL = path;
    media.type = [NSNumber numberWithInt:type];
    for (NSString *key in attributes) {
        id value = [attributes objectForKey:key];
        [media setValue:value forKey:key];
    }
    [self save];
    return media;
}

@end
