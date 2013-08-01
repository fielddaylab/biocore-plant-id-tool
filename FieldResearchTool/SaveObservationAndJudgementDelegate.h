//
//  SaveObservationAndJudgementDelegate.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/29/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObservationComponentData.h"
#import "UserObservationComponentDataJudgement.h"

@protocol SaveObservationDelegate <NSObject>

-(UserObservationComponentData *)saveObservationData;

@end

@protocol SaveJudgementDelegate <NSObject>

-(UserObservationComponentDataJudgement *)saveJudgementData:(UserObservationComponentData *)userData;

@end
