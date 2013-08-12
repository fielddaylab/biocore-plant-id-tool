//
//  LongTextJudgementViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectComponent.h"

@interface LongTextJudgementViewController : UIViewController

@property (nonatomic, strong) ProjectComponent *projectComponent;
@property (nonatomic) BOOL isOneToOne;
@property (nonatomic, strong) UITextField *textField;

-(id)initWithFrame:(CGRect)frame;

@end
