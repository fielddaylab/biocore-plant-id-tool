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
#import "MediaManager.h"

@interface BooleanJudgementViewController ()<SaveJudgementDelegate>{
    UISwitch *boolSwitch;
    UIImageView *imageView;
    NSArray *possibilities;
    CGRect rectView;
}

@end

@implementation BooleanJudgementViewController
@synthesize prevData;
@synthesize projectComponent;
@synthesize isOneToOne;

- (id)initWithFrame:(CGRect) rect{
    self = [super init];
    rectView = rect;
    return self;
}

- (void)loadView{
    [super loadView];
    /*if (!isOneToOne) {
        [self.view addSubview:[[UIImageView alloc] initWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"carouselBackground"]]];//Dafuq is this? - Nick
    }
    else{ */
        self.view.backgroundColor = [UIColor lightGrayColor];
  //  }
    
    UITextView *descriptionTextField = [[UITextView alloc]initWithFrame:CGRectMake(0, rectView.size.height * .02, rectView.size.width, 60)];
    descriptionTextField.backgroundColor = [UIColor clearColor];
    descriptionTextField.textAlignment = NSTextAlignmentCenter;
    descriptionTextField.font = [descriptionTextField.font fontWithSize:16];
    
    descriptionTextField.editable = NO;
    
    if ([projectComponent.prompt isEqualToString:@""]) {
        descriptionTextField.text = [NSString stringWithFormat:@"Enter a number for %@.", projectComponent.title];
    }
    else{
        descriptionTextField.text = projectComponent.prompt;
    }
    
    descriptionTextField.tag = 2;
    [self.view addSubview:descriptionTextField];
    
    boolSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    if (!isOneToOne) {
        boolSwitch.frame = CGRectMake(rectView.size.width *.6 , rectView.size.height *.5 - boolSwitch.frame.size.height*.5 + 10, 0, 0);
    }
    else{
        boolSwitch.frame = CGRectMake(rectView.size.width *.6 , descriptionTextField.frame.size.height + 60, 0, 0);
    }
    
    [self.view addSubview:boolSwitch];
    
    imageView = [[UIImageView alloc]initWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"test.png"]];//why use test?
    
    NSString *tutorialImageString = projectComponent.title;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    tutorialImageString = [[tutorialImageString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
    tutorialImageString = [tutorialImageString stringByAppendingString:@"_TutorialSmall"];
    

    if (!isOneToOne) {
        imageView.frame = CGRectMake(-75, 10, rectView.size.width, rectView.size.height);
        imageView.image = [[MediaManager sharedMediaManager] imageWithImage:[[MediaManager sharedMediaManager] getImageNamed:tutorialImageString] scaledToSize:CGRectMake(0, 0, rectView.size.height *.7, rectView.size.height *.7).size];
    }
    else{
        imageView.frame = CGRectMake(rectView.size.width * .1, boolSwitch.frame.origin.y, 100, 100);
        imageView.image = [[MediaManager sharedMediaManager] imageWithImage:[[MediaManager sharedMediaManager] getImageNamed:tutorialImageString] scaledToSize:CGRectMake(0, 0, 100, 100).size];
    }
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = rectView;
    
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
    
    UserObservationComponentDataJudgement *judgement = [[AppModel sharedAppModel] createNewJudgementWithData:userData withProjectComponentPossibility:possibility withAttributes:attributes];
    return judgement;
}

-(UserObservationComponentData *)saveUserDataAndJudgement{
    BOOL switchValue = boolSwitch.isOn;
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    [attributes setObject:[NSNumber numberWithBool:switchValue] forKey:@"boolValue"];
    [attributes setObject:projectComponent forKey:@"projectComponent"];
    
    UserObservationComponentData *data = [[AppModel sharedAppModel] createNewObservationDataWithAttributes:attributes];
    
    NSMutableDictionary *judgementAttributes = [[NSMutableDictionary alloc]init];
    [judgementAttributes setObject:[NSDate date] forKey:@"created"];
    [judgementAttributes setObject:[NSDate date] forKey:@"updated"];
    [judgementAttributes setObject:[NSNumber numberWithBool:switchValue] forKey:@"boolValue"];
    
    //figure out what possibility you have chosen
    ProjectComponentPossibility *possibility;
    for (int i = 0; i < possibilities.count; i++) {
        possibility = [possibilities objectAtIndex:i];
        if([possibility.boolValue boolValue] == switchValue){
            break;
        }
    }
    
    [[AppModel sharedAppModel] createNewJudgementWithData:data withProjectComponentPossibility:possibility withAttributes:judgementAttributes];
    return data;
}

#pragma mark handle possibility response
-(void)handlePossibilityResponse:(NSArray *)componentPossibilities{
    possibilities = componentPossibilities;
}

@end
