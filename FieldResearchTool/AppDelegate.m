//
//  AppDelegate.m
//  FieldResearchTool
//
//  Created by Phil Dougherty on 7/11/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "AppDelegate.h"
#import "AppModel.h"
#import "RootViewController.h"
#import "IncrementalStore.h"
#import "Project.h"
#import "ProjectComponent.h"
#import "ProjectIdentification.h"
#import "ProjectComponentPossibility.h"
#import "ProjectIdentificationComponentPossibility.h"
#import "ProjectComponentDataType.h"
#import "RangeOperators.h"

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
    //keep this commented out unless you want to regenerate sample data. otherwise it will continually
    //add sample data
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
    //PROJECTS
    Project *project = (Project *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
    project.allowedInterpretations = [NSNumber numberWithInt:1];
    project.created = [NSDate date];
    project.iconMediaUrl = @"iconMediaURL";
    project.name = @"Biocore";
    project.splashMediaUrl = @"splashMediaURL";
    project.updated = [NSDate date];
    
    //PROJECT IDENTIFICATIONS
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
    
    //PROJECT COMPONENTS
    ProjectComponent *leafType = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
    leafType.created = [NSDate date];
    leafType.mediaUrl = @"mediaURL";
    leafType.observationType = [NSNumber numberWithInt:VISUAL];
    leafType.required = [NSNumber numberWithBool:YES];
    leafType.title = @"Leaf Type";
    leafType.updated = [NSDate date];
    leafType.project = project;
    
    ProjectComponent *leafLength = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
    leafLength.created = [NSDate date];
    leafLength.mediaUrl = @"mediaURL";
    leafLength.observationType = [NSNumber numberWithInt:NUMBER];
    leafLength.required = [NSNumber numberWithBool:YES];
    leafLength.title = @"Leaf Length";
    leafLength.updated = [NSDate date];
    leafLength.project = project;
    
    ProjectComponent *isLeafGreen = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
    isLeafGreen.created = [NSDate date];
    isLeafGreen.mediaUrl = @"mediaURL";
    isLeafGreen.observationType = [NSNumber numberWithInt:BOOLEAN];
    isLeafGreen.required = [NSNumber numberWithBool:YES];
    isLeafGreen.title = @"Green Leaf";
    isLeafGreen.updated = [NSDate date];
    isLeafGreen.project = project;
    
    ProjectComponent *stemDescription = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
    stemDescription.created = [NSDate date];
    stemDescription.mediaUrl = @"mediaURL";
    stemDescription.observationType = [NSNumber numberWithInt:LONG_TEXT];
    stemDescription.required = [NSNumber numberWithBool:YES];
    stemDescription.title = @"Stem Description";
    stemDescription.updated = [NSDate date];
    stemDescription.project = project;
    
    ProjectComponent *leafDescription = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
    leafDescription.created = [NSDate date];
    leafDescription.mediaUrl = @"mediaURL";
    leafDescription.observationType = [NSNumber numberWithInt:TEXT];
    leafDescription.required = [NSNumber numberWithBool:YES];
    leafDescription.title = @"Leaf Description";
    leafDescription.updated = [NSDate date];
    leafDescription.project = project;
    
    ProjectComponent *plantSound = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
    plantSound.created = [NSDate date];
    plantSound.mediaUrl = @"mediaURL";
    plantSound.observationType = [NSNumber numberWithInt:AUDIO];
    plantSound.required = [NSNumber numberWithBool:YES];
    plantSound.title = @"Plant Mating Call";
    plantSound.updated = [NSDate date];
    plantSound.project = project;
        
    //PROJECT COMPONENT POSSIBILITIES
    ProjectComponentPossibility *roundLeaf = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    roundLeaf.boolValue = [NSNumber numberWithBool:YES];
    roundLeaf.created = [NSDate date];
    roundLeaf.enumDescription = @"Round Leaf";
    roundLeaf.mediaUrl = @"mediaURL";
    roundLeaf.rangeOperator = [NSNumber numberWithInt:NOT_BETWEEN];
    roundLeaf.rangeNumber1 = [NSNumber numberWithInt:0];
    roundLeaf.rangeNumber2 = [NSNumber numberWithInt:0];
    roundLeaf.updated = [NSDate date];
    roundLeaf.projectComponent = leafType;
    
    ProjectComponentPossibility *heartLeaf = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    heartLeaf.boolValue = [NSNumber numberWithBool:YES];
    heartLeaf.created = [NSDate date];
    heartLeaf.enumDescription = @"Heart Leaf";
    heartLeaf.mediaUrl = @"mediaURL";
    heartLeaf.rangeOperator = [NSNumber numberWithInt:NOT_BETWEEN];
    heartLeaf.rangeNumber1 = [NSNumber numberWithInt:0];
    heartLeaf.rangeNumber2 = [NSNumber numberWithInt:0];
    heartLeaf.updated = [NSDate date];
    heartLeaf.projectComponent = leafType;
    
    ProjectComponentPossibility *squareLeaf = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    squareLeaf.boolValue = [NSNumber numberWithBool:YES];
    squareLeaf.created = [NSDate date];
    squareLeaf.enumDescription = @"Square Leaf";
    squareLeaf.mediaUrl = @"mediaURL";
    squareLeaf.rangeOperator = [NSNumber numberWithInt:NOT_BETWEEN];
    squareLeaf.rangeNumber1 = [NSNumber numberWithInt:0];
    squareLeaf.rangeNumber2 = [NSNumber numberWithInt:0];
    squareLeaf.updated = [NSDate date];
    squareLeaf.projectComponent = leafType;
    
    ProjectComponentPossibility *equalToFiveInches = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    equalToFiveInches.boolValue = [NSNumber numberWithBool:YES];
    equalToFiveInches.created = [NSDate date];
    equalToFiveInches.enumDescription = @"Leaf length must be equal to 5 inches";
    equalToFiveInches.mediaUrl = @"mediaURL";
    equalToFiveInches.rangeOperator = [NSNumber numberWithInt:EQUAL];
    equalToFiveInches.rangeNumber1 = [NSNumber numberWithInt:5];
    equalToFiveInches.rangeNumber2 = [NSNumber numberWithInt:5];
    equalToFiveInches.updated = [NSDate date];
    equalToFiveInches.projectComponent = leafLength;
    
    ProjectComponentPossibility *leafIsGreen = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    leafIsGreen.boolValue = [NSNumber numberWithBool:YES];
    leafIsGreen.created = [NSDate date];
    leafIsGreen.enumDescription = @"N/A";
    leafIsGreen.mediaUrl = @"mediaURL";
    leafIsGreen.rangeOperator = [NSNumber numberWithInt:NOT_BETWEEN];
    leafIsGreen.rangeNumber1 = [NSNumber numberWithInt:0];
    leafIsGreen.rangeNumber2 = [NSNumber numberWithInt:0];
    leafIsGreen.updated = [NSDate date];
    leafIsGreen.projectComponent = isLeafGreen;
    
    ProjectComponentPossibility *leafIsNotGreen = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    leafIsNotGreen.boolValue = [NSNumber numberWithBool:NO];
    leafIsNotGreen.created = [NSDate date];
    leafIsNotGreen.enumDescription = @"N/A";
    leafIsNotGreen.mediaUrl = @"mediaURL";
    leafIsNotGreen.rangeOperator = [NSNumber numberWithInt:NOT_BETWEEN];
    leafIsNotGreen.rangeNumber1 = [NSNumber numberWithInt:0];
    leafIsNotGreen.rangeNumber2 = [NSNumber numberWithInt:0];
    leafIsNotGreen.updated = [NSDate date];
    leafIsNotGreen.projectComponent = isLeafGreen;
    
    //PROJECT IDENTIFICATION COMPONENT POSSIBILITIES
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
    
    ProjectIdentificationComponentPossibility *greenLeafOak = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    greenLeafOak.created = [NSDate date];
    greenLeafOak.updated = [NSDate date];
    greenLeafOak.projectComponentPossibility = leafIsGreen;
    greenLeafOak.projectIdentification = oak;
    
    ProjectIdentificationComponentPossibility *notGreenLeafMaple = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
    notGreenLeafMaple.created = [NSDate date];
    notGreenLeafMaple.updated = [NSDate date];
    notGreenLeafMaple.projectComponentPossibility = leafIsNotGreen;
    notGreenLeafMaple.projectIdentification = maple;
    
    
    [[AppModel sharedAppModel]save];
}

@end
