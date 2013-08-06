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
#import "ProjectComponent.h"

@interface BooleanDataViewController ()<SaveObservationDelegate>

@end

@implementation BooleanDataViewController


@synthesize componentPossibilityDescription;
@synthesize boolSwitch;
@synthesize prevData;
@synthesize projectComponent;
@synthesize newObservation;

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
}

-(void)viewWillAppear:(BOOL)animated{
    if (prevData) {
        BOOL switchValue = [prevData.boolValue boolValue];
        [boolSwitch setOn:switchValue animated:NO];
    }
    if(!newObservation){
        boolSwitch.enabled = NO;
    }
    
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

