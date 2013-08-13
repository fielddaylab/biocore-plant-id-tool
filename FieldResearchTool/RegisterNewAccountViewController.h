//
//  RegisterNewAccountViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/13/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterNewAccountViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

-(id)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UITableView *table;

@end