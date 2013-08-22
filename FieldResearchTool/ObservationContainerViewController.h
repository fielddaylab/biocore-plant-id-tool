//
//  ObservationContainerViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/24/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectComponent.h"
#import "SaveObservationAndJudgementDelegate.h"
#import "UserObservationComponentData.h"

@protocol ObservationContainerViewControllerDelegate <NSObject>

- (void)dismissContainerViewAndSetProjectComponentObserved:(UserObservationComponentData *)data;

@end

@interface ObservationContainerViewController : UIViewController

@property (strong, nonatomic) ProjectComponent *projectComponent;
@property (strong, nonatomic) UserObservationComponentData *prevData;
@property (nonatomic) BOOL newObservation;

@property (nonatomic, weak) id<ObservationContainerViewControllerDelegate> dismissDelegate;
@property (nonatomic, weak) id<SaveObservationDelegate> saveObservationDelegate;
@property (nonatomic, weak) id<SaveJudgementDelegate> saveJudgementDelegate;
@property (nonatomic, weak) id<PhotoNextButtonWasPressed> nextDelegate;

@end

