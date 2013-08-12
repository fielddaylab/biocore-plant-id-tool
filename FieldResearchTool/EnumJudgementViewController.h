//
//  EnumJudgementViewController.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectComponent.h"
#import "UserObservationComponentData.h"

@interface EnumJudgementViewController : UIViewController

@property (nonatomic, strong) UserObservationComponentData *prevData;
@property (nonatomic, strong) ProjectComponent *projectComponent;
@property (nonatomic) BOOL isOneToOne;

-(id)initWithFrame:(CGRect)frame;

@end
