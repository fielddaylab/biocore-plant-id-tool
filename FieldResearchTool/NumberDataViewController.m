//
//  NumberDataViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "NumberDataViewController.h"
#import "AppModel.h"
#import "SaveObservationAndJudgementDelegate.h"
#import "MediaManager.h"

@interface NumberDataViewController ()<SaveObservationDelegate, UITextFieldDelegate>{
    CGRect viewRect;
    UITextField *numberField;
    UIImageView *imageView;
}

@end

@implementation NumberDataViewController

@synthesize prevData;
@synthesize projectComponent;
@synthesize newObservation;
@synthesize numberField;


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
        descriptionTextField.text = [NSString stringWithFormat:@"Enter a number for %@.", projectComponent.title];
    }
    else{
        descriptionTextField.text = projectComponent.prompt;
    }
    
    descriptionTextField.tag = 2;
    [self.view addSubview:descriptionTextField];

    
    numberField = [[UITextField alloc] init];
    numberField.frame = CGRectMake(viewRect.size.width *.05, descriptionTextField.frame.size.height + 20, viewRect.size.width *.9, 40);
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
    
    imageView = [[UIImageView alloc]initWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"test.png"]];
    imageView.frame = CGRectMake(viewRect.size.width *.5 - 50, numberField.frame.size.height + 60, 100, 100);
    
    NSString *tutorialLargeString = projectComponent.title;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    tutorialLargeString = [[tutorialLargeString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
    tutorialLargeString = [tutorialLargeString stringByAppendingString:@"@_TutorialLarge"];
    
    imageView.image = [[MediaManager sharedMediaManager] imageWithImage:[[MediaManager sharedMediaManager] getImageNamed:tutorialLargeString] scaledToSize:CGRectMake(0, 0, 100, 100).size];
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = viewRect;
    if (prevData) {
        NSNumber *storedNumber = prevData.number;
        [numberField setText:[storedNumber stringValue]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(UserObservationComponentData *)saveObservationData{
    //get the text here
    NSString *text = numberField.text;
    float numberToSave = [text floatValue];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    [attributes setObject:[NSNumber numberWithFloat:numberToSave] forKey:@"number"];
    [attributes setObject:projectComponent forKey:@"projectComponent"];
    UserObservationComponentData *data = [[AppModel sharedAppModel] createNewObservationDataWithAttributes:attributes];
    return data;
}

@end