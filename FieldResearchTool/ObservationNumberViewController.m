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
@synthesize textField;

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
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObservationData)]];
    [changeUnitButton setTitle:@"cm" forState:UIControlStateNormal];
    unitCount = 0;
    componentPossibilityDescription.text = projectComponent.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

#pragma mark save observation data
-(void)saveObservationData{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setValue:[NSNumber numberWithInt:[textField.text intValue]] forKey:@"dataInt"];
    [attributes setValue:[NSDate date] forKey:@"created"];
    [attributes setValue:[NSDate date] forKey:@"updated"];
    
    [[AppModel sharedAppModel] createNewUserObservationComponentDataWithProjectComponent:projectComponent withAttributes:attributes];
    projectComponent.wasObserved = [NSNumber numberWithBool:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end