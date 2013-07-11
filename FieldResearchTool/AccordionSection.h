//
//  AccordionSection.h
//  FieldResearchTool
//
//  Created by Phil Dougherty on 7/11/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccordionControllerVCProtocol.h"

@class AccordionSection;
@protocol AccordionSectionDelegate
- (void) accordionSectionWasSelected:(AccordionSection *)a;
@end

@interface AccordionSection : NSObject
{
    UIView *view;
    UIViewController <AccordionControllerVCProtocol>*viewController;
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIViewController <AccordionControllerVCProtocol>*viewController;

- (id) initWithFrame:(CGRect)frame viewController:(UIViewController <AccordionControllerVCProtocol>*)vc delegate:(id<AccordionSectionDelegate>)d;
- (void) collapse;
- (void) expandToHeight:(float)h;

@end
