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
#import "BooleanDataViewController.h"
#import "NumberDataViewController.h"
#import "BooleanJudgementViewController.h"
#import "LongTextJudgementViewController.h"
#import "TextJudgementViewController.h"
#import "NumberJudgementViewController.h"
#import "EnumDataViewController.h"



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
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height* .75f + [UIApplication sharedApplication].statusBarFrame.size.height + [self.navigationController navigationBar].frame.size.height));
    
    UIViewController *dataViewControllerToDisplay;
    switch ([projectComponent.observationDataType intValue]) {
        case DATA_AUDIO:
            //set up view controller here
            break;
        case DATA_VIDEO:
            //set up view controller here
            break;
        case DATA_PHOTO:{
            PhotoDataViewController *photoDataViewController = [[PhotoDataViewController alloc]init];
            dataViewControllerToDisplay = photoDataViewController;
        }
            break;
        case DATA_NUMBER:{
            NumberDataViewController *numberDataViewController = [[NumberDataViewController alloc]init];
            numberDataViewController.view.frame = frame;
            dataViewControllerToDisplay = numberDataViewController;
        }
            break;
        case DATA_BOOLEAN:{
            BooleanDataViewController *booleanDataViewController = [[BooleanDataViewController alloc]init];
            booleanDataViewController.view.frame = frame;
            dataViewControllerToDisplay = booleanDataViewController;
        }
            break;
        case DATA_TEXT:{
            //set up view controller here
        }
            break;
        case DATA_LONG_TEXT:
            //set up view controller here
            break;
        case DATA_ENUMERATOR:{
            EnumDataViewController *enumDataViewController = [[EnumDataViewController alloc]init];
            enumDataViewController.view.frame = frame;
            dataViewControllerToDisplay = enumDataViewController;
        }
            break;
        default:
            break;
    }
    if(dataViewControllerToDisplay){
        [self addChildViewController:dataViewControllerToDisplay];
        [self didMoveToParentViewController:dataViewControllerToDisplay];
        [self.view addSubview:dataViewControllerToDisplay.view];
    }


    
    frame = CGRectMake(0, self.view.bounds.size.height * .75f, self.view.bounds.size.width, (self.view.bounds.size.height * .25f) );
    UIViewController *judgementViewControllerToDisplay;
    switch ([projectComponent.observationJudgementType intValue]) {
        case JUDGEMENT_NUMBER:{
            NumberJudgementViewController *numberJudgementViewController = [[NumberJudgementViewController alloc]init];
            numberJudgementViewController.view.frame = frame;
            judgementViewControllerToDisplay = numberJudgementViewController;
        }
            break;
        case JUDGEMENT_BOOLEAN:{
            BooleanJudgementViewController *booleanJudgementViewController = [[BooleanJudgementViewController alloc]init];
            booleanJudgementViewController.view.frame = frame;
            judgementViewControllerToDisplay = booleanJudgementViewController;
        }
            break;
        case JUDGEMENT_TEXT:{
            TextJudgementViewController *textJudgementViewController = [[TextJudgementViewController alloc]init];
            textJudgementViewController.view.frame = frame;
            judgementViewControllerToDisplay = textJudgementViewController;
        }
            break;
        case JUDGEMENT_LONG_TEXT:{
            LongTextJudgementViewController *longTextJudgementViewController = [[LongTextJudgementViewController alloc]init];
            longTextJudgementViewController.view.frame = frame;
            judgementViewControllerToDisplay = longTextJudgementViewController;
        }
            break;
        case JUDGEMENT_ENUMERATOR:{
            EnumJudgementViewController *enumJudgementViewController = [[EnumJudgementViewController alloc]init];
            enumJudgementViewController.view.frame = frame;
            enumJudgementViewController.view.backgroundColor = [UIColor lightGrayColor];
            enumJudgementViewController.projectComponent = projectComponent;
            judgementViewControllerToDisplay = enumJudgementViewController;

        }
            break;
        default:
            break;
    }

    if(judgementViewControllerToDisplay){
        [self addChildViewController:judgementViewControllerToDisplay];
        [self didMoveToParentViewController:judgementViewControllerToDisplay];
        [self.view addSubview:judgementViewControllerToDisplay.view];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
