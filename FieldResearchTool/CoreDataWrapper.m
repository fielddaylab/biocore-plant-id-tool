//
//  CoreDataWrapper.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "CoreDataWrapper.h"
#import "AppDelegate.h"
#import "AppModel.h"

@implementation CoreDataWrapper

@synthesize managedObjectContext;
@synthesize managedObjectModel;

#pragma mark Init/dealloc
- (id) init
{
    self = [super init];
    if(self)
    {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
        managedObjectModel = [(AppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectModel];
	}
    return self;
}

-(void)callHandlerForTarget:(id)target handler:(SEL)handler withObject:(id)fetchedObjects{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [target performSelector:handler withObject:fetchedObjects];
#pragma clang diagnostic pop
            }
        });
    });
}

-(void)fetchAllEntities:(NSString *)entityName withHandler:(SEL)handler target:(id)target{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching all entities. Handler not called. %@", error);
        return;
    }
    
    [self callHandlerForTarget:target handler:handler withObject:fetchedObjects];
}

-(void)fetchAllEntities:(NSString *)entityName withAttribute:(NSString *)attributeName equalTo:(NSString *)attributeValue withHandler:(SEL)handler target:(id)target{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *predicateString = [NSString stringWithFormat:@"%@ == '%@'", attributeName, attributeValue];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching all entities with an attribute. Handler not called. %@", error);
        return;
    }

    [self callHandlerForTarget:target handler:handler withObject:fetchedObjects];
}

-(void)fetchEntities:(NSString *)entityName withAttributes:(NSDictionary *)attributeNamesAndValues withHandler:(SEL)handler target:(id)target{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if(attributeNamesAndValues && [attributeNamesAndValues count] > 0){
        //create the predicate string
        NSMutableString *predicateString = [NSMutableString stringWithString:@""];
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
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching entities with attributes. Handler not called. %@", error);
        return;
    }
    
    [self callHandlerForTarget:target handler:handler withObject:fetchedObjects];
    
}

-(void)fetchEntities:(NSString *)entityName withAttributes:(NSDictionary *)attributeNamesAndValues withSortedAttributes:(NSArray *)attributesToBeSorted withHandler:(SEL)handler target:(id)target{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if(attributeNamesAndValues && [attributeNamesAndValues count] > 0){
        //create the predicate string
        NSMutableString *predicateString = [NSMutableString stringWithString:@""];
        for (NSString *key in attributeNamesAndValues) {
            //first check to make sure the object we're adding to the predicate string isnt nil
            if([attributeNamesAndValues objectForKey:key]){
                if([predicateString isEqualToString:@""]){
                    [predicateString appendFormat:@"%@ == '%@'", key, [attributeNamesAndValues objectForKey:key]];
                }
                else{
                    [predicateString appendFormat:@" && %@ == '%@'", key, [attributeNamesAndValues objectForKey:key]];
                }
            }
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        [fetchRequest setPredicate:predicate];
    }
    
    
    if(attributesToBeSorted && [attributesToBeSorted count] > 0){
        NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
        for(int i = 0; i < [attributesToBeSorted count]; i++){
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributesToBeSorted[i] ascending:YES];
            [sortDescriptors addObject:sortDescriptor];
        }
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching entities with attributes and sorting them. Handler not called. %@", error);
        return;
    }
    
    [self callHandlerForTarget:target handler:handler withObject:fetchedObjects];
    
}

-(void)fetchEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate withHandler:(SEL)handler target:(id)target{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching entities with a predicate. Handler not called. %@", error);
        return;
    }
    
    [self callHandlerForTarget:target handler:handler withObject:fetchedObjects];
}

-(void)fetchEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors withHandler:(SEL)handler target:(id)target{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching entities with a predicate and with sort descriptors. Handler not called. %@", error);
        return;
    }
    
    [self callHandlerForTarget:target handler:handler withObject:fetchedObjects];
}

-(BOOL)save{
    NSError *error = nil;
    if(![managedObjectContext save:&error]){
        NSLog(@"An error occurred while saving the managed object context. %@", error);
        return NO;
    }
    return YES;
}

-(void)deleteObject:(NSManagedObject *)objectToDelete{
    [managedObjectContext deleteObject:objectToDelete];
}

-(void)deleteObjects:(NSArray *)objectsToDelete{
    for(id object in objectsToDelete){
        if(![object isKindOfClass:[NSManagedObject class]]){
            NSLog(@"Couldn't delete object because it is not a managed object");
            continue;
        }
        [managedObjectContext deleteObject:object];
    }
}
@end
