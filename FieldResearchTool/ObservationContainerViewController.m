//
//  ObservationContainerViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/24/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationContainerViewController.h"
#import "AppModel.h"
#import "ProjectComponentPossibility.h"


@interface ObservationContainerViewController (){
}


@end

@implementation ObservationContainerViewController
@synthesize projectComponent;
@synthesize delegate;

- (void)saveObservationData:(id)sender {

    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    //[attributes setValue:[NSNumber numberWithInt:[textField.text intValue]] forKey:@"dataInt"];
    [attributes setValue:[NSDate date] forKey:@"created"];
    [attributes setValue:[NSDate date] forKey:@"updated"];
    
    [[AppModel sharedAppModel] createNewUserObservationComponentDataWithProjectComponent:projectComponent withAttributes:attributes];
    projectComponent.wasObserved = [NSNumber numberWithBool:YES];
    [[AppModel sharedAppModel] save];
    
    
    NSLog(@"SHOULD BE SAVING SOMEWHERE ELSE - NEED TO DO");

    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([self.delegate respondsToSelector:@selector(observationContainerViewController:)]) {
        [self.delegate observationContainerViewController:projectComponent];
        NSLog(@"In the IF");
        
    }
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"New Obs";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObservationData:)]];
    
    NSLog(@"IN CONTAINER");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
