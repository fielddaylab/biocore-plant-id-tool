//
//  LoginViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/12/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

-(id)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UITableView *table;

@end

