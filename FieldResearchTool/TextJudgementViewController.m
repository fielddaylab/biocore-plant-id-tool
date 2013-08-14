//
//  TextJudgementViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "TextJudgementViewController.h"
#import "SaveObservationAndJudgementDelegate.h"
#import "AppModel.h"
#import "MediaManager.h"

#define KEYBOARD_OFFSET 90

@interface TextJudgementViewController ()<UITextFieldDelegate, SaveJudgementDelegate>{
    UITextField *textField;
    CGRect viewRect;
}

@end

@implementation TextJudgementViewController
@synthesize projectComponent;
@synthesize isOneToOne;
@synthesize textField;
@synthesize prevData;

-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    viewRect = frame;
    return self;
}

-(void)loadView{
    [super loadView];
    if (!isOneToOne) {
        [self.view addSubview:[[UIImageView alloc] initWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"carouselBackground.png"]]];
    }
    else{
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewRect.size.height * .04, viewRect.size.width, 22)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [descriptionLabel.font fontWithSize:16];
    descriptionLabel.text = [NSString stringWithFormat:@"Enter a description for %@.", projectComponent.title];//This makes me cringe.
    descriptionLabel.tag = 2;
    [self.view addSubview:descriptionLabel];
    
    textField = [[UITextField alloc] init];
    if (!isOneToOne) {
        textField.frame = CGRectMake(viewRect.size.width *.05, viewRect.size.height * .5 - 10, viewRect.size.width *.9, 40);
    }
    else{
        textField.frame = CGRectMake(viewRect.size.width *.05, descriptionLabel.frame.size.height + 30, viewRect.size.width *.9, 40);
    }
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"enter description";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;//UIKeyboardTypeNumberPad;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [self.view addSubview:textField];
}


-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = viewRect;
    if (!isOneToOne) {
        // register for keyboard notifications
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
        [textField becomeFirstResponder];
    }
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
            NSString *storedText = judgement.text;
            [textField setText:storedText];
        }
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    if (!isOneToOne) {
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
        [self->textField resignFirstResponder];
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
    if ([sender isEqual:textField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0 && !isOneToOne)
        {
            [self setViewMovedUp:YES];
        }
    }
}

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

#pragma mark save judgement data
-(UserObservationComponentDataJudgement *)saveJudgementData:(UserObservationComponentData *)userData{
    if(!userData){
        NSLog(@"ERROR: Observation data passed in was nil");
        return nil;
    }
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    
    NSString *text = textField.text;
    
    if(text == nil || [text isEqualToString:@""]){
        NSLog(@"Not creating judgement because there wasn't any judgement entered. Returning nil");
        return nil;
    }
    
    [attributes setObject:text forKey:@"text"];
    UserObservationComponentDataJudgement *judgement = [[AppModel sharedAppModel] createNewJudgementWithData:userData withProjectComponentPossibility:nil withAttributes:attributes];
    return judgement;
}

-(UserObservationComponentData *)saveUserDataAndJudgement{
    NSString *text = textField.text;
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    [attributes setObject:text forKey:@"text"];
    [attributes setObject:projectComponent forKey:@"projectComponent"];
    UserObservationComponentData *data = [[AppModel sharedAppModel] createNewObservationDataWithAttributes:attributes];
    
    NSMutableDictionary *judgementAttributes = [[NSMutableDictionary alloc]init];
    [judgementAttributes setObject:[NSDate date] forKey:@"created"];
    [judgementAttributes setObject:[NSDate date] forKey:@"updated"];
    [judgementAttributes setObject:text forKey:@"text"];
    [[AppModel sharedAppModel] createNewJudgementWithData:data withProjectComponentPossibility:nil withAttributes:judgementAttributes];
    return data;
}

@end
