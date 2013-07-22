//
//  ObservationNumberViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectComponent.h"

@interface ObservationNumberViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *componentPossibilityDescription;
- (IBAction)changeUnit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeUnitButton;
- (IBAction)killKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property ProjectComponent *projectComponent;

@end
