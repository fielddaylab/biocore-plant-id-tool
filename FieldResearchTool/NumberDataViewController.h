//
//  NumberDataViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectComponent.h"
#import "SaveObservationAndJudgementDelegate.h"

@interface NumberDataViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *componentPossibilityDescription;
@property (weak, nonatomic) IBOutlet UIButton *changeUnitButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property ProjectComponent *projectComponent;

- (IBAction)changeUnit:(id)sender;
- (IBAction)killKeyboard:(id)sender;



@end
