//
//  NumberJudgementViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectComponent.h"

@interface NumberJudgementViewController : UIViewController

@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) ProjectComponent *projectComponent;
@property (nonatomic, strong) UserObservationComponentData *prevData;
@property (nonatomic) BOOL isOneToOne;

-(id)initWithFrame:(CGRect)frame;

@end
