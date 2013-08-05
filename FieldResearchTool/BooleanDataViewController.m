//
//  BooleanDataViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "BooleanDataViewController.h"
#import "AppModel.h"
#import "ProjectComponentPossibility.h"
#import "SaveObservationAndJudgementDelegate.h"

@interface BooleanDataViewController ()<SaveObservationDelegate>

@end

@implementation BooleanDataViewController


@synthesize componentPossibilityDescription;
@synthesize projectComponent;
@synthesize boolSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"BOOLZ";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    componentPossibilityDescription.text = projectComponent.title;
}

-(void)viewWillAppear:(BOOL)animated{
//    if([projectComponent.wasObserved boolValue]){
//        NSArray *dataSet = [projectComponent.userObservationComponentData allObjects];
//        if(!dataSet || dataSet.count < 1){
//            NSLog(@"ERROR: dataSet is nil or has no objects");
//        }
//        UserObservationComponentData *prevData = [dataSet objectAtIndex:0];
//        if(!prevData){
//            NSLog(@"ERROR: prevData was nil");
//        }
//        BOOL switchValue = [prevData.boolValue boolValue];
//        [boolSwitch setOn:switchValue animated:NO];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark save observation data
-(UserObservationComponentData *)saveObservationData{
    
    BOOL switchValue = boolSwitch.isOn;
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    [attributes setObject:[NSNumber numberWithBool:switchValue] forKey:@"boolValue"];
    [attributes setObject:projectComponent forKey:@"projectComponent"];
    
    UserObservationComponentData *data = [[AppModel sharedAppModel] createNewObservationDataWithAttributes:attributes];
    return data;
}

@end

