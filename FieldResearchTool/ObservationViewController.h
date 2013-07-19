//
//  ObservationViewController.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface ObservationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) Project *currentProject;

@end
