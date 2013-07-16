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

-(void)fetchAllObjectsFromTable:(NSString *)tableName withHandler:(SEL)handler;
-(void)fetchAllObjectsFromTable:(NSString *)tableName withAttribute:(NSString *)attributeName equalTo:(NSString *)attributeValue withHandler:(SEL)handler;

@end
