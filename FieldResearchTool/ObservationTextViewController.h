//
//  ObservationTextViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObservationTextViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITextView *componentPossibilityDescription;
@property (weak, nonatomic) IBOutlet UITextView *userInput;
- (IBAction)killKeyboard:(id)sender;

@end
