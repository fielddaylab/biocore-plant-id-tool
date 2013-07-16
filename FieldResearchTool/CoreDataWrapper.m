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

-(void)fetchAllObjectsFromTable:(NSString *)tableName withHandler:(SEL)handler{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching all object from table. Handler not called. %@", error);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [[AppModel sharedAppModel] performSelector:handler withObject:fetchedObjects];
#pragma clang diagnostic pop
            }
        });
    });
}

-(void)fetchAllObjectsFromTable:(NSString *)tableName withAttribute:(NSString *)attributeName equalTo:(NSString *)attributeValue withHandler:(SEL)handler{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *predicateString = [NSString stringWithFormat:@"%@ == '%@'", attributeName, attributeValue];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching all objects from table with an attribute. Handler not called. %@", error);
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [[AppModel sharedAppModel] performSelector:handler withObject:fetchedObjects];
#pragma clang diagnostic pop
            }
        });
    });
}

-(void)fetchObjectsFromTable:(NSString *)tableName withAttributes:(NSDictionary *)attributeNamesAndValues withHandler:(SEL)handler{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if([attributeNamesAndValues count] > 0){
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
    

    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"An error occurred when fetching objects from table with attributes. Handler not called. %@", error);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [[AppModel sharedAppModel] performSelector:handler withObject:fetchedObjects];
#pragma clang diagnostic pop
            }
        });
    });
    
}

@end
