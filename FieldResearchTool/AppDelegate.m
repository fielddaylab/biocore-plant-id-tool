//
//  AppDelegate.m
//  FieldResearchTool
//
//  Created by Phil Dougherty on 7/11/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "IncrementalStore.h"
#import "Project.h"
#import "ProjectComponent.h"
#import "ProjectIdentification.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:[[RootViewController alloc] init]];
    [self.window makeKeyAndVisible];
    //setup example data
    //[self createSampleData];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FieldResearchTool" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{    
    if(_persistentStoreCoordinator != nil) return _persistentStoreCoordinator;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    //turn off AFIncremental store for right now until the server is set up
//    AFIncrementalStore *incrementalStore = (AFIncrementalStore *)[_persistentStoreCoordinator addPersistentStoreWithType:[IncrementalStore type] configuration:nil URL:nil options:nil error:nil];
//    
//    NSError *error = nil;
//    if (![incrementalStore.backingPersistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error])
//    {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
    
    //normal Core Data    
    NSError *error = nil;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FieldResearchTool.sqlite"];
        
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark Sample Data

-(void)createSampleData{
    Project *project = (Project *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
    project.allowedInterpretations = [NSNumber numberWithInt:1];
    project.created = [NSDate date];
    project.iconMediaUrl = @"iconMediaURL";
    project.name = @"Biocore";
    project.splashMediaUrl = @"splashMediaURL";
    project.updated = [NSDate date];
    project.projectComponents = nil;
    project.projectIdentifications = nil;
    project.userObservations = nil;
    
    ProjectComponent *leafType = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
    leafType.created = [NSDate date];
    leafType.mediaUrl = @"mediaURL";
    leafType.observationType = [NSNumber numberWithInt:0]; //0 for enum
    leafType.required = @"YES"; //shouldn't this be a bool?
    leafType.title = @"Leaf Type";
    leafType.updated = [NSDate date];
    leafType.projectComponentPossibilities = nil;
    leafType.project = project;
    leafType.userObservationComponentData = nil;
    
    ProjectComponent *leafLength = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
    leafLength.created = [NSDate date];
    leafLength.mediaUrl = @"mediaURL";
    leafLength.observationType = [NSNumber numberWithInt:1]; //1 for float
    leafLength.required = @"YES"; //shouldn't this be a bool?
    leafLength.title = @"Leaf Length";
    leafLength.updated = [NSDate date];
    leafLength.projectComponentPossibilities = nil;
    leafLength.project = project;
    leafLength.userObservationComponentData = nil;
    
    ProjectIdentification *maple = (ProjectIdentification *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentification" inManagedObjectContext:[self managedObjectContext]];
    maple.authorCreated = [NSNumber numberWithBool:YES];
    maple.created = [NSDate date];
    maple.identificationDescription = @"A tall big tree";
    maple.title = @"Maple";
    maple.updated = [NSDate date];
    maple.project = project;
    maple.projectIdentificationComponentPossibilities = nil;
    maple.userObservationIdentifications = nil;
    
    ProjectIdentification *oak = (ProjectIdentification *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentification" inManagedObjectContext:[self managedObjectContext]];
    oak.authorCreated = [NSNumber numberWithBool:NO];
    oak.created = [NSDate date];
    oak.identificationDescription = @"This tree has awesome leafs";
    oak.title = @"Oak";
    oak.updated = [NSDate date];
    oak.project = project;
    oak.projectIdentificationComponentPossibilities = nil;
    oak.userObservationIdentifications = nil;
    
    NSError *error = nil;
    if(![[self managedObjectContext]save:&error]){
        NSLog(@"An error! %@", error);
    }
}

@end
