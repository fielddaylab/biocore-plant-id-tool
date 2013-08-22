//
//  PhotoDataViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "ProjectComponent.h"
#import "UserObservationComponentData.h"

@protocol ToggleJudgementViewDelegate <NSObject>

-(void)enableJudgementView;
-(void)disableJudgementView;

@end

@protocol ToggleSaveButtonStateDelegate <NSObject>

-(void)enableSaveButton;
-(void)disableSaveButton;
-(void)setNextAsRightButton;

@end

@interface PhotoDataViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) ProjectComponent *projectComponent;
@property (nonatomic, strong) UserObservationComponentData *prevData;
@property (nonatomic) BOOL newObservation;
@property (nonatomic) id<ToggleJudgementViewDelegate> judgementDelegate;
@property (nonatomic) id<ToggleSaveButtonStateDelegate> saveDelegate;
@property (nonatomic, strong) UIButton *redXButton;

-(id)initWithFrame:(CGRect)frame;

@end