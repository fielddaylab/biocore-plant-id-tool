//
//  InterpretationInformationViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/2/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectIdentification.h"

@interface InterpretationInformationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) ProjectIdentification *identification;

@end
