//
//  ObservationTextViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationTextViewController.h"
#import "AppModel.h"

@interface ObservationTextViewController (){
}

@end

@implementation ObservationTextViewController

@synthesize componentPossibilityDescription, userInput;
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
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObservationData)]];
    
    componentPossibilityDescription.text = projectComponent.title;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)killKeyboard:(id)sender {
    
    [self.view endEditing:YES];
}

#pragma mark save observation data
-(void)saveObservationData{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    [attributes setObject:userInput.text forKey:@"dataText"];
    
    [[AppModel sharedAppModel] createNewUserObservationComponentDataWithProjectComponent:projectComponent withAttributes:attributes];
    projectComponent.wasObserved = [NSNumber numberWithBool:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
