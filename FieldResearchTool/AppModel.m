//
//  AppModel.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/16/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "AppModel.h"
#import "UserObservationComponentDataJudgement.h"
#import "ObservationJudgementType.h"
#import "ProjectComponent.h"

@implementation AppModel

@synthesize coreData;
@synthesize currentProject;
@synthesize currentProjectComponents;
@synthesize allProjectIdentifications;
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

#pragma mark fetches

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
    self.allProjectIdentifications = identifications;
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

-(void)getUserObservationComponentsDataWithHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchAllEntities:@"UserObservationComponentData" withHandler:handler target:target];
        });
    });
}

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

-(void)getProjectComponentPossibilitiesWithAttributes:(NSDictionary *)attributeNamesAndValies withHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreData fetchEntities:@"ProjectComponentPossibility" withAttributes:attributeNamesAndValies withHandler:handler target:target];
        });
    });
}

-(void)getProjectIdentificationComponentPossibilitiesForPossibility:(ProjectComponentPossibility *)possibility withHandler:(SEL)handler target:(id)target{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            ProjectComponent *component = possibility.projectComponent;
            NSNumber *type = component.observationJudgementType;
            switch ([type intValue]) {
                case JUDGEMENT_ENUMERATOR:
                    [coreData fetchAllEntities:@"ProjectIdentificationComponentPossibility" withAttribute:@"projectComponentPossibility.enumValue" equalTo:possibility.enumValue withHandler:handler target:target];
                    break;
                default:
                    NSLog(@"Not fetching any possibilities because App Model isn't implemented");
                    break;
            }
        });
    });
}


#pragma mark saving

-(BOOL)save{
    return [coreData save];
}

#pragma mark creations

-(UserObservation *)createNewUserObservationWithAttributes:(NSDictionary *)attributes{
    UserObservation *observation = (UserObservation *)[NSEntityDescription insertNewObjectForEntityForName:@"UserObservation" inManagedObjectContext:coreData.managedObjectContext];
    observation.user = currentUser;
    for (NSString *key in attributes) {
        id value = [attributes objectForKey:key];
        [observation setValue:value forKey:key];
    }
    self.currentUserObservation = observation;
    [self save];
    return observation;
}

-(UserObservationComponentData *)createNewObservationDataWithAttributes:(NSDictionary *)attributes{
    UserObservationComponentData *data = (UserObservationComponentData *)[NSEntityDescription insertNewObjectForEntityForName:@"UserObservationComponentData" inManagedObjectContext:coreData.managedObjectContext];
    data.userObservation = currentUserObservation;
    for (NSString *key in attributes) {
        id value = [attributes objectForKey:key];
        [data setValue:value forKey:key];
    }
    [self save];
    return data;
}

-(UserObservationComponentDataJudgement *)createNewJudgementWithData:(UserObservationComponentData *)data withProjectComponentPossibility:(NSArray *)possibilities withAttributes:(NSDictionary *)attributes{
    UserObservationComponentDataJudgement *judgement = (UserObservationComponentDataJudgement *)[NSEntityDescription insertNewObjectForEntityForName:@"UserObservationComponentDataJudgement" inManagedObjectContext:coreData.managedObjectContext];
    judgement.userObservationComponentData = data;
    judgement.projectComponentPossibilities = [NSSet setWithArray:possibilities];
    for (NSString *key in attributes) {
        id value = [attributes objectForKey:key];
        [judgement setValue:value forKey:key];
    }
    [self save];
    return judgement;
}

-(Media *)createNewMediaWithAttributes:(NSDictionary *)attributes{
    Media *media = (Media *)[NSEntityDescription insertNewObjectForEntityForName:@"Media" inManagedObjectContext:coreData.managedObjectContext];
    for (NSString *key in attributes) {
        id value = [attributes objectForKey:key];
        [media setValue:value forKey:key];
    }
    [self save];
    return media;
}

@end
