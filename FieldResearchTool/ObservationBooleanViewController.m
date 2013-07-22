//
//  ObservationBooleanViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationBooleanViewController.h"
#import "AppModel.h"

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
    // Do any additional setup after loading the view from its nib.
#warning TODO

    componentPossibilityDescription.text = projectComponent.title;

    
}

-(void)viewWillDisappear:(BOOL)animated{
    //save the user observation component
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setValue:[NSDate date] forKey:@"created"];
    [attributes setValue:[NSDate date] forKey:@"updated"];
    [attributes setValue:[NSNumber numberWithBool:[boolSwitch isOn]] forKey:@"data"];
    
    [[AppModel sharedAppModel] createNewUserObservationComponentDataWithProjectComponent:projectComponent withAttributes:attributes withHandler:nil target:nil];
    
    //possibility create the data judgment at the same time here
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
