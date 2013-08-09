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
    CGRect viewRect;
}

@end

@implementation NumberDataViewController

@synthesize prevData;
@synthesize projectComponent;
@synthesize newObservation;


-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    viewRect = frame;
    return self;
}


-(void)loadView{
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = viewRect;
    self.view.backgroundColor = [UIColor lightGrayColor];
    if (prevData) {
        NSNumber *storedNumber = prevData.number;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(UserObservationComponentData *)saveObservationData{
    //get the text here
    //NSString *text = textField.text;
    NSString *text = @"";
    
    NSString *regexForNumber = @"[-+]?[0-9]*\\.?[0-9]+";
    
    NSPredicate *isNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForNumber];
    
    if ([isNumber evaluateWithObject: text]){
        float numberToSave = [text floatValue];
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
        [attributes setObject:[NSDate date] forKey:@"created"];
        [attributes setObject:[NSDate date] forKey:@"updated"];
        [attributes setObject:[NSNumber numberWithFloat:numberToSave] forKey:@"number"];
        [attributes setObject:projectComponent forKey:@"projectComponent"];
        UserObservationComponentData *data = [[AppModel sharedAppModel] createNewObservationDataWithAttributes:attributes];
        return data;
    }
    else{
        NSLog(@"ERROR: Number is not of valid format. Returning nil.");
        return nil;
    }
    return nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}


@end