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
#import "TextDataViewController.h"
#import "LongTextDataViewController.h"


@interface ObservationContainerViewController ()<ToggleJudgementViewDelegate, ToggleSaveButtonStateDelegate>{
    UIBarButtonItem *saveButton;
    UIViewController *dataViewControllerToDisplay;
    UIViewController *judgementViewControllerToDisplay;
    BOOL isOneToOne;
}

@end

@implementation ObservationContainerViewController
@synthesize projectComponent;
@synthesize dismissDelegate;
@synthesize saveObservationDelegate;
@synthesize saveJudgementDelegate;
@synthesize prevData;
@synthesize newObservation;

- (void)saveObservationData:(id)sender {
    
    if ([prevData.wasJudged boolValue]) {
        NSArray *judgementSet = [prevData.userObservationComponentDataJudgement allObjects];
        UserObservationComponentDataJudgement * judgement = judgementSet[0];
        [[AppModel sharedAppModel] deleteObject:judgement];
    }
    
    if (prevData) {
        [[AppModel sharedAppModel] deleteObject:prevData];
    }
    
    UserObservationComponentData *userData;
    if (!isOneToOne) {
        userData = [self.saveObservationDelegate saveObservationData];
        [self.saveJudgementDelegate saveJudgementData:userData];
    }
    else{
        userData = [self.saveJudgementDelegate saveUserDataAndJudgement];
    }
    [[AppModel sharedAppModel] save];
    
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([self.dismissDelegate respondsToSelector:@selector(dismissContainerViewAndSetProjectComponentObserved:)]) {
        [self.dismissDelegate dismissContainerViewAndSetProjectComponentObserved:userData];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(popToComponentScreen)];
    
    saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObservationData:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) * (2.0f/3.0f));
    
    NSLog(@"Frame X: %f Frame Y: %f Frame Width: %f Frame Height: %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    switch ([projectComponent.observationDataType intValue]) {
        case DATA_AUDIO:
            //set up view controller here
            break;
        case DATA_VIDEO:
            //set up view controller here
            break;
        case DATA_PHOTO:{
            PhotoDataViewController *photoDataViewController = [[PhotoDataViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height))];
            photoDataViewController.prevData = prevData;
            photoDataViewController.projectComponent = projectComponent;
            photoDataViewController.newObservation = newObservation;
            photoDataViewController.judgementDelegate = self;
            photoDataViewController.saveDelegate = self;
            dataViewControllerToDisplay = photoDataViewController;
        }
            break;
        case DATA_NUMBER:{
            NumberDataViewController *numberDataViewController = [[NumberDataViewController alloc]initWithFrame:frame];
            numberDataViewController.prevData = prevData;
            numberDataViewController.projectComponent = projectComponent;
            numberDataViewController.newObservation = newObservation;
            dataViewControllerToDisplay = numberDataViewController;
        }
            break;
        case DATA_BOOLEAN:{
            
            BooleanDataViewController *booleanDataViewController = [[BooleanDataViewController alloc]initWithFrame:frame];
            booleanDataViewController.prevData = prevData;
            booleanDataViewController.projectComponent = projectComponent;
            booleanDataViewController.newObservation = newObservation;
            dataViewControllerToDisplay = booleanDataViewController;
        }
            break;
        case DATA_TEXT:{
            TextDataViewController *textDataViewController = [[TextDataViewController alloc]initWithFrame:frame];
            textDataViewController.prevData = prevData;
            textDataViewController.projectComponent = projectComponent;
            textDataViewController.newObservation = newObservation;
            dataViewControllerToDisplay = textDataViewController;
        }
            break;
        case DATA_LONG_TEXT:{
            LongTextDataViewController *longTextDataViewController = [[LongTextDataViewController alloc] initWithFrame:frame];
            longTextDataViewController.prevData = prevData;
            longTextDataViewController.projectComponent = projectComponent;
            longTextDataViewController.newObservation = newObservation;
            dataViewControllerToDisplay = longTextDataViewController;
        }
            break;
        case DATA_ENUMERATOR:{
            //set up view controller here
        }
            break;
        default:
            break;
    }

     CGRect frame2 = CGRectMake(0, frame.size.height, self.view.frame.size.width, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) * (1.0f/3.0f));

    NSLog(@"Frame2 X: %f Frame2 Y: %f Frame2 Width: %f Frame2 Height: %f", frame2.origin.x, frame2.origin.y, frame2.size.width, frame2.size.height);
    
    switch ([projectComponent.observationJudgementType intValue]) {
        case JUDGEMENT_NUMBER:{
            NumberJudgementViewController *numberJudgementViewController = [[NumberJudgementViewController alloc]initWithFrame:frame2];
            numberJudgementViewController.prevData = prevData;
            numberJudgementViewController.projectComponent = projectComponent;
            numberJudgementViewController.isOneToOne = NO;
            judgementViewControllerToDisplay = numberJudgementViewController;
        }
            break;
        case JUDGEMENT_BOOLEAN:{
            BooleanJudgementViewController *booleanJudgementViewController = [[BooleanJudgementViewController alloc]initWithFrame:frame2];
            booleanJudgementViewController.prevData = prevData;
            booleanJudgementViewController.projectComponent = projectComponent;
            booleanJudgementViewController.isOneToOne = NO;
            judgementViewControllerToDisplay = booleanJudgementViewController;
        }
            break;
        case JUDGEMENT_TEXT:{
            TextJudgementViewController *textJudgementViewController = [[TextJudgementViewController alloc]initWithFrame:frame2];
            textJudgementViewController.projectComponent = projectComponent;
            textJudgementViewController.isOneToOne = NO;
            textJudgementViewController.prevData = prevData;
            judgementViewControllerToDisplay = textJudgementViewController;
        }
            break;
        case JUDGEMENT_LONG_TEXT:{
            LongTextJudgementViewController *longTextJudgementViewController = [[LongTextJudgementViewController alloc]initWithFrame:frame2];
            longTextJudgementViewController.projectComponent = projectComponent;
            longTextJudgementViewController.isOneToOne = NO;
            longTextJudgementViewController.prevData = prevData;
            judgementViewControllerToDisplay = longTextJudgementViewController;
        }
            break;
        case JUDGEMENT_ENUMERATOR:{
            EnumJudgementViewController *enumJudgementViewController = [[EnumJudgementViewController alloc]initWithFrame:frame2];
            enumJudgementViewController.prevData = prevData;
            enumJudgementViewController.projectComponent = projectComponent;
            enumJudgementViewController.isOneToOne = NO;
            judgementViewControllerToDisplay = enumJudgementViewController;
            
        }
            break;
        default:
            break;
    }
    
    [self pushOnViewControllers];
    [self addDataValidationTimer];
    
}

-(void)pushOnViewControllers{
    if(([dataViewControllerToDisplay isKindOfClass:[NumberDataViewController class]] && [judgementViewControllerToDisplay isKindOfClass:[NumberJudgementViewController class]])){
        NumberJudgementViewController *numberJudgementViewController = [[NumberJudgementViewController alloc]initWithFrame:self.view.bounds];
        numberJudgementViewController.prevData = prevData;
        numberJudgementViewController.projectComponent = projectComponent;
        numberJudgementViewController.isOneToOne = YES;
        isOneToOne = YES;
        judgementViewControllerToDisplay = numberJudgementViewController;
        self.saveJudgementDelegate = (id)judgementViewControllerToDisplay;
        [self addChildViewController:judgementViewControllerToDisplay];
        [self didMoveToParentViewController:judgementViewControllerToDisplay];
        [self.view addSubview:judgementViewControllerToDisplay.view];
    }
    else if(([dataViewControllerToDisplay isKindOfClass:[BooleanDataViewController class]] && [judgementViewControllerToDisplay isKindOfClass:[BooleanJudgementViewController class]])){
        BooleanJudgementViewController *booleanJudgementViewController = [[BooleanJudgementViewController alloc]initWithFrame:self.view.bounds];
        booleanJudgementViewController.prevData = prevData;
        booleanJudgementViewController.projectComponent = projectComponent;
        booleanJudgementViewController.isOneToOne = YES;
        isOneToOne = YES;
        judgementViewControllerToDisplay = booleanJudgementViewController;
        self.saveJudgementDelegate = (id)judgementViewControllerToDisplay;
        [self addChildViewController:judgementViewControllerToDisplay];
        [self didMoveToParentViewController:judgementViewControllerToDisplay];
        [self.view addSubview:judgementViewControllerToDisplay.view];
    }
    else if (([dataViewControllerToDisplay isKindOfClass:[TextDataViewController class]] && [judgementViewControllerToDisplay isKindOfClass:[TextJudgementViewController class]])){
        TextJudgementViewController *textJudgementViewController = [[TextJudgementViewController alloc] initWithFrame:self.view.bounds];
        textJudgementViewController.projectComponent = projectComponent;
        textJudgementViewController.isOneToOne = YES;
        textJudgementViewController.prevData = prevData;
        isOneToOne = YES;
        judgementViewControllerToDisplay = textJudgementViewController;
        self.saveJudgementDelegate = (id)judgementViewControllerToDisplay;
        [self addChildViewController:judgementViewControllerToDisplay];
        [self didMoveToParentViewController:judgementViewControllerToDisplay];
        [self.view addSubview:judgementViewControllerToDisplay.view];
    }
    else if (([dataViewControllerToDisplay isKindOfClass:[LongTextDataViewController class]] && [judgementViewControllerToDisplay isKindOfClass:[LongTextJudgementViewController class]])){
        LongTextJudgementViewController *longTextJudgementViewController = [[LongTextJudgementViewController alloc]initWithFrame:self.view.bounds];
        longTextJudgementViewController.projectComponent = projectComponent;
        longTextJudgementViewController.isOneToOne = YES;
        longTextJudgementViewController.prevData = prevData;
        isOneToOne = YES;
        judgementViewControllerToDisplay = longTextJudgementViewController;
        self.saveJudgementDelegate = (id)judgementViewControllerToDisplay;
        [self addChildViewController:judgementViewControllerToDisplay];
        [self didMoveToParentViewController:judgementViewControllerToDisplay];
        [self.view addSubview:judgementViewControllerToDisplay.view];
    }
    else{
        isOneToOne = NO;
        if(dataViewControllerToDisplay){
            dataViewControllerToDisplay.view.backgroundColor = [UIColor grayColor];
            self.saveObservationDelegate = (id)dataViewControllerToDisplay;
            [self addChildViewController:dataViewControllerToDisplay];
            [self didMoveToParentViewController:dataViewControllerToDisplay];
            [self.view addSubview:dataViewControllerToDisplay.view];
        }
        
        if(judgementViewControllerToDisplay){
            if([projectComponent.observationDataType intValue] == DATA_PHOTO){
                judgementViewControllerToDisplay.view.hidden = YES;
            }
            self.saveJudgementDelegate = (id)judgementViewControllerToDisplay;
            [self addChildViewController:judgementViewControllerToDisplay];
            [self didMoveToParentViewController:judgementViewControllerToDisplay];
            [self.view addSubview:judgementViewControllerToDisplay.view];
        }
    }
}

-(void)addDataValidationTimer{
    if (!isOneToOne) {
        if([dataViewControllerToDisplay isKindOfClass:[NumberDataViewController class]]){
            [NSTimer scheduledTimerWithTimeInterval:.2
                                             target:self
                                           selector:@selector(checkDataNumber)
                                           userInfo:nil
                                            repeats:YES];
        }
        else if ([judgementViewControllerToDisplay isKindOfClass:[NumberJudgementViewController class]]){
            [NSTimer scheduledTimerWithTimeInterval:.2
                                             target:self
                                           selector:@selector(checkJudgementNumber)
                                           userInfo:nil
                                            repeats:YES];
        }
        else if ([dataViewControllerToDisplay isKindOfClass:[TextDataViewController class]]){
            [NSTimer scheduledTimerWithTimeInterval:.2
                                             target:self
                                           selector:@selector(checkDataText)
                                           userInfo:nil
                                            repeats:YES];
        }
        else if ([judgementViewControllerToDisplay isKindOfClass:[TextJudgementViewController class]]){
            [NSTimer scheduledTimerWithTimeInterval:.2
                                             target:self
                                           selector:@selector(checkJudgementText)
                                           userInfo:nil
                                            repeats:YES];
        }
        else if ([dataViewControllerToDisplay isKindOfClass:[LongTextDataViewController class]]){
            [NSTimer scheduledTimerWithTimeInterval:.2
                                             target:self
                                           selector:@selector(checkDataText)
                                           userInfo:nil
                                            repeats:YES];
        }
        else if ([judgementViewControllerToDisplay isKindOfClass:[LongTextJudgementViewController class]]){
            [NSTimer scheduledTimerWithTimeInterval:.2
                                             target:self
                                           selector:@selector(checkJudgementLongText)
                                           userInfo:nil
                                            repeats:YES];
        }
        
    }
    else{
        if ([judgementViewControllerToDisplay isKindOfClass:[NumberJudgementViewController class]]){
            [NSTimer scheduledTimerWithTimeInterval:.2
                                             target:self
                                           selector:@selector(checkJudgementNumber)
                                           userInfo:nil
                                            repeats:YES];
        }
        else if ([judgementViewControllerToDisplay isKindOfClass:[TextJudgementViewController class]]){
            [NSTimer scheduledTimerWithTimeInterval:.2
                                             target:self
                                           selector:@selector(checkJudgementText)
                                           userInfo:nil
                                            repeats:YES];
        }
        else if ([judgementViewControllerToDisplay isKindOfClass:[LongTextJudgementViewController class]]){
            [NSTimer scheduledTimerWithTimeInterval:.2
                                             target:self
                                           selector:@selector(checkJudgementLongText)
                                           userInfo:nil
                                            repeats:YES];
        }
    }
}

-(void)popToComponentScreen{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkDataNumber{
    NumberDataViewController *numberDataViewController = (NumberDataViewController *)dataViewControllerToDisplay;
    NSString *dataText = numberDataViewController.numberField.text;
    NSString *regexForNumberData = @"[-+]?[0-9]*\\.?[0-9]+";
    NSPredicate *isNumberData = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForNumberData];
    if ([isNumberData evaluateWithObject: dataText]){
        saveButton.enabled = YES;
    }
    else{
        saveButton.enabled = NO;
    }
}

-(void)checkJudgementNumber{
    NumberJudgementViewController *numberJudgementViewController = (NumberJudgementViewController *)judgementViewControllerToDisplay;
    NSString *judgementText = numberJudgementViewController.numberField.text;
    NSString *regexForNumberJudgement;
    if (!isOneToOne) {
        regexForNumberJudgement = @"([-+]?[0-9]*\\.?[0-9]+)|(^$)";
    }
    else{
        regexForNumberJudgement = @"[-+]?[0-9]*\\.?[0-9]+";
    }
    
    if ([dataViewControllerToDisplay isKindOfClass:[PhotoDataViewController class]]) {
        PhotoDataViewController *photoDataViewController = (PhotoDataViewController *)dataViewControllerToDisplay;
        BOOL canSave = !photoDataViewController.redXButton.hidden;
        NSPredicate *isNumberJudgement = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForNumberJudgement];
        if ((!judgementText || [isNumberJudgement evaluateWithObject: judgementText]) && canSave){
            saveButton.enabled = YES;
        }
        else{
            saveButton.enabled = NO;
        }
    }
    else{
        NSPredicate *isNumberJudgement = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForNumberJudgement];
        if (!judgementText || [isNumberJudgement evaluateWithObject: judgementText]){
            saveButton.enabled = YES;
        }
        else{
            saveButton.enabled = NO;
        }
    }

}

-(void)checkDataText{
    TextDataViewController *textDataViewController = (TextDataViewController *)dataViewControllerToDisplay;
    NSString *dataText = textDataViewController.textField.text;
    NSString *regexForTextData = @"^(?!\\s*$).+";
    
    NSPredicate *isNumberJudgement = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForTextData];
    if ([isNumberJudgement evaluateWithObject: dataText]){
        saveButton.enabled = YES;
    }
    else{
        saveButton.enabled = NO;
    }
}

-(void)checkJudgementText{
    TextJudgementViewController *textJudgementViewController = (TextJudgementViewController *)judgementViewControllerToDisplay;
    NSString *judgementText = textJudgementViewController.textField.text;
    NSString *regexForTextJudgement;
    if (!isOneToOne) {
        regexForTextJudgement = @".*";
    }
    else{
        regexForTextJudgement = @"^(?!\\s*$).+";
    }
    
    if ([dataViewControllerToDisplay isKindOfClass:[PhotoDataViewController class]]) {
        PhotoDataViewController *photoDataViewController = (PhotoDataViewController *)dataViewControllerToDisplay;
        BOOL canSave = !photoDataViewController.redXButton.hidden;
        NSPredicate *isNumberJudgement = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForTextJudgement];
        if ((!judgementText || [isNumberJudgement evaluateWithObject: judgementText]) && canSave){
            saveButton.enabled = YES;
        }
        else{
            saveButton.enabled = NO;
        }
    }
    else{
        NSPredicate *isNumberJudgement = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForTextJudgement];
        if (!judgementText || [isNumberJudgement evaluateWithObject: judgementText]){
            saveButton.enabled = YES;
        }
        else{
            saveButton.enabled = NO;
        }
    }
    

}

-(void)checkDataLongText{
    LongTextDataViewController *longTextDataViewController = (LongTextDataViewController *)dataViewControllerToDisplay;
    NSString *dataText = longTextDataViewController.textField.text;
    NSString *regexForTextJudgement = @"^(?!\\s*$).+";
    NSPredicate *isNumberJudgement = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForTextJudgement];
    if ([isNumberJudgement evaluateWithObject: dataText]){
        saveButton.enabled = YES;
    }
    else{
        saveButton.enabled = NO;
    }
}

-(void)checkJudgementLongText{
    LongTextJudgementViewController *textJudgementViewController = (LongTextJudgementViewController *)judgementViewControllerToDisplay;
    NSString *judgementText = textJudgementViewController.textField.text;
    NSString *regexForTextJudgement;
    if (!isOneToOne) {
        regexForTextJudgement = @".*";
    }
    else{
        regexForTextJudgement = @"^(?!\\s*$).+";
    }
    
    if ([dataViewControllerToDisplay isKindOfClass:[PhotoDataViewController class]]) {
        PhotoDataViewController *photoDataViewController = (PhotoDataViewController *)dataViewControllerToDisplay;
        BOOL canSave = !photoDataViewController.redXButton.hidden;
        NSPredicate *isNumberJudgement = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForTextJudgement];
        if ((!judgementText || [isNumberJudgement evaluateWithObject: judgementText]) && canSave){
            saveButton.enabled = YES;
        }
        else{
            saveButton.enabled = NO;
        }
    }
    else{
        NSPredicate *isNumberJudgement = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForTextJudgement];
        if (!judgementText || [isNumberJudgement evaluateWithObject: judgementText]){
            saveButton.enabled = YES;
        }
        else{
            saveButton.enabled = NO;
        }
    }
    

}

#pragma mark toggle judgement view controller
-(void)enableJudgementView{
    judgementViewControllerToDisplay.view.hidden = NO;
}

-(void)disableJudgementView{
    judgementViewControllerToDisplay.view.hidden = YES;
}

#pragma mark toggle save button
-(void)enableSaveButton{
    saveButton.enabled = YES;
}

-(void)disableSaveButton{
    saveButton.enabled = NO;
}

@end
