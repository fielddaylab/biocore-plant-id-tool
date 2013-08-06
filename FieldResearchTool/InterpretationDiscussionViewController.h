//
//  InterpretationDiscussionViewController.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 8/6/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectIdentificationDiscussion.h"
#import "ProjectIdentification.h"

@interface InterpretationDiscussionViewController : UIViewController

@property (nonatomic, strong) ProjectIdentificationDiscussion *discussion;
@property (nonatomic, strong) ProjectIdentification *identification;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end
