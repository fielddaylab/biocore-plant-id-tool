//
//  InterpretationChoiceViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterpretationChoiceViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *projectIdentifications;
@property (nonatomic, strong) NSArray *dataToFilter;

@end
