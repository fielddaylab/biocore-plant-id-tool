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
#import "MediaManager.h"

#define KEYBOARD_OFFSET 110

@interface NumberJudgementViewController ()<UITextFieldDelegate, SaveJudgementDelegate>{
    UITextField *numberField;
    NSArray *possibilities;
    CGRect viewRect;
    UIImageView *imageView;
}

@end

@implementation NumberJudgementViewController
@synthesize numberField;
@synthesize projectComponent;
@synthesize prevData;
@synthesize isOneToOne;


-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    viewRect = frame;
    return self;
}

-(void)loadView{
    [super loadView];
 /*   if (!isOneToOne) {
        [self.view addSubview:[[UIImageView alloc] initWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"carouselBackground"]]];
    }
    else{ */
        self.view.backgroundColor = [UIColor lightGrayColor];
   // }
    
    UITextView *descriptionTextField = [[UITextView alloc]initWithFrame:CGRectMake(0, viewRect.size.height * .02, viewRect.size.width, 60)];
    descriptionTextField.backgroundColor = [UIColor clearColor];
    descriptionTextField.textAlignment = NSTextAlignmentCenter;
    descriptionTextField.font = [descriptionTextField.font fontWithSize:16];
    
    descriptionTextField.editable = NO;
    
    if ([projectComponent.prompt isEqualToString:@""]) {
        descriptionTextField.text = [NSString stringWithFormat:@"Enter a number for %@.", projectComponent.title];
    }
    else{
        descriptionTextField.text = projectComponent.prompt;
    }
    
    descriptionTextField.tag = 2;
    [self.view addSubview:descriptionTextField];
    
    numberField = [[UITextField alloc] init];
    if (!isOneToOne) {
        numberField.frame = CGRectMake(viewRect.size.width *.5, viewRect.size.height * .5 - 10, viewRect.size.width *.45, 40);
    }
    else{
        numberField.frame = CGRectMake(viewRect.size.width * .5, descriptionTextField.frame.size.height + 30, viewRect.size.width * .45, 40);
    }
    
    numberField.borderStyle = UITextBorderStyleRoundedRect;
    numberField.font = [UIFont systemFontOfSize:15];
    numberField.placeholder = @"enter number";
    numberField.autocorrectionType = UITextAutocorrectionTypeNo;
    numberField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    numberField.returnKeyType = UIReturnKeyDone;
    numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberField.delegate = self;
    [self.view addSubview:numberField];
    
    NSString *tutorialImageString = projectComponent.title;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    tutorialImageString = [[tutorialImageString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
    tutorialImageString = [tutorialImageString stringByAppendingString:@"_TutorialSmall"];
    
    imageView = [[UIImageView alloc]initWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"test.png"]];
    if (!isOneToOne) {
        imageView.frame = CGRectMake(-75, 10, viewRect.size.width, viewRect.size.height);
        imageView.image = [[MediaManager sharedMediaManager] imageWithImage:[[MediaManager sharedMediaManager] getImageNamed:tutorialImageString] scaledToSize:CGRectMake(0, 0, viewRect.size.height *.7, viewRect.size.height *.7).size];
    }
    else{
        imageView.frame = CGRectMake(viewRect.size.width * .05, numberField.frame.origin.y, 100, 100);
        imageView.image = [[MediaManager sharedMediaManager] imageWithImage:[[MediaManager sharedMediaManager] getImageNamed:tutorialImageString] scaledToSize:CGRectMake(0, 0, 100, 100).size];
    }

    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.frame = viewRect;
    // register for keyboard notifications
    if (!isOneToOne) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    else{
        [numberField becomeFirstResponder];
    }

    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    NSLog(@"Project Component.title: %@", projectComponent.title);
    [attributes setObject:projectComponent.title forKey:@"projectComponent.title"];
    [[AppModel sharedAppModel] getProjectComponentPossibilitiesWithAttributes:attributes withHandler:@selector(handlePossibilityResponse:) target:self];
    
    if (prevData) {
        if ([prevData.wasJudged boolValue]) {
            NSArray *judgementSet = [prevData.userObservationComponentDataJudgement allObjects];
            if(!judgementSet || judgementSet.count < 1){
                NSLog(@"ERROR: Judgement set was nil or had 0 data members");
            }
            UserObservationComponentDataJudgement *judgement = [judgementSet objectAtIndex:0];
            if(!judgement){
                NSLog(@"ERROR: judgement was nil");
            }
            NSNumber *storedNumber = judgement.number;
            numberField.text = [storedNumber stringValue];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!isOneToOne) {
        // unregister for keyboard notifications while not visible.
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!isOneToOne) {
        [textField resignFirstResponder];
        [self setViewMovedUp:NO];
    }
    

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
        if  (self.view.frame.origin.y >= 0 && !isOneToOne)
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




#pragma mark handle possibility response
-(void)handlePossibilityResponse:(NSArray *)componentPossibilities{
    possibilities = componentPossibilities;
}

#pragma mark save judgement data
-(UserObservationComponentDataJudgement *)saveJudgementData:(UserObservationComponentData *)userData{
    if(!userData){
        NSLog(@"ERROR: Observation data passed in was nil");
        return nil;
    }
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    
    NSString *text = numberField.text;
    if (text == nil || [text isEqualToString:@""]) {
        NSLog(@"No Judgement was made. Returning nil");
        return nil;
    }
    float numberToSave = [text floatValue];
    [attributes setObject:[NSNumber numberWithFloat:numberToSave] forKey:@"number"];
    UserObservationComponentDataJudgement *judgement = [[AppModel sharedAppModel] createNewJudgementWithData:userData withProjectComponentPossibility:nil withAttributes:attributes];
    return judgement;
}

-(UserObservationComponentData *)saveUserDataAndJudgement{
    NSString *text = numberField.text;
    float numberToSave = [text floatValue];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    [attributes setObject:[NSNumber numberWithFloat:numberToSave] forKey:@"number"];
    [attributes setObject:projectComponent forKey:@"projectComponent"];
    UserObservationComponentData *data = [[AppModel sharedAppModel] createNewObservationDataWithAttributes:attributes];
    
    NSMutableDictionary *judgementAttributes = [[NSMutableDictionary alloc]init];
    [judgementAttributes setObject:[NSDate date] forKey:@"created"];
    [judgementAttributes setObject:[NSDate date] forKey:@"updated"];
    [judgementAttributes setObject:[NSNumber numberWithFloat:numberToSave] forKey:@"number"];
    [[AppModel sharedAppModel] createNewJudgementWithData:data withProjectComponentPossibility:nil withAttributes:judgementAttributes];
    return data;
}

@end


