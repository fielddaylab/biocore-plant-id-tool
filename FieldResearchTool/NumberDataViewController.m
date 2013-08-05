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

@interface NumberDataViewController ()<SaveObservationDelegate, UITextFieldDelegate>{
    int unitCount;
}

@end

@implementation NumberDataViewController

@synthesize componentPossibilityDescription;
@synthesize changeUnitButton;
@synthesize textField;

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
    
    [changeUnitButton setTitle:@"cm" forState:UIControlStateNormal];
    unitCount = 0;
}

-(void)viewWillAppear:(BOOL)animated{
//    if([projectComponent.wasObserved boolValue]){
//        NSArray *dataSet = [projectComponent.userObservationComponentData allObjects];
//        if(!dataSet || dataSet.count < 1){
//            NSLog(@"ERROR: dataSet is nil or has no objects");
//        }
//        UserObservationComponentData *prevData = [dataSet objectAtIndex:0];
//        if(!prevData){
//            NSLog(@"ERROR: prevData was nil");
//        }
//        NSNumber *storedNumber = prevData.number;
//        textField.text = [storedNumber stringValue];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)changeUnit:(id)sender {
    unitCount ++;
    if(unitCount % 2 == 0){
        [changeUnitButton setTitle:@"cm" forState:UIControlStateNormal];
    }
    else if(unitCount % 2 == 1){
        [changeUnitButton setTitle:@"inches" forState:UIControlStateNormal];
    }
}
- (IBAction)killKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(UserObservationComponentData *)saveObservationData{
//    NSString *text = textField.text;
//    
//    NSString *regexForNumber = @"[-+]?[0-9]*\\.?[0-9]+";
//    
//    NSPredicate *isNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForNumber];
//    
//    if ([isNumber evaluateWithObject: text]){
//        float numberToSave = [text floatValue];
//        NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
//        [attributes setObject:[NSDate date] forKey:@"created"];
//        [attributes setObject:[NSDate date] forKey:@"updated"];
//        [attributes setObject:[NSNumber numberWithFloat:numberToSave] forKey:@"number"];
//        [attributes setObject:projectComponent forKey:@"projectComponent"];
//        UserObservationComponentData *data = [[AppModel sharedAppModel] createNewObservationDataWithAttributes:attributes];
//        return data;
//    }
//    else{
//        NSLog(@"ERROR: Number is not of valid format. Returning nil.");
//        return nil;
//    }
    NSLog(@"NUMBER NOT IMPLEMENTED");
    return nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self killKeyboard:self.textField];
    return YES;
}


@end