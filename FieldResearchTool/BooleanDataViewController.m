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
#import "MediaManager.h"

@interface BooleanDataViewController ()<SaveObservationDelegate>{
    CGRect viewRect;
    UIImageView *imageView;
}

@end

@implementation BooleanDataViewController


@synthesize componentPossibilityDescription;
@synthesize boolSwitch;
@synthesize prevData;
@synthesize projectComponent;
@synthesize newObservation;

-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    viewRect = frame;
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = viewRect;
}

-(void)loadView{
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    boolSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width *.6, 100, 100, 100)];
    
    [self.view addSubview:boolSwitch];
    
    if (prevData) {
        BOOL switchValue = [prevData.boolValue boolValue];
        [boolSwitch setOn:switchValue animated:NO];
    }
    if(!newObservation){
        boolSwitch.enabled = NO;
    }
    
    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewRect.size.height * .04, viewRect.size.width, 22)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [descriptionLabel.font fontWithSize:16];
    if ([projectComponent.prompt isEqualToString:@""]) {
        descriptionLabel.text = [NSString stringWithFormat:@"Choose a value for %@.", projectComponent.title];
    }
    else{
        descriptionLabel.text = projectComponent.prompt;
    }
    
    descriptionLabel.tag = 2;
    [self.view addSubview:descriptionLabel];
    
    
    imageView = [[UIImageView alloc]initWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"test.png"]]; 
    imageView.frame = CGRectMake(viewRect.size.width *.1, boolSwitch.frame.size.height + imageView.frame.size.height, 100, 100);
    imageView.image = [[MediaManager sharedMediaManager] imageWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"Flower_color.png"] scaledToSize:CGRectMake(0, 0, self.view.bounds.size.height *.2, self.view.bounds.size.height *.2).size];
        
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    

    
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

