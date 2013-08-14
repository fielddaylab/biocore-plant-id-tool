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
    
    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewRect.size.height * .04, viewRect.size.width, 22)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [descriptionLabel.font fontWithSize:16];
    descriptionLabel.text = [NSString stringWithFormat:@"Enter a number for %@.", projectComponent.title];
    descriptionLabel.tag = 2;
    [self.view addSubview:descriptionLabel];
    
    numberField = [[UITextField alloc] init];
    numberField.frame = CGRectMake(viewRect.size.width *.05, descriptionLabel.frame.size.height + 20, viewRect.size.width *.9, 40);
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
    imageView.image = [[MediaManager sharedMediaManager] imageWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"Flower_color.png"] scaledToSize:CGRectMake(0, 0, 100, 100).size];
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