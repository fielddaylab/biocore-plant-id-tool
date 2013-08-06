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
#import "ObservationDataType.h"
#import "ObservationJudgementType.h"
#import "ProjectIdentificationDiscussion.h"

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
-(void)readInSampleData{
    
    Project *project = (Project *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
    project.allowedInterpretations = [NSNumber numberWithInt:1];
    project.created = [NSDate date];
    project.updated = [NSDate date];
    project.name = @"Biocore";
    //add media reference here
    
    [AppModel sharedAppModel].currentProject = project;
    
    User *user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
    user.name = @"jgmoeller";
    user.password = @"qwerty";
    user.created = [NSDate date];
    user.updated = [NSDate date];
    user.project = project;
    
    [AppModel sharedAppModel].currentUser = user;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"examplePlantData" ofType:@"tsv"];
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    NSArray *lines = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *firstLine = lines[0];
    NSArray *wordsSeperatedByTabs = [firstLine componentsSeparatedByString:@"\t"];
    NSMutableArray *projectComponents = [[NSMutableArray alloc]init];
    int nonComponents = 0;
    for(int i = 0; i < [wordsSeperatedByTabs count]; i++){
        NSString *componentRegex = @".*(\\{YES\\}|\\{NO\\})?(\\{DATA_VIDEO\\}|\\{DATA_PHOTO\\}|\\{DATA_AUDIO\\}|\\{DATA_TEXT\\}|\\{DATA_LONG_TEXT\\}|\\{DATA_NUMBER\\}|\\{DATA_BOOL\\}|\\{DATA_ENUM\\})(\\{JUDGEMENT_TEXT\\}|\\{JUDGEMENT_LONG_TEXT\\}|\\{JUDGEMENT_NUMBER\\}|\\{JUDGEMENT_BOOL\\}|\\{JUDGEMENT_ENUM\\})(\\{FILTER\\}|\\{DONT_FILTER\\})";
        BOOL isComponent = [self stringMatchesRegex:wordsSeperatedByTabs[i] regex:componentRegex];
        if(isComponent){
            NSString *leftBrace = @"{";
            NSInteger leftBraceIndex = [wordsSeperatedByTabs[i] rangeOfString:leftBrace].location;
            NSString *withoutParams = [wordsSeperatedByTabs[i] substringToIndex:leftBraceIndex];
            NSString *params = [wordsSeperatedByTabs[i] substringFromIndex:leftBraceIndex];
            
            NSString *dash = @"-";
            NSInteger dashIndex = [withoutParams rangeOfString:dash].location;
            
            NSString *projectComponentName = withoutParams;
            if(dashIndex != NSNotFound){
                projectComponentName = [withoutParams substringToIndex:dashIndex];
            }
            
            NSString *requiredRegex = @"(\\{YES\\}.*)";
            BOOL isRequired = [self stringMatchesRegex:params regex:requiredRegex];
            
            //figure out the observation type
            ObservationDataType dataType;
            NSString *videoRegex = @"(.*\\{DATA_VIDEO\\}.*)";
            NSString *audioRegex = @"(.*\\{DATA_AUDIO\\}.*)";
            NSString *photoRegex = @"(.*\\{DATA_PHOTO\\}.*)";
            NSString *textRegex = @"(.*\\{DATA_TEXT\\}.*)";
            NSString *longTextRegex = @"(.*\\{DATA_LONG_TEXT\\}.*)";
            NSString *numberRegex = @"(.*\\{DATA_NUMBER\\}.*)";
            NSString *boolRegex = @"(.*\\{DATA_BOOL\\}.*)";
            NSString *enumRegex = @"(.*\\{DATA_ENUM\\}.*)";
            if([self stringMatchesRegex:params regex:videoRegex]){
                dataType = DATA_VIDEO;
            }
            else if([self stringMatchesRegex:params regex:audioRegex]){
                dataType = DATA_AUDIO;
            }
            else if([self stringMatchesRegex:params regex:photoRegex]){
                dataType = DATA_PHOTO;
            }
            else if([self stringMatchesRegex:params regex:textRegex]){
                dataType = DATA_TEXT;
            }
            else if([self stringMatchesRegex:params regex:longTextRegex]){
                dataType = DATA_LONG_TEXT;
            }
            else if([self stringMatchesRegex:params regex:numberRegex]){
                dataType = DATA_NUMBER;
            }
            else if([self stringMatchesRegex:params regex:boolRegex]){
                dataType = DATA_BOOLEAN;
            }
            else if([self stringMatchesRegex:params regex:enumRegex]){
                dataType = DATA_ENUMERATOR;
            }
            else{
                NSLog(@"Error in setting type for Project Component");
                dataType = DATA_NUMBER;
            }
            
            //figure out the judgement type
            ObservationJudgementType judgementType;
            videoRegex = @"(.*\\{JUDGEMENT_VIDEO\\}.*)";
            audioRegex = @"(.*\\{JUDGEMENT_AUDIO\\}.*)";
            photoRegex = @"(.*\\{JUDGEMENT_PHOTO\\}.*)";
            textRegex = @"(.*\\{JUDGEMENT_TEXT\\}.*)";
            longTextRegex = @"(.*\\{JUDGEMENT_LONG_TEXT\\}.*)";
            numberRegex = @"(.*\\{JUDGEMENT_NUMBER\\}.*)";
            boolRegex = @"(.*\\{JUDGEMENT_BOOL\\}.*)";
            enumRegex = @"(.*\\{JUDGEMENT_ENUM\\}.*)";
            if([self stringMatchesRegex:params regex:textRegex]){
                judgementType = JUDGEMENT_TEXT;
            }
            else if([self stringMatchesRegex:params regex:longTextRegex]){
                judgementType = JUDGEMENT_LONG_TEXT;
            }
            else if([self stringMatchesRegex:params regex:numberRegex]){
                judgementType = JUDGEMENT_NUMBER;
            }
            else if([self stringMatchesRegex:params regex:boolRegex]){
                judgementType = JUDGEMENT_BOOLEAN;
            }
            else if([self stringMatchesRegex:params regex:enumRegex]){
                judgementType = JUDGEMENT_ENUMERATOR;
            }
            else{
                NSLog(@"Error in setting type for Project Component");
                judgementType = JUDGEMENT_NUMBER;
            }
            
            BOOL filter;
            if(judgementType == JUDGEMENT_BOOLEAN || judgementType == JUDGEMENT_ENUMERATOR || judgementType == JUDGEMENT_NUMBER){
                NSString *filterRegex = @".*\\{FILTER\\}.*";
                NSString *dontFilterRegex = @".*\\DONT_FILTER\\}.*";
                if([self stringMatchesRegex:params regex:filterRegex]){
                    filter = YES;
                }
                else if ([self stringMatchesRegex:params regex:dontFilterRegex]){
                    filter = NO;
                }
                else{
                    NSLog(@"Something went wrong when trying to set filter for component");
                    filter = NO;
                }
            }
            else{
                filter = NO;
            }

            
            
            ProjectComponent *projectComponent = (ProjectComponent *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponent" inManagedObjectContext:[self managedObjectContext]];
            projectComponent.created = [NSDate date];
            projectComponent.updated = [NSDate date];
            projectComponent.observationDataType = [NSNumber numberWithInt:dataType];
            projectComponent.observationJudgementType = [NSNumber numberWithInt:judgementType];
            projectComponent.required = [NSNumber numberWithBool:isRequired];
            projectComponent.title = projectComponentName;
            projectComponent.project = project;
            projectComponent.filter = [NSNumber numberWithBool:filter];

            ///////////////NICK MADE
            //Make the filename for the media
            NSString *projectComponentTitleString = projectComponentName;
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
            projectComponentTitleString = [[projectComponentTitleString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
            projectComponentTitleString = [projectComponentTitleString stringByAppendingString:@".png"];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:projectComponentTitleString];
            
            //NSString *filePath = [[NSBundle mainBundle] pathForResource:projectComponentTitleString ofType:@"png"];


            
            NSMutableDictionary *mediaAttributes = [[NSMutableDictionary alloc]init];
            [mediaAttributes setObject:[NSDate date] forKey:@"created"];
            [mediaAttributes setObject:[NSDate date] forKey:@"updated"];
            [mediaAttributes setObject:[NSNumber numberWithInt:MEDIA_PHOTO] forKey:@"type"];
            [mediaAttributes setObject:filePath forKey:@"mediaURL"];
            
            Media *projectComponentMedia = [[AppModel sharedAppModel]createNewMediaWithAttributes:mediaAttributes];
            projectComponent.media = projectComponentMedia;
            ///////////////NICK MADE
            
            [projectComponents addObject:projectComponent];

            
            
            if (dashIndex != NSNotFound) {
                NSString *stringProjectComponentPossibilities = [withoutParams substringFromIndex:dashIndex+2];
                NSArray *projectComponentPossibilities = [stringProjectComponentPossibilities componentsSeparatedByString:@", "];
                for (int j = 0; j < [projectComponentPossibilities count]; j++) {
                    NSString *stringProjectComponentPossibility = projectComponentPossibilities[j];
                    ProjectComponentPossibility *projectComponentPossibility = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
                    projectComponentPossibility.created = [NSDate date];
                    projectComponentPossibility.updated = [NSDate date];
                    projectComponentPossibility.projectComponent = projectComponent;
                    
                    if(judgementType == JUDGEMENT_ENUMERATOR){
                        projectComponentPossibility.enumValue = stringProjectComponentPossibility;
                    }
                    else{
                        NSLog(@"Error parsing project possibilities. Something other than enum is specified after the dash");
                    }
                }
            }
            else{
                if(judgementType == JUDGEMENT_BOOLEAN){
                    ProjectComponentPossibility *projectComponentPossibilityYES = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
                    projectComponentPossibilityYES.created = [NSDate date];
                    projectComponentPossibilityYES.updated = [NSDate date];
                    projectComponentPossibilityYES.projectComponent = projectComponent;
                    projectComponentPossibilityYES.boolValue = [NSNumber numberWithBool:YES];
                    
                    ProjectComponentPossibility *projectComponentPossibilityNO = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
                    projectComponentPossibilityNO.created = [NSDate date];
                    projectComponentPossibilityNO.updated = [NSDate date];
                    projectComponentPossibilityNO.projectComponent = projectComponent;
                    projectComponentPossibilityNO.boolValue = [NSNumber numberWithBool:NO];
                }
            }
        }
        else{
            nonComponents++;
            NSString *helpString = @"Components go to the right of this column FORMAT: <Component Name> DASH <Component Possibility>, <Component Possibility>, .... LEFT CURLY BRACE isRequired RIGHT CURLY BRACE LEFT CURLY BRACE <Observation Type> RIGHT CURLY BRACE LEFT CURLY BRACE <Data Type> RIGHT CURLY BRACE";
            if(i > 2 && ![self stringMatchesRegex:wordsSeperatedByTabs[i] regex:helpString]){
                ProjectIdentificationDiscussion *discussion = (ProjectIdentificationDiscussion *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationDiscussion" inManagedObjectContext:[self managedObjectContext]];
                discussion.created = [NSDate date];
                discussion.updated = [NSDate date];
                discussion.title = wordsSeperatedByTabs[i];
                //create media object here and attach it
                discussion.project = project;
            }
        }
    }
        
    //read in the actual data
    for(int i = 1; i < [lines count]; i++){
        
        NSArray *components = [lines[i] componentsSeparatedByString:@"\t"];
        ProjectIdentification *identification = (ProjectIdentification *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentification" inManagedObjectContext:[self managedObjectContext]];
        identification.authorCreated = [NSNumber numberWithBool:YES];
        identification.created = [NSDate date];
        identification.updated = [NSDate date];
        identification.identificationDescription = components[2];
        identification.alternateName = components[1];
        identification.title = components[0];
        identification.score = [NSNumber numberWithFloat:0.0f];
        identification.numOfNils = [NSNumber numberWithInt:0];
        //add media array here
        identification.project = project;
        
        int numOfNonComponents = nonComponents;
        for (int j = 0; j < [components count]; j++) {
            
            NSString *commaListOfComponentPossibilities = components[j];
            if(j >= numOfNonComponents){
                ProjectComponent *associatedProjectComponent = [projectComponents objectAtIndex:j-numOfNonComponents];
                
                if([commaListOfComponentPossibilities isEqualToString:@""]){
                    //create special 'nil' possibility for data that isn't filled out
                    ProjectComponentPossibility *nilPossibility = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
                    nilPossibility.created = [NSDate date];
                    nilPossibility.updated = [NSDate date];
                    nilPossibility.enumValue = @""; //special value for nil possibility
                    nilPossibility.projectComponent = associatedProjectComponent;
                    //create a 'pairing' of the identification and nil so we can find where data isn't filled out in the table
                    ProjectIdentificationComponentPossibility *projectIdentificationComponentPossibility = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
                    projectIdentificationComponentPossibility.created = [NSDate date];
                    projectIdentificationComponentPossibility.updated = [NSDate date];
                    projectIdentificationComponentPossibility.projectComponentPossibility = nilPossibility;
                    projectIdentificationComponentPossibility.projectIdentification = identification;
                    //NSLog(@"Creating identification component possibility for identification: %@ with nil possibility", identification.title);
                    continue;
                }
                
                NSArray *componentPossibilities = [commaListOfComponentPossibilities componentsSeparatedByString:@", "];
                
                
                for(int k = 0; k < [componentPossibilities count]; k++){
                    //create the possibilities for numbers and text
//                    NSString *debugPossibility = componentPossibilities[k];
//                    NSLog(@"Debug Possibility: %@", debugPossibility);
                    ProjectComponentPossibility *componentPossibility;
                    if(associatedProjectComponent.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_NUMBER] || associatedProjectComponent.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_TEXT] || associatedProjectComponent.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_LONG_TEXT]){
                        
                        componentPossibility = (ProjectComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
                        componentPossibility.created = [NSDate date];
                        componentPossibility.updated = [NSDate date];
                        if(associatedProjectComponent.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_NUMBER]){
                            if(k == 0){
                                if([componentPossibilities count] != 2){
                                    NSLog(@"Error parsing number, more than two numbers were provided");
                                    continue;
                                }
                                NSString *number = componentPossibilities[0];
                                NSString *stdDev = componentPossibilities[1];
                                componentPossibility.number = [NSNumber numberWithInt:[number intValue]];
                                componentPossibility.stdDev = [NSNumber numberWithInt:[stdDev intValue]];
                                componentPossibility.projectComponent = associatedProjectComponent;
                            }
                            else{
                                continue;
                            }
                        }
                        else if(associatedProjectComponent.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_TEXT]){
                            componentPossibility.text = componentPossibilities[k];
                            componentPossibility.projectComponent = associatedProjectComponent;
                        }
                        else{
                            componentPossibility.longText = componentPossibilities[k];
                            componentPossibility.projectComponent = associatedProjectComponent;
                        }
                    }
                    else if(associatedProjectComponent.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_BOOLEAN]){
                        NSString *yesRegex = @"\\s*(YES|yes)\\s*";
                        if([self stringMatchesRegex:componentPossibilities[k] regex:yesRegex]){
                            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
                            [attributes setObject:[NSNumber numberWithBool:YES] forKey:@"boolValue"];
                            [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
                            componentPossibility = [self fetchEntities:@"ProjectComponentPossibility" withAttributes:attributes];
                        }
                        else{
                            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
                            [attributes setObject:[NSNumber numberWithBool:NO] forKey:@"boolValue"];
                            [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
                            componentPossibility = [self fetchEntities:@"ProjectComponentPossibility" withAttributes:attributes];
                        }
                    }
                    else{
                        NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
                        [attributes setObject:componentPossibilities[k] forKey:@"enumValue"];
                        [attributes setObject:associatedProjectComponent.title forKey:@"projectComponent.title"];
                        componentPossibility = [self fetchEntities:@"ProjectComponentPossibility" withAttributes:attributes];
                    }
                    
                    ProjectIdentificationComponentPossibility *projectIdentificationComponentPossibility = (ProjectIdentificationComponentPossibility *)[NSEntityDescription insertNewObjectForEntityForName:@"ProjectIdentificationComponentPossibility" inManagedObjectContext:[self managedObjectContext]];
                    projectIdentificationComponentPossibility.created = [NSDate date];
                    projectIdentificationComponentPossibility.updated = [NSDate date];
                    projectIdentificationComponentPossibility.projectComponentPossibility = componentPossibility;
                    projectIdentificationComponentPossibility.projectIdentification = identification;
                    
                    if (!componentPossibility) {
                        NSLog(@"ERROR!!!!! Created Project Identification Component Possibility. Identification: %@ Component: %@ Possibility: %@", identification.title, associatedProjectComponent.title, componentPossibility.enumValue);
                    }
                    
                    //NSLog(@"Created Project Identification Component Possibility. Identification: %@ Component: %@ Possibility: %@", identification.title, associatedProjectComponent.title, componentPossibility.enumValue);
                    
                }
            }
        }
        
    }
    
    [[AppModel sharedAppModel] save];
    
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

@end
