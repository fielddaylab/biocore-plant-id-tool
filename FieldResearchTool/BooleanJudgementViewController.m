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
    CGRect rectView;
}

@end

@implementation BooleanJudgementViewController
@synthesize prevData;
@synthesize projectComponent;

- (id)initWithFrame:(CGRect) rect{
    self = [super init];
    
    rectView = rect;
    
    return self;
    
}

- (void)loadView{//Not called until view accessed
    [super loadView];
    
    NSLog(@"\nbounds: %@ \nframe: %@ ", NSStringFromCGRect(self.view.bounds), NSStringFromCGRect(self.view.frame));
    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width * .5, [UIScreen mainScreen].bounds.size.height *.66, 0,0);
    boolSwitch = [[UISwitch alloc]initWithFrame:frame];
    [self.view addSubview:boolSwitch];
}



-(void)viewWillAppear:(BOOL)animated{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:projectComponent.title forKey:@"projectComponent.title"];
    [[AppModel sharedAppModel] getProjectComponentPossibilitiesWithAttributes:attributes withHandler:@selector(handlePossibilityResponse:) target:self];
    
    if(prevData){
        if ([prevData.wasJudged boolValue]) {
            NSArray *judgementSet = [prevData.userObservationComponentDataJudgement allObjects];
            if(!judgementSet || judgementSet.count < 1){
                NSLog(@"ERROR: Judgement set was nil or had 0 data members");
            }
            UserObservationComponentDataJudgement *judgement = [judgementSet objectAtIndex:0];
            if(!judgement){
                NSLog(@"ERROR: judgement was nil");
            }
            BOOL switchValue = [judgement.boolValue boolValue];
            [boolSwitch setOn:switchValue animated:NO];
        }
    }

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
