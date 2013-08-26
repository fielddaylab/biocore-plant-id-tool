//
//  InterpretationInformationViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/2/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectIdentification.h"

#import "ProjectIdentification.h"

@protocol CreateUserIdentificationDelegate <NSObject>

-(void)makeIdentification:(ProjectIdentification *)projectIdentification;
-(void)removeIdentification:(UserObservationIdentification *)userIdentificationToDelete;

@end

@interface InterpretationInformationViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) ProjectIdentification *identification;
@property (nonatomic, weak) id<CreateUserIdentificationDelegate> delegate;

@end
