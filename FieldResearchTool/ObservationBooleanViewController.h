//
//  ObservationBooleanViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectComponent.h"

@interface ObservationBooleanViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *componentPossibilityDescription;
@property (strong, nonatomic) ProjectComponent *projectComponent;
@property (strong, nonatomic) IBOutlet UISwitch *boolSwitch;

@end
