//
//  CoreDataWrapper.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataWrapper : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

-(void)fetchAllEntities:(NSString *)entityName withHandler:(SEL)handler target:(id)target;
-(void)fetchAllEntities:(NSString *)entityName withAttribute:(NSString *)attributeName equalTo:(NSString *)attributeValue withHandler:(SEL)handler target:(id)target;
-(void)fetchEntities:(NSString *)entityName withAttributes:(NSDictionary *)attributeNamesAndValues withHandler:(SEL)handler target:(id)target;

-(void)fetchEntities:(NSString *)entityName withAttributes:(NSDictionary *)attributeNamesAndValues withSortedAttributes:(NSArray *)attributesToBeSorted withHandler:(SEL)handler target:(id)target;


-(void)fetchEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate withHandler:(SEL)handler target:(id)target;
-(void)fetchEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors withHandler:(SEL)handler target:(id)target;

-(BOOL)save;

-(void)deleteObject:(NSManagedObject *)objectToDelete;
-(void)deleteObjects:(NSArray *)objectsToDelete;

@end
