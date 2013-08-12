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
    [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carouselBackground"]]];
}

-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = rectView;
    
    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height * .04, self.view.bounds.size.width, 22)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [descriptionLabel.font fontWithSize:20];
    descriptionLabel.text = [NSString stringWithFormat:@"Is %@?", projectComponent.title];//This makes me cringe.
    descriptionLabel.tag = 2;
    [self.view addSubview:descriptionLabel];
       
    boolSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    boolSwitch.frame = CGRectMake(self.view.frame.size.width *.6 , self.view.frame.size.height *.5 - boolSwitch.frame.size.height*.5 + 10, 0, 0);
    [self.view addSubview:boolSwitch];
    
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test.png"]];
    imageView.frame = CGRectMake(-75, 10, self.view.frame.size.width, self.view.frame.size.height);
    
    imageView.image = [self imageWithImage:[UIImage imageNamed:@"Flower_color.png"] scaledToSize:CGRectMake(0, 0, self.view.bounds.size.height *.7, self.view.bounds.size.height *.7).size];
    
    imageView.contentMode = UIViewContentModeCenter;

    
    [self.view addSubview:imageView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
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

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
