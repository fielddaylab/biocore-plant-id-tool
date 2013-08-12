//
//  LongTextDataViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectComponent.h"
#import "UserObservationComponentData.h"

@interface LongTextDataViewController : UIViewController

@property (nonatomic, strong) ProjectComponent *projectComponent;
@property (nonatomic, strong) UserObservationComponentData *prevData;
@property (nonatomic) BOOL newObservation;
@property (nonatomic, strong) UITextField *textField;

-(id)initWithFrame:(CGRect)frame;

@end
