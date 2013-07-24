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
#import "RangeOperators.h"
#import "Media.h"
#import "MediaType.h"

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
    //[self readInSampleData];
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



//-(void)readInSampleData{
//    
//    NSMutableDictionary *userAttributes = [[NSMutableDictionary alloc]init];
//    [userAttributes setValue:@"jgmoeller" forKey:@"name"];
//    [userAttributes setValue:@"qwerty" forKey:@"password"]; // probably should be hashed
//    [userAttributes setValue:[NSDate date] forKey:@"created"];
//    [userAttributes setValue:[NSDate date] forKey:@"updated"];
//    //[userAttributes setValue:@"exampleURL" forKey:@"mediaUrl"]; //set media here
//    [[AppModel sharedAppModel] createNewUserWithAttributes:userAttributes];
//    
//    Media *iconMedia = (Media *)[NSEntityDescription insertNewObjectForEntityForName:@"Media" inManagedObjectContext:[self managedObjectContext]];
//    iconMedia.created = [NSDate date];
//    iconMedia.updated = [NSDate date];
//    iconMedia.mediaURL = @"";
//    iconMedia.type = [NSNumber numberWithInt:MEDIA_PHOTO];
//    
//    
//    Project *project = (Project *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
//    project.allowedInterpretations = [NSNumber numberWithInt:1];
//    project.created = [NSDate date];
//    project.media = [NSSet setWithArray:[NSArray arrayWithObject:iconMedia]];
//    project.name = @"Biocore";
//    //project.splashMediaUrl = @"splashMediaURL"; //get media here
//    project.updated = [NSDate date];
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"plantData" ofType:@"tsv"];
//    //NSString *path = @"/Users/jgmoeller/iOS Development/Field Research Platform/FieldResearchTool/FieldResearchTool/plantData.tsv";
//    //NSString *path = "/Users/nickheindl/Desktop/FieldResearchTool/FieldResearchTool/plantData.tsv"];
//    
//    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
//
//
//    NSArray *lines = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    NSString *firstLine = lines[0];
//    NSArray *wordsSeperatedByTabs = [firstLine componentsSeparatedByString:@"\t"];
//    NSMutableArray *projectComponents = [[NSMutableArray alloc]init];
//    int nonComponents = 0;
//    for(int i = 0; i < [wordsSeperatedByTabs count]; i++){
//        
//        NSString *componentRegex = @".*(\\{YES\\}|\\{NO\\})?(\\{VIDEO\\}|\\{PHOTO\\}|\\{AUDIO\\}|\\{TEXT\\}|\\{LONG_TEXT\\}|\\{NUMBER\\}|\\{BOOL\\})";
//        BOOL isComponent = [self stringMatchesRegex:wordsSeperatedByTabs[i] regex:componentRegex];
//        
//        if(isComponent){
//            NSString *leftBrace = @"{";
//            NSInteger leftBraceIndex = [wordsSeperatedByTabs[i] rangeOfString:leftBrace].location;
//            NSString *withoutParams = [wordsSeperatedByTabs[i] substringToIndex:leftBraceIndex];
//            NSString *params = [wordsSeperatedByTabs[i] substringFromIndex:leftBraceIndex];
//            
//            NSString *dash = @"-";
//            NSInteger dashIndex = [withoutParams rangeOfString:dash].location;
//            
//            NSString *projectComponentName = withoutParams;
//            if(dashIndex != NSNotFound){
//                projectComponentName = [withoutParams substringToIndex:dashIndex];
//            }
//            NSLog(@"Component: %@ Params: %@", projectComponentName, params);
//            
//            NSString *requiredRegex = @"(\\{YES\\}.*)";
//            BOOL isRequired = [self stringMatchesRegex:params regex:requiredRegex];
//            
//            //figure out the type
//            ProjectComponentDataType type;
//            NSString *videoRegex = @"(.*\\{VIDEO\\})";
//            NSString *audioRegex = @"(.*\\{AUDIO\\})";
//            NSString *photoRegex = @"(.*\\{PHOTO\\})";
//            NSString *textRegex = @"(.*\\{TEXT\\})";
//            NSString *longTextRegex = @"(.*\\{LONG_TEXT\\})";
//            NSString *numberRegex = @"(.*\\{NUMBER\\})";
//            NSString *boolRegex = @"(.*\\{BOOL\\})";
//            if([self stringMatchesRegex:params regex:videoRegex]){
//                type = VIDEO;
//            }
//            else if([self stringMatchesRegex:params regex:audioRegex]){
//                type = AUDIO;
//            }
//            else if([self stringMatchesRegex:params regex:photoRegex]){
//                type = PHOTO;
//            }
//            else if([self stringMatchesRegex:params regex:textRegex]){
//                type = TEXT;
//            }
//            else if([self stringMatchesRegex:params regex:longTextRegex]){
//                type = LONG_TEXT;
//            }
//            else if([self stringMatchesRegex:params regex:numberRegex]){
//                type = NUMBER;
//            }
//            else if([self stringMatchesRegex:params regex:boolRegex]){
//                type = BOOLEAN;
//            }
//            else{
//                NSLog(@"Error in setting type for Project Component");
//                type = NUMBER;
//            }
//            
//            //create the project component
//            ProjectComponent *projectComponent = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
//            projectComponent.created = [NSDate date];
//            //projectComponent.mediaUrl = @"mediaURL"; //get media here
//            projectComponent.observationType = [NSNumber numberWithInt:type];
//            projectComponent.required = [NSNumber numberWithBool:isRequired];
//            projectComponent.title = projectComponentName;
//            projectComponent.updated = [NSDate date];
//            projectComponent.project = project;
//            projectComponent.wasObserved = [NSNumber numberWithBool:NO];
//            
//            [projectComponents addObject:projectComponent];
//
//            
//            //create the project component possibilities
//            if (dashIndex != NSNotFound) {
//                NSString *stringProjectComponentPossibilities = [withoutParams substringFromIndex:dashIndex+2];
//                NSArray *projectComponentPossibilities = [stringProjectComponentPossibilities componentsSeparatedByString:@", "];
//                for (int j = 0; j < [projectComponentPossibilities count]; j++) {
//                    NSString *stringProjectComponentPossibility = projectComponentPossibilities[j];
//                    
//                    ProjectComponentPossibility *projectComponentPossibility = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
//                    projectComponentPossibility.created = [NSDate date];
//                    projectComponentPossibility.updated = [NSDate date];
//                    projectComponentPossibility.projectComponent = projectComponent;
//                    //projectComponentPossibility.mediaUrl = @"mediaURL"; //get media here
//                    if([stringProjectComponentPossibility isEqualToString:@"yes"]){
//                        projectComponentPossibility.boolValue = [NSNumber numberWithBool:YES];
//                        NSLog(@"Possibility: %@ Type: BOOL", stringProjectComponentPossibility);
//                    }
//                    else if([stringProjectComponentPossibility isEqualToString:@"no"]){
//                        projectComponentPossibility.boolValue = [NSNumber numberWithBool:NO];
//                        NSLog(@"Possibility: %@ Type: BOOL", stringProjectComponentPossibility);
//                    }
//                    else if([stringProjectComponentPossibility rangeOfString:@"<"].location != NSNotFound && [stringProjectComponentPossibility rangeOfString:@">"].location == NSNotFound){
//                        stringProjectComponentPossibility = [self getRidOfSingleAndDoubleQuotes:stringProjectComponentPossibility];
//                        NSInteger lessThanLocation = [stringProjectComponentPossibility rangeOfString:@"<"].location;
//                        NSString *number = [stringProjectComponentPossibility substringFromIndex:lessThanLocation+1];
//                        projectComponentPossibility.rangeOperator = [NSNumber numberWithInt:LESS_THAN];
//                        projectComponentPossibility.rangeNumber1 = [NSNumber numberWithDouble:[number doubleValue]];
//                        projectComponentPossibility.rangeNumber2 = [NSNumber numberWithDouble:[number doubleValue]];
//                        NSLog(@"Possibility: <%@ Type: LESS THAN RANGE", number);
//                    }
//                    else if([stringProjectComponentPossibility rangeOfString:@">"].location != NSNotFound && [stringProjectComponentPossibility rangeOfString:@"<"].location == NSNotFound){
//                        stringProjectComponentPossibility = [self getRidOfSingleAndDoubleQuotes:stringProjectComponentPossibility];
//                        NSInteger greaterThanLocation = [stringProjectComponentPossibility rangeOfString:@">"].location;
//                        NSString *number = [stringProjectComponentPossibility substringFromIndex:greaterThanLocation+1];
//                        projectComponentPossibility.rangeOperator = [NSNumber numberWithInt:GREATER_THAN];
//                        projectComponentPossibility.rangeNumber1 = [NSNumber numberWithDouble:[number doubleValue]];
//                        projectComponentPossibility.rangeNumber2 = [NSNumber numberWithDouble:[number doubleValue]];
//                        NSLog(@"Possibility: >%@ Type: GREATER THAN RANGE", number);
//                    }
//                    else if([stringProjectComponentPossibility rangeOfString:@">"].location != NSNotFound && [stringProjectComponentPossibility rangeOfString:@"<"].location != NSNotFound){
//                        //implement a range of BETWEEN
//                        NSInteger lessThanIndex = [stringProjectComponentPossibility rangeOfString:@"<"].location;
//                        NSString *lessThanPart = [stringProjectComponentPossibility substringFromIndex:lessThanIndex];
//                        NSString *greaterThanPart = [stringProjectComponentPossibility substringToIndex:lessThanIndex];
//                        lessThanPart = [self getRidOfSingleAndDoubleQuotes:lessThanPart];
//                        greaterThanPart = [self getRidOfSingleAndDoubleQuotes:greaterThanPart];
//                        
//                        NSInteger lessThanLocation = [lessThanPart rangeOfString:@"<"].location;
//                        NSString *lessThanNumber = [lessThanPart substringFromIndex:lessThanLocation+1];
//                        
//                        NSInteger greaterThanLocation = [greaterThanPart rangeOfString:@">"].location;
//                        NSString *greaterThanNumber = [greaterThanPart substringFromIndex:greaterThanLocation+1];
//                        
//                        projectComponentPossibility.rangeOperator = [NSNumber numberWithInt:BETWEEN];
//                        projectComponentPossibility.rangeNumber1 = [NSNumber numberWithDouble:[lessThanNumber doubleValue]];
//                        projectComponentPossibility.rangeNumber2 = [NSNumber numberWithDouble:[greaterThanNumber doubleValue]];
//                        NSLog(@"Possibility: >%@ <%@ Type: BETWEEN RANGE", greaterThanNumber, lessThanNumber);
//                    }
//                    else if([self isStringNumeric:stringProjectComponentPossibility]){
//                        stringProjectComponentPossibility = [self getRidOfSingleAndDoubleQuotes:stringProjectComponentPossibility];
//                        projectComponentPossibility.rangeOperator = [NSNumber numberWithInt:EQUAL];
//                        projectComponentPossibility.rangeNumber1 = [NSNumber numberWithDouble:[stringProjectComponentPossibility doubleValue]];
//                        projectComponentPossibility.rangeNumber2 = [NSNumber numberWithDouble:[stringProjectComponentPossibility doubleValue]];
//                        NSLog(@"Possibility: %@ Type: EQUAL TO RANGE", stringProjectComponentPossibility);
//                    }
//                    else{
//                        projectComponentPossibility.enumDescription = stringProjectComponentPossibility;
//                        NSLog(@"Possibility: %@ Type: ENUM", stringProjectComponentPossibility);
//                    }
//                }
//            }
//        }
//        else{
//            nonComponents++;
//        }
//    }
//    
//    
//    
//    //read in the actual data
//    for(int i = 1; i < [lines count]; i++){
//        NSArray *components = [lines[i] componentsSeparatedByString:@"\t"];
//        
//        ProjectIdentification *identification = (ProjectIdentification *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentification" inManagedObjectContext:[self managedObjectContext]];
//        identification.authorCreated = [NSNumber numberWithBool:YES];
//        identification.created = [NSDate date];
//        identification.identificationDescription = components[3];
//        identification.title = components[2];
//        identification.updated = [NSDate date];
//        identification.project = project;
//        //NSLog(@"Identification: %@ Description: %@", identification.title, identification.identificationDescription);
//        
//        //4 is hardcoded here
//        int numOfNonComponents = nonComponents;
//        for (int j = 0; j < [components count]; j++) {
//            NSString *commaListOfComponentPossibilities = components[j];
//            if(j >= numOfNonComponents){
//                ProjectComponent *associatedProjectComponent = [projectComponents objectAtIndex:j-numOfNonComponents];
//                
//                if([commaListOfComponentPossibilities isEqualToString:@""]){
//                    //create ALL possibilities
//                    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//                    [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
//                    NSArray *allProjectComponentPossibilities = [self fetchAllEntities:@"ProjectComponentPossibility" withAttributes:attributes];
//                    if(allProjectComponentPossibilities){
//                        for (int k = 0; k < [allProjectComponentPossibilities count]; k++) {
//                            ProjectComponentPossibility *possibility = allProjectComponentPossibilities[k];
//                            ProjectIdentificationComponentPossibility *projectIdentificationComponentPossibility = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
//                            projectIdentificationComponentPossibility.created = [NSDate date];
//                            projectIdentificationComponentPossibility.updated = [NSDate date];
//                            projectIdentificationComponentPossibility.projectComponentPossibility = possibility;
//                            projectIdentificationComponentPossibility.projectIdentification = identification;
//                        }
//                    }
//                    //NSLog(@"Create all possibilities for %@. Identification: %@", associatedProjectComponent.title, identification.title);
//                    continue;
//                }
//                
//                
//                
//                NSArray *componentPossibilities = [commaListOfComponentPossibilities componentsSeparatedByString:@", "];
//                ProjectComponentPossibility *possibility;
//                for(int k = 0; k < [componentPossibilities count]; k++){
//                    NSString *componentPossibility = componentPossibilities[k];
//                    
//                    if([self isStringNumeric:componentPossibility]){
//                        //handle numbers here
//                        componentPossibility = [self getRidOfSingleAndDoubleQuotes:componentPossibility];
//                        
//                        NSInteger lessThanIndex = [componentPossibility rangeOfString:@"<"].location;
//                        NSInteger greaterThanIndex = [componentPossibility rangeOfString:@">"].location;
//                        if(lessThanIndex != NSNotFound && greaterThanIndex == NSNotFound){
//                            //handle less than
//                            NSString *noSign = [componentPossibility substringFromIndex:lessThanIndex+1];
//                            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//                            [f setNumberStyle:NSNumberFormatterDecimalStyle];
//                            NSNumber *number = [f numberFromString:noSign];
//                            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//                            [attributes setObject:[NSNumber numberWithInt:LESS_THAN] forKey:@"rangeOperator"];
//                            [attributes setObject:number forKey:@"rangeNumber1"];
//                            [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
//                            possibility = [self fetchEntities:@"ProjectComponentPossibility" withAttributes:attributes];
//                        }
//                        else if(greaterThanIndex != NSNotFound && lessThanIndex == NSNotFound){
//                            //handle greater than
//                            NSString *noSign = [componentPossibility substringFromIndex:greaterThanIndex+1];
//                            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//                            [f setNumberStyle:NSNumberFormatterDecimalStyle];
//                            NSNumber *number = [f numberFromString:noSign];
//                            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//                            [attributes setObject:[NSNumber numberWithInt:GREATER_THAN] forKey:@"rangeOperator"];
//                            [attributes setObject:number forKey:@"rangeNumber1"];
//                            [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
//                            possibility = [self fetchEntities:@"ProjectComponentPossibility" withAttributes:attributes];
//                        }
//                        else if(greaterThanIndex != NSNotFound && lessThanIndex != NSNotFound){
//                            //handle between
//                            NSInteger lessThanIndex = [componentPossibility rangeOfString:@"<"].location;
//                            NSString *lessThanPart = [componentPossibility substringFromIndex:lessThanIndex];
//                            NSString *greaterThanPart = [componentPossibility substringToIndex:lessThanIndex];
//                            NSInteger lessThanLocation = [lessThanPart rangeOfString:@"<"].location;
//                            NSString *lessThanNumber = [lessThanPart substringFromIndex:lessThanLocation+1];
//                            NSInteger greaterThanLocation = [greaterThanPart rangeOfString:@">"].location;
//                            NSString *greaterThanNumber = [greaterThanPart substringFromIndex:greaterThanLocation+1];
//                            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//                            [f setNumberStyle:NSNumberFormatterDecimalStyle];
//                            NSNumber *lessNumber = [f numberFromString:lessThanNumber];
//                            NSNumber *greaterNumber = [f numberFromString:greaterThanNumber];
//                            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//                            [attributes setObject:[NSNumber numberWithInt:BETWEEN] forKey:@"rangeOperator"];
//                            [attributes setObject:lessNumber forKey:@"rangeNumber1"];
//                            [attributes setObject:greaterNumber forKey:@"rangeNumber2"];
//                            [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
//                            possibility = [self fetchEntities:@"ProjectComponentPossibility" withAttributes:attributes];
//                        }
//                        else{
//                            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//                            [f setNumberStyle:NSNumberFormatterDecimalStyle];
//                            NSNumber *number = [f numberFromString:componentPossibility];
//                            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//                            [attributes setObject:number forKey:@"rangeNumber1"];
//                            [attributes setObject:[NSNumber numberWithInt:EQUAL] forKey:@"rangeOperator"];
//                            [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
//                            possibility = [self fetchEntities:@"ProjectComponentPossibility" withAttributes:attributes];
//                        }
//                        
//                    }
//                    else if([self isStringABoolean:componentPossibility]){
//                        NSString *yesRegex = @"\\s*(YES|yes)\\s*";
//                        if([self stringMatchesRegex:componentPossibility regex:yesRegex]){
//                            componentPossibility = @"YES";
//                            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//                            [attributes setObject:[NSNumber numberWithBool:YES] forKey:@"boolValue"];
//                            [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
//                            possibility = [self fetchEntities:@"ProjectComponentPossibility" withAttributes:attributes];
//                        }
//                        else{
//                            componentPossibility = @"NO";
//                            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//                            [attributes setObject:[NSNumber numberWithBool:NO] forKey:@"boolValue"];
//                            [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
//                            possibility = [self fetchEntities:@"ProjectComponentPossibility" withAttributes:attributes];
//                        }
//                    }
//                    else{
//                        //handle enums
//                        NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//                        [attributes setObject:componentPossibility forKey:@"enumDescription"];
//                        [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
//                        possibility = [self fetchEntities:@"ProjectComponentPossibility" withAttributes:attributes];
//                    }
//                    
//                    
//                    //create the object
//                    if(possibility != nil){
//                        ProjectIdentificationComponentPossibility *projectIdentificationComponentPossibility = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
//                        projectIdentificationComponentPossibility.created = [NSDate date];
//                        projectIdentificationComponentPossibility.updated = [NSDate date];
//                        projectIdentificationComponentPossibility.projectComponentPossibility = possibility;
//                        projectIdentificationComponentPossibility.projectIdentification = identification;
//                        //NSLog(@"Component Possibility was found. Associated Project Component: %@ Associated Project ID: %@", associatedProjectComponent.title, identification.title);
//                    }
//                    else if([self isStringNumeric:componentPossibility]){
//                        //create a new project component possibility because we didnt find any specified ranges
//                        
//                        //in the future, it may be useful to add a check here to see if the data has a '<' or a '>'.
//                        //then we could create a new range. currently, it always assumes it to be equal
//                        
//                        ProjectComponentPossibility *projectComponentPossibility = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
//                        projectComponentPossibility.created = [NSDate date];
//                        projectComponentPossibility.updated = [NSDate date];
//                        projectComponentPossibility.projectComponent = associatedProjectComponent;
//                        //projectComponentPossibility.mediaUrl = @"mediaURL"; //get media here
//                        
//                        projectComponentPossibility.rangeOperator = [NSNumber numberWithInt:EQUAL];
//                        projectComponentPossibility.rangeNumber1 = [NSNumber numberWithDouble:[componentPossibility doubleValue]];
//                        projectComponentPossibility.rangeNumber2 = [NSNumber numberWithDouble:[componentPossibility doubleValue]];
//                        
//                        ProjectIdentificationComponentPossibility *projectIdentificationComponentPossibility = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
//                        projectIdentificationComponentPossibility.created = [NSDate date];
//                        projectIdentificationComponentPossibility.updated = [NSDate date];
//                        projectIdentificationComponentPossibility.projectComponentPossibility = projectComponentPossibility;
//                        projectIdentificationComponentPossibility.projectIdentification = identification;
//                        //NSLog(@"Created New Component Possibility. Associated Project Component: %@ Associated Project ID: %@", associatedProjectComponent.title, identification.title);
//                    }
//                    else{
//                        //these objects will not be created
//                        NSLog(@"Component Possibility is NOT numeric and was NOT found. Associated Project Component: %@ Associated Project ID: %@", associatedProjectComponent.title, identification.title);
//                    }
//                    
//                }
//            }
//            
//        }
//    }
//    
//    [[AppModel sharedAppModel] save];
//    
//}

-(BOOL)isStringNumeric:(NSString *)string{
    
    NSString *regexNumber = @"\\s*(<|>)?[-+]?[0-9]*\\.?[0-9]+(\"?|\'?)\\s*";
    
    NSPredicate *testRegexInt = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexNumber];
    BOOL isNumber = [testRegexInt evaluateWithObject: string];
    
    return isNumber;
}

-(BOOL)isStringABoolean:(NSString *)string{
    NSString *regexBool = @"\\s*(YES|NO|yes|no)\\s*";
    
    NSPredicate *testRegexInt = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexBool];
    BOOL isBool = [testRegexInt evaluateWithObject: string];
    
    return isBool;
}

-(BOOL)stringMatchesRegex:(NSString *)string regex:(NSString *)regex{
    NSPredicate *testRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return[testRegex evaluateWithObject: string];
}

-(ProjectComponentPossibility *)fetchEntities:(NSString *)entityName withAttributes:(NSDictionary *)attributeNamesAndValues{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSMutableString *predicateString = [NSMutableString stringWithString:@""];
    if(attributeNamesAndValues && [attributeNamesAndValues count] > 0){
        //create the predicate string
        for (NSString *key in attributeNamesAndValues) {
            //first check to make sure the object we're adding to the predicate string isnt nil
            if([attributeNamesAndValues objectForKey:key]){
                
                id value = [attributeNamesAndValues objectForKey:key];
                BOOL isNumeric = [value isKindOfClass:[NSNumber class]];
                if(isNumeric){
                    if([predicateString isEqualToString:@""]){
                        [predicateString appendFormat:@"%@ == %@", key, [attributeNamesAndValues objectForKey:key]];
                    }
                    else{
                        [predicateString appendFormat:@" && %@ == %@", key, [attributeNamesAndValues objectForKey:key]];
                    }
                }
                else{
                    if([predicateString isEqualToString:@""]){
                        [predicateString appendFormat:@"%@ == '%@'", key, [attributeNamesAndValues objectForKey:key]];
                    }
                    else{
                        [predicateString appendFormat:@" && %@ == '%@'", key, [attributeNamesAndValues objectForKey:key]];
                    }
                }
            }
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        [fetchRequest setPredicate:predicate];
    }
    
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching entities with attributes. Handler not called. %@", error);
        return nil;
    }
    
    if([fetchedObjects count] > 1){
        NSLog(@"ERROR!!! More than one possibility was returned. %@", predicateString);
    }
    else if([fetchedObjects count] == 0){
        //NSLog(@"ERROR!!! No possibility was returned");
        return nil;
    }
    
    return fetchedObjects[0];
    
}

-(NSArray *)fetchAllEntities:(NSString *)entityName withAttributes:(NSDictionary *)attributeNamesAndValues{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSMutableString *predicateString = [NSMutableString stringWithString:@""];
    if(attributeNamesAndValues && [attributeNamesAndValues count] > 0){
        //create the predicate string
        for (NSString *key in attributeNamesAndValues) {
            //first check to make sure the object we're adding to the predicate string isnt nil
            if([attributeNamesAndValues objectForKey:key]){
                
                id value = [attributeNamesAndValues objectForKey:key];
                BOOL isNumeric = [value isKindOfClass:[NSNumber class]];
                if(isNumeric){
                    if([predicateString isEqualToString:@""]){
                        [predicateString appendFormat:@"%@ == %@", key, [attributeNamesAndValues objectForKey:key]];
                    }
                    else{
                        [predicateString appendFormat:@" && %@ == %@", key, [attributeNamesAndValues objectForKey:key]];
                    }
                }
                else{
                    if([predicateString isEqualToString:@""]){
                        [predicateString appendFormat:@"%@ == '%@'", key, [attributeNamesAndValues objectForKey:key]];
                    }
                    else{
                        [predicateString appendFormat:@" && %@ == '%@'", key, [attributeNamesAndValues objectForKey:key]];
                    }
                }
            }
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        [fetchRequest setPredicate:predicate];
    }
    
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching entities with attributes. Handler not called. %@", error);
        return nil;
    }

    return fetchedObjects;
    
}

-(NSString *)getRidOfSingleAndDoubleQuotes:(NSString *)string{
    NSString *returnString = string;
    NSInteger doubleQuoteIndex = [string rangeOfString:@"\""].location;
    if(doubleQuoteIndex != NSNotFound){
        returnString = [string substringToIndex:doubleQuoteIndex];
    }
    NSInteger singleQuoteIndex = [string rangeOfString:@"\'"].location;
    if(singleQuoteIndex != NSNotFound){
        returnString = [string substringToIndex:singleQuoteIndex];
    }
    return returnString;
}


@end
