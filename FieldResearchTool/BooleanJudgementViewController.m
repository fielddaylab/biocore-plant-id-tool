//
//  BooleanJudgementViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "BooleanJudgementViewController.h"
#import "SaveObservationAndJudgementDelegate.h"
#import "AppModel.h"

@interface BooleanJudgementViewController ()<SaveJudgementDelegate>{
    UISwitch *boolSwitch;
    NSArray *possibilities;
}

@end

@implementation BooleanJudgementViewController
@synthesize projectComponent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    boolSwitch = [[UISwitch alloc]initWithFrame:frame];
    [self.view addSubview:boolSwitch];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:projectComponent.title forKey:@"projectComponent.title"];
    [[AppModel sharedAppModel] getProjectComponentPossibilitiesWithAttributes:attributes withHandler:@selector(handlePossibilityResponse:) target:self];
    
//    if([projectComponent.wasJudged boolValue]){
//        NSArray *dataSet = [projectComponent.userObservationComponentData allObjects];
//        if(!dataSet || dataSet.count < 1){
//            NSLog(@"ERROR: Data set was nil or had 0 data members");
//        }
//        UserObservationComponentData *data = [dataSet objectAtIndex:0];
//        if(!data){
//            NSLog(@"ERROR: data was nil");
//        }
//        NSArray *judgementSet = [data.userObservationComponentDataJudgement allObjects];
//        if(!judgementSet || judgementSet.count < 1){
//            NSLog(@"ERROR: Judgement set was nil or had 0 data members");
//        }
//        UserObservationComponentDataJudgement *judgement = [judgementSet objectAtIndex:0];
//        if(!judgement){
//            NSLog(@"ERROR: judgement was nil");
//        }
//        BOOL switchValue = [judgement.boolValue boolValue];
//        [boolSwitch setOn:switchValue animated:NO];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark saving judgement data

-(UserObservationComponentDataJudgement *)saveJudgementData:(UserObservationComponentData *)userData{
    
    if(!userData){
        NSLog(@"ERROR: Observation data passed in was nil");
        return nil;
    }
    
    BOOL switchValue = boolSwitch.isOn;
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    [attributes setObject:[NSNumber numberWithBool:switchValue] forKey:@"boolValue"];
    
    //figure out what possibility you have chosen
    ProjectComponentPossibility *possibility;
    for (int i = 0; i < possibilities.count; i++) {
        possibility = [possibilities objectAtIndex:i];
        if([possibility.boolValue boolValue] == switchValue){
            break;
        }
    }
    
    NSArray *chosenPossibility = [NSArray arrayWithObject:possibility];
    UserObservationComponentDataJudgement *judgement = [[AppModel sharedAppModel] createNewJudgementWithData:userData withProjectComponentPossibility:chosenPossibility withAttributes:attributes];
    return judgement;
}

#pragma mark handle possibility response
-(void)handlePossibilityResponse:(NSArray *)componentPossibilities{
    possibilities = componentPossibilities;
}

@end
