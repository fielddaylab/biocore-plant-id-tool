//
//  LongTextDataViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "LongTextDataViewController.h"
#import "SaveObservationAndJudgementDelegate.h"
#import "AppModel.h"
#import "MediaManager.h"

@interface LongTextDataViewController ()<SaveObservationDelegate, UITextFieldDelegate>{
    CGRect viewRect;
    UITextField *textField;
    UIImageView *imageView;
}

@end

@implementation LongTextDataViewController
@synthesize projectComponent;
@synthesize prevData;
@synthesize newObservation;
@synthesize textField;

-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    viewRect = frame;
    return self;
}

-(void)loadView{
    [super loadView];
    
    UITextView *descriptionTextField = [[UITextView alloc]initWithFrame:CGRectMake(0, viewRect.size.height * .02, viewRect.size.width, 60)];
    descriptionTextField.backgroundColor = [UIColor clearColor];
    descriptionTextField.textAlignment = NSTextAlignmentCenter;
    descriptionTextField.font = [descriptionTextField.font fontWithSize:16];
    
    descriptionTextField.editable = NO;
    
    if ([projectComponent.prompt isEqualToString:@""]) {
        descriptionTextField.text = [NSString stringWithFormat:@"Enter a description for %@.", projectComponent.title];
    }
    else{
        descriptionTextField.text = projectComponent.prompt;
    }
    
    descriptionTextField.tag = 2;
    [self.view addSubview:descriptionTextField];

    
    textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(viewRect.size.width *.05, descriptionTextField.frame.size.height + 20, viewRect.size.width *.9, 40);
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"enter description";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [self.view addSubview:textField];
    
    imageView = [[UIImageView alloc]initWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"test.png"]];
    imageView.frame = CGRectMake(viewRect.size.width *.5 - 50, textField.frame.size.height + 60, 100, 100);
    imageView.image = [[MediaManager sharedMediaManager] imageWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"Flower_color.png"] scaledToSize:CGRectMake(0, 0, 100, 100).size];
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = viewRect;
    if (prevData) {
        NSString *storedText = prevData.longText;
        [textField setText:storedText];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self->textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark save observation data
-(UserObservationComponentData *)saveObservationData{
    //get the text here
    NSString *text = textField.text;
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    [attributes setObject:text forKey:@"longText"];
    [attributes setObject:projectComponent forKey:@"projectComponent"];
    UserObservationComponentData *data = [[AppModel sharedAppModel] createNewObservationDataWithAttributes:attributes];
    return data;
}

@end
