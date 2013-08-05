//
//  NumberJudgementViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "NumberJudgementViewController.h"
#import "SaveObservationAndJudgementDelegate.h"
#import "AppModel.h"
#import "ProjectComponentPossibility.h"

#define KEYBOARD_OFFSET 90

@interface NumberJudgementViewController ()<UITextFieldDelegate, SaveJudgementDelegate>{
    UITextField *numberField;
    NSArray *possibilities;
}

@end

@implementation NumberJudgementViewController
@synthesize numberField;

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
        
    numberField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    numberField.borderStyle = UITextBorderStyleRoundedRect;
    numberField.font = [UIFont systemFontOfSize:15];
    numberField.placeholder = @"enter number";
    numberField.autocorrectionType = UITextAutocorrectionTypeNo;
    numberField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;//UIKeyboardTypeNumberPad;
    numberField.returnKeyType = UIReturnKeyDone;
    numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberField.delegate = self;
    [self.view addSubview:numberField];
    [self setViewMovedUp:NO];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self setViewMovedUp:NO];

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    
        [self setViewMovedUp:NO];

}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:numberField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= KEYBOARD_OFFSET;
        rect.size.height += KEYBOARD_OFFSET;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += KEYBOARD_OFFSET;
        rect.size.height -= KEYBOARD_OFFSET;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
//    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//    NSLog(@"Project Component.title: %@", projectComponent.title);
//    [attributes setObject:projectComponent.title forKey:@"projectComponent.title"];
//    [[AppModel sharedAppModel] getProjectComponentPossibilitiesWithAttributes:attributes withHandler:@selector(handlePossibilityResponse:) target:self];
    
//    if([projectComponent.wasJudged boolValue]){
//        NSArray *dataSet = [projectComponent.userObservationComponentData allObjects];
//        if(!dataSet || dataSet.count < 1){
//            NSLog(@"ERROR: Data set was nil or had 0 data members");
//        }
//        UserObservationComponentData *data = [dataSet objectAtIndex:0];
//        if(!data){
//            NSLog(@"ERROR: data was nil");
//        }
//        NSArray *judgementSet = [data.userObservationComponentDataJudgement allObjects];
//        if(!judgementSet || judgementSet.count < 1){
//            NSLog(@"ERROR: Judgement set was nil or had 0 data members");
//        }
//        UserObservationComponentDataJudgement *judgement = [judgementSet objectAtIndex:0];
//        if(!judgement){
//            NSLog(@"ERROR: judgement was nil");
//        }
//        NSNumber *storedNumber = judgement.number;
//        numberField.text = [storedNumber stringValue];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark handle possibility response
-(void)handlePossibilityResponse:(NSArray *)componentPossibilities{
    possibilities = componentPossibilities;
}

#pragma mark save judgement data
-(UserObservationComponentDataJudgement *)saveJudgementData:(UserObservationComponentData *)userData{
//    if(!userData){
//        NSLog(@"ERROR: Observation data passed in was nil");
//        return nil;
//    }
//    
//    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//    [attributes setObject:[NSDate date] forKey:@"created"];
//    [attributes setObject:[NSDate date] forKey:@"updated"];
//    
//    NSString *text = numberField.text;
//    NSString *regexForNumber = @"[-+]?[0-9]*\\.?[0-9]*";
//    
//    NSPredicate *isNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForNumber];
//    
//    if ([isNumber evaluateWithObject: text]){
//        float numberToSave = [text floatValue];
//        [attributes setObject:[NSNumber numberWithFloat:numberToSave] forKey:@"number"];
//        UserObservationComponentDataJudgement *judgement = [[AppModel sharedAppModel] createNewJudgementWithData:userData withProjectComponentPossibility:possibilities withAttributes:attributes];
//        return judgement;
//    }
//    else if (text == nil){
//        NSLog(@"Not creating judgement because there wasn't any judgement entered. Returning nil");
//        return nil;
//    }
//    else{
//        NSLog(@"ERROR: Number entered was not of valid format!. Returning nil");
//        return nil;
//    }
    
    NSLog(@"NUMBER NOT IMPLEMENTED");
    return nil;
}

@end


