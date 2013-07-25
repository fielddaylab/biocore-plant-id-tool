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
    float lulz;
}


@end

@implementation ObservationContainerViewController
@synthesize projectComponent;
@synthesize delegate;

- (void)saveObservationData:(id)sender {
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([self.delegate respondsToSelector:@selector(observationContainerViewController:didChooseValue:)]) {
        [self.delegate observationContainerViewController:self didChooseValue:lulz];
        NSLog(@"In the IF");

    }
    
    NSLog(@"SHOULD BE SAVING SOMEWHERE ELSE - NEED TO DO");
    [self.navigationController popViewControllerAnimated:YES];

}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"New Obs";
        lulz = 3;
        
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
