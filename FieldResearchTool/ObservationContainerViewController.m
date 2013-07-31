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
@synthesize dismissDelegate;
@synthesize saveObservationDelegate;
@synthesize saveJudgementDelegate;

- (void)saveObservationData:(id)sender {
    
    projectComponent.wasObserved = [NSNumber numberWithBool:YES];
    [[AppModel sharedAppModel] save];
    
    UserObservationComponentData *userData = [self.saveObservationDelegate saveObservationData];
    [self.saveJudgementDelegate saveJudgementData:userData];
    
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([self.dismissDelegate respondsToSelector:@selector(dismissContainerViewAndSetProjectComponentObserved:)]) {
        [self.dismissDelegate dismissContainerViewAndSetProjectComponentObserved:projectComponent];
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
    
    
    float navAndStatusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + [self.navigationController navigationBar].frame.size.height;
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObservationData:)]];
    
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height *.75));
    
    
    NSLog(@"\nUIScreen bounds height %f - \nUIScreen bounds width %f - \nnavAndStatusBarHeight %f - \nframe %@ -\nFrame Height %f -",[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, navAndStatusBarHeight, NSStringFromCGRect(frame), self.view.frame.size.height);
    
    
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
            photoDataViewController.projectComponent = projectComponent;
            dataViewControllerToDisplay = photoDataViewController;
        }
            break;
        case DATA_NUMBER:{
            NumberDataViewController *numberDataViewController = [[NumberDataViewController alloc]init];
            numberDataViewController.view.frame = frame;
            numberDataViewController.projectComponent = projectComponent;
            dataViewControllerToDisplay = numberDataViewController;
        }
            break;
        case DATA_BOOLEAN:{
            
            BooleanDataViewController *booleanDataViewController = [[BooleanDataViewController alloc]init];
            booleanDataViewController.view.frame = frame;
            booleanDataViewController.projectComponent = projectComponent;
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
            //set up view controller here
        }
            break;
        default:
            break;
    }
    if(dataViewControllerToDisplay){
        
        self.saveObservationDelegate = (id)dataViewControllerToDisplay;
        [self addChildViewController:dataViewControllerToDisplay];
        [self didMoveToParentViewController:dataViewControllerToDisplay];
        [self.view addSubview:dataViewControllerToDisplay.view];
        
    }
    
    //seems that the second frame is not folling the same conventions as the top.
    //It doesn't seem to be 'connected'. 504 is also the number that the frame is following, suggesting that somewhere down the chain 568 (length of long ipod) is subtracting nav&status bar heights. I tried eliminating the nibs but it did nothing.
    CGRect frame2;
    
    //This is a long ipod
    if([UIScreen mainScreen].bounds.size.height - navAndStatusBarHeight == self.view.frame.size.height){
        
        frame2 = CGRectMake(0, self.view.frame.size.height * .75f, self.view.bounds.size.width, (self.view.bounds.size.height * .25f) + navAndStatusBarHeight);
    }
    //This is a normal ipod
    else{
        frame2 = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - navAndStatusBarHeight)* .75f, self.view.bounds.size.width, (self.view.bounds.size.height * .30f) + navAndStatusBarHeight);
        //* by .3 to compensate for float error.
    }

    
    NSLog(@"\nUIScreen bounds height2 %f - \nUIScreen bounds width2 %f - \nnavAndStatusBarHeight2 %f - \nframe2 %@-\nFrame Height2 %f -",[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, navAndStatusBarHeight, NSStringFromCGRect(frame2), self.view.frame.size.height);
    
    UIViewController *judgementViewControllerToDisplay;
    switch ([projectComponent.observationJudgementType intValue]) {
        case JUDGEMENT_NUMBER:{
            NumberJudgementViewController *numberJudgementViewController = [[NumberJudgementViewController alloc]init];
            numberJudgementViewController.view.frame = frame2;
            numberJudgementViewController.projectComponent = projectComponent;
            judgementViewControllerToDisplay = numberJudgementViewController;
        }
            break;
        case JUDGEMENT_BOOLEAN:{
            BooleanJudgementViewController *booleanJudgementViewController = [[BooleanJudgementViewController alloc]init];
            booleanJudgementViewController.view.frame = frame2;
            booleanJudgementViewController.projectComponent = projectComponent;
            judgementViewControllerToDisplay = booleanJudgementViewController;
        }
            break;
        case JUDGEMENT_TEXT:{
            TextJudgementViewController *textJudgementViewController = [[TextJudgementViewController alloc]init];
            textJudgementViewController.view.frame = frame2;
            judgementViewControllerToDisplay = textJudgementViewController;
        }
            break;
        case JUDGEMENT_LONG_TEXT:{
            LongTextJudgementViewController *longTextJudgementViewController = [[LongTextJudgementViewController alloc]init];
            longTextJudgementViewController.view.frame = frame2;
            judgementViewControllerToDisplay = longTextJudgementViewController;
        }
            break;
        case JUDGEMENT_ENUMERATOR:{
            EnumJudgementViewController *enumJudgementViewController = [[EnumJudgementViewController alloc]init];
            enumJudgementViewController.view.frame = frame2;
            enumJudgementViewController.view.backgroundColor = [UIColor lightGrayColor];
            enumJudgementViewController.projectComponent = projectComponent;
            judgementViewControllerToDisplay = enumJudgementViewController;
            
        }
            break;
        default:
            break;
    }
    
    if(judgementViewControllerToDisplay){
        self.saveJudgementDelegate = (id)judgementViewControllerToDisplay;
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
