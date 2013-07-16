//
//  ObservationNumberViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationNumberViewController.h"

@interface ObservationNumberViewController (){
    int unitCount;
}

@end

@implementation ObservationNumberViewController

@synthesize componentPossibilityDescription;
@synthesize changeUnitButton;

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