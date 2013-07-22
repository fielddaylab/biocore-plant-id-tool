//
//  ObservationNumberViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationNumberViewController.h"
#import "AppModel.h"

@interface ObservationNumberViewController (){
    int unitCount;
}

@end

@implementation ObservationNumberViewController

@synthesize componentPossibilityDescription;
@synthesize changeUnitButton;
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
    // Do any additional setup after loading the view from its nib.
    
#warning TODO
    
    [changeUnitButton setTitle:@"cm" forState:UIControlStateNormal];
    
    unitCount = 0;
    
    componentPossibilityDescription.text = @"WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN WHEN A FIRE STARTS TO BURN ";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    //Means that we are for sure going 'back'
    if ([self isMovingFromParentViewController]){

    //createNewUserObservationComponentDataForUserObservation
        NSLog(@"JUP");
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
        [attributes setValue:[NSNumber numberWithFloat:1.0f] forKey:@"latitude"];
        [attributes setValue:[NSNumber numberWithFloat:1.0f] forKey:@"longitude"];
        [attributes setValue:[NSDate date] forKey:@"created"];
        [attributes setValue:[NSDate date] forKey:@"updated"];
        
        //[[AppModel sharedAppModel] createNewUserObservationComponentDataForUserObservation:[[AppModel sharedAppModel]currentUserObservation] withProjectComponent:projectComponent withAttributes:attributes withHandler:nil target:nil];
    
    }
}


- (IBAction)changeUnit:(id)sender {
    unitCount ++;
    if(unitCount % 2 == 0){
        [changeUnitButton setTitle:@"cm" forState:UIControlStateNormal];
    }
    else if(unitCount % 2 == 1){
        [changeUnitButton setTitle:@"inches" forState:UIControlStateNormal];
    }
}
- (IBAction)killKeyboard:(id)sender {
    [self.view endEditing:YES];

}
@end