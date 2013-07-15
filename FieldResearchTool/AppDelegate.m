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
#import "ProjectComponentPossibility.h"
#import "ProjectIdentificationComponentPossibility.h"

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
    [self createSampleData];
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
    
    ProjectComponent *leafType = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
    leafType.created = [NSDate date];
    leafType.mediaUrl = @"mediaURL";
    leafType.observationType = [NSNumber numberWithInt:0]; //0 for enum
    leafType.required = @"YES"; //shouldn't this be a bool?
    leafType.title = @"Leaf Type";
    leafType.updated = [NSDate date];
    leafType.project = project;
    
    ProjectComponent *leafLength = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
    leafLength.created = [NSDate date];
    leafLength.mediaUrl = @"mediaURL";
    leafLength.observationType = [NSNumber numberWithInt:1]; //1 for float
    leafLength.required = @"YES"; //shouldn't this be a bool?
    leafLength.title = @"Leaf Length";
    leafLength.updated = [NSDate date];
    leafLength.project = project;
    
    ProjectIdentification *maple = (ProjectIdentification *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentification" inManagedObjectContext:[self managedObjectContext]];
    maple.authorCreated = [NSNumber numberWithBool:YES];
    maple.created = [NSDate date];
    maple.identificationDescription = @"A tall big tree";
    maple.title = @"Maple";
    maple.updated = [NSDate date];
    maple.project = project;
    
    ProjectIdentification *oak = (ProjectIdentification *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentification" inManagedObjectContext:[self managedObjectContext]];
    oak.authorCreated = [NSNumber numberWithBool:NO];
    oak.created = [NSDate date];
    oak.identificationDescription = @"This tree has awesome leafs";
    oak.title = @"Oak";
    oak.updated = [NSDate date];
    oak.project = project;
    
    ProjectComponentPossibility *roundLeaf = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    roundLeaf.boolValue = [NSNumber numberWithBool:YES];
    roundLeaf.created = [NSDate date];
    roundLeaf.enumDescription = @"Round Leaft";
    roundLeaf.mediaUrl = @"mediaURL";
    roundLeaf.rangeOperator = [NSNumber numberWithInt:0]; //0 for no range
    roundLeaf.rangeNumber1 = [NSNumber numberWithInt:0];
    roundLeaf.rangeNumber2 = [NSNumber numberWithInt:0];
    roundLeaf.updated = [NSDate date];
    roundLeaf.projectComponent = leafType;
    
    ProjectComponentPossibility *heartLeaf = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    heartLeaf.boolValue = [NSNumber numberWithBool:YES];
    heartLeaf.created = [NSDate date];
    heartLeaf.enumDescription = @"Heart Leaf";
    heartLeaf.mediaUrl = @"mediaURL";
    heartLeaf.rangeOperator = [NSNumber numberWithInt:0]; //0 for no range
    heartLeaf.rangeNumber1 = [NSNumber numberWithInt:0];
    heartLeaf.rangeNumber2 = [NSNumber numberWithInt:0];
    heartLeaf.updated = [NSDate date];
    heartLeaf.projectComponent = leafType;
    
    ProjectComponentPossibility *squareLeaf = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    squareLeaf.boolValue = [NSNumber numberWithBool:YES];
    squareLeaf.created = [NSDate date];
    squareLeaf.enumDescription = @"Square Leaf";
    squareLeaf.mediaUrl = @"mediaURL";
    squareLeaf.rangeOperator = [NSNumber numberWithInt:0]; //0 for no range
    squareLeaf.rangeNumber1 = [NSNumber numberWithInt:0];
    squareLeaf.rangeNumber2 = [NSNumber numberWithInt:0];
    squareLeaf.updated = [NSDate date];
    squareLeaf.projectComponent = leafType;
    
    ProjectComponentPossibility *equalToFiveInches = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    equalToFiveInches.boolValue = [NSNumber numberWithBool:YES];
    equalToFiveInches.created = [NSDate date];
    equalToFiveInches.enumDescription = @"Leaf length must be equal to 5 inches";
    equalToFiveInches.mediaUrl = @"mediaURL";
    equalToFiveInches.rangeOperator = [NSNumber numberWithInt:1]; //0 for equal to
    equalToFiveInches.rangeNumber1 = [NSNumber numberWithInt:5];
    equalToFiveInches.rangeNumber2 = [NSNumber numberWithInt:0];
    equalToFiveInches.updated = [NSDate date];
    equalToFiveInches.projectComponent = leafLength;
    
    ProjectIdentificationComponentPossibility *heartLeafMaple = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    heartLeafMaple.created = [NSDate date];
    heartLeafMaple.updated = [NSDate date];
    heartLeafMaple.projectComponentPossibility = heartLeaf;
    heartLeafMaple.projectIdentification = maple;
    
    ProjectIdentificationComponentPossibility *squareLeafMaple = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    squareLeafMaple.created = [NSDate date];
    squareLeafMaple.updated = [NSDate date];
    squareLeafMaple.projectComponentPossibility = squareLeaf;
    squareLeafMaple.projectIdentification = maple;
    
    ProjectIdentificationComponentPossibility *roundLeafOak = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    roundLeafOak.created = [NSDate date];
    roundLeafOak.updated = [NSDate date];
    roundLeafOak.projectComponentPossibility = roundLeaf;
    roundLeafOak.projectIdentification = oak;
    
    ProjectIdentificationComponentPossibility *heartLeafOak = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    heartLeafOak.created = [NSDate date];
    heartLeafOak.updated = [NSDate date];
    heartLeafOak.projectComponentPossibility = heartLeaf;
    heartLeafOak.projectIdentification = oak;
    
    
    NSError *error = nil;
    if(![[self managedObjectContext]save:&error]){
        NSLog(@"An error! %@", error);
    }
}

@end
