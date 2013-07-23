//
//  ObservationBooleanViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationBooleanViewController.h"
#import "AppModel.h"
#import "ProjectComponentPossibility.h"

@interface ObservationBooleanViewController ()

@end

@implementation ObservationBooleanViewController

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
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObservationData)]];
    
    componentPossibilityDescription.text = projectComponent.title;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark save observation data
-(void)saveObservationData{
    //save the user observation component
    NSMutableDictionary *dataAttributes = [[NSMutableDictionary alloc]init];
    [dataAttributes setValue:[NSDate date] forKey:@"created"];
    [dataAttributes setValue:[NSDate date] forKey:@"updated"];
    [dataAttributes setValue:[NSNumber numberWithBool:[boolSwitch isOn]] forKey:@"dataInt"];
    
    UserObservationComponentData *currentComponentData = [[AppModel sharedAppModel] createNewUserObservationComponentDataWithProjectComponent:projectComponent withAttributes:dataAttributes];
    
    NSArray *possibilities = [NSArray arrayWithArray:[projectComponent.projectComponentPossibilities allObjects]];
    
    ProjectComponentPossibility *componentPossibility;
    for (int i = 0; i < possibilities.count; i++) {
        componentPossibility = possibilities[i];
        if(componentPossibility.boolValue == [NSNumber numberWithBool:[boolSwitch isOn]]){
            break;
        }
    }
    
    //    NSMutableDictionary *judgementAttributes = [[NSMutableDictionary alloc]init];
    //    [judgementAttributes setValue:[NSDate date] forKey:@"created"];
    //    [judgementAttributes setValue:[NSDate date] forKey:@"updated"];
    //    UserObservationComponentDataJudgement *currentJudgment = [[AppModel sharedAppModel] createNewUserObservationComponentDataJudgementWithAttributes:judgementAttributes withUserObservationComponentData:currentComponentData withProjectComponentPossibility:componentPossibility];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
