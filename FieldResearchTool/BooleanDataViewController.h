//
//  BooleanDataViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObservationComponentData.h"

@interface BooleanDataViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *componentPossibilityDescription;
@property (strong, nonatomic) IBOutlet UISwitch *boolSwitch;

@end
