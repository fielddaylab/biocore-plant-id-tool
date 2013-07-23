//
//  ObservationTextViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectComponent.h"

@interface ObservationTextViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITextView *componentPossibilityDescription;
@property (weak, nonatomic) IBOutlet UITextView *userInput;
@property (strong, nonatomic) ProjectComponent *projectComponent;
- (IBAction)killKeyboard:(id)sender;

@end
