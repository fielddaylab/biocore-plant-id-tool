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
#import "ObservationDataType.h"
#import "ObservationJudgementType.h"
#import "EnumJudgementViewController.h"
#import "PhotoDataViewController.h"
#import "EnumJudgementViewController.h"


@interface ObservationContainerViewController (){
}


@end

@implementation ObservationContainerViewController
@synthesize projectComponent;
@synthesize delegate;

- (void)saveObservationData:(id)sender {

    projectComponent.wasObserved = [NSNumber numberWithBool:YES];
    [[AppModel sharedAppModel] save];
    
    
    NSLog(@"SHOULD BE SAVING SOMEWHERE ELSE - NEED TO DO");

    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([self.delegate respondsToSelector:@selector(dismissContainerViewAndSetProjectComponentObserved:)]) {
        [self.delegate dismissContainerViewAndSetProjectComponentObserved:projectComponent];
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
    
    UIViewController *dataViewControllerToDisplay;
    switch ([projectComponent.observationDataType intValue]) {
        case DATA_AUDIO:
            //set up view controller here
            break;
        case DATA_VIDEO:
            //set up view controller here
            break;
        case DATA_PHOTO:{
            PhotoDataViewController *photoDataViewController = [[PhotoDataViewController alloc]initWithNibName:@"PhotoDataViewController" bundle:nil];
            dataViewControllerToDisplay = photoDataViewController;
        }
            //set up view here
            break;
        case DATA_NUMBER:
            //set up view controller here
            break;
        case DATA_BOOLEAN:
            //set up view controller here
            break;
        case DATA_TEXT:
            //set up view controller here
            break;
        case DATA_LONG_TEXT:
            //set up view controller here
            break;
        case DATA_ENUMERATOR:
            //set up view controller here
            break;
        default:
            break;
    }
    
    [self addChildViewController:dataViewControllerToDisplay];
    //[dataView addSubview:dataViewControllerToDisplay.view];
    
//    UIView *judgementViewToDisplay;
//    switch ([projectComponent.observationJudgementType intValue]) {
//        case JUDGEMENT_NUMBER:
//            //set up view controller here
//            break;
//        case JUDGEMENT_BOOLEAN:
//            //set up view controller here
//            break;
//        case JUDGEMENT_TEXT:
//            //set up view controller here
//            break;
//        case JUDGEMENT_LONG_TEXT:
//            //set up view controller here
//            break;
//        case JUDGEMENT_ENUMERATOR:{
//            EnumJudgementView *enumJudgementView = [[EnumJudgementView alloc]initWithFrame:dataView.frame];
//            judgementViewToDisplay = enumJudgementView;
//        }
//            break;
//        default:
//            break;
//    }
//    
//    [dataView addSubview:judgementViewToDisplay];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
