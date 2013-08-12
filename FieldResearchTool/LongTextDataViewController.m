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
    
    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewRect.size.height * .04, viewRect.size.width, 22)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [descriptionLabel.font fontWithSize:20];
    descriptionLabel.text = [NSString stringWithFormat:@"Is %@ ?", projectComponent.title];
    descriptionLabel.tag = 2;
    [self.view addSubview:descriptionLabel];
    
    textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(viewRect.size.width *.05, descriptionLabel.frame.size.height + 20, viewRect.size.width *.9, 40);
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
