//
//  AccordionSection.m
//  FieldResearchTool
//
//  Created by Phil Dougherty on 7/11/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "AccordionSection.h"

@interface AccordionSection()
{
    id<AccordionSectionDelegate> __unsafe_unretained delegate;
}
@end

@implementation AccordionSection

@synthesize view;
@synthesize viewController;

- (id) initWithFrame:(CGRect)frame viewController:(UIViewController <AccordionControllerVCProtocol>*)vc delegate:(id<AccordionSectionDelegate>)d
{
    if(self = [super init])
    {
        self.view = [[UIView alloc] initWithFrame:frame];
        self.viewController = vc;
        delegate = d;
    }
    return self;
}

- (void) collapse
{
    
}

- (void) expandToHeight:(float)h
{
    
}

@end
