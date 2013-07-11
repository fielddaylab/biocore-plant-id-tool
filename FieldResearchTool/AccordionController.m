//
//  AccordionController.m
//  FieldResearchTool
//
//  Created by Phil Dougherty on 7/11/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#define ACCORDION_SECTION_HEADER_HEIGHT 33
#import "AccordionController.h"
#import "AccordionSection.h"

@interface AccordionController() <AccordionSectionDelegate>
{
    NSArray *accordionSections;
}

@end

@implementation AccordionController

- (id) initWithViewControllers:(NSArray *)vcs
{
    if(self = [super init])
    {
        NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:[vcs count]];
        for(int i = 0; i < [vcs count]; i++)
            [mutableSections addObject:[[AccordionSection alloc] initWithFrame:CGRectMake(0,ACCORDION_SECTION_HEADER_HEIGHT*i,[UIScreen mainScreen].bounds.size.width,ACCORDION_SECTION_HEADER_HEIGHT)
                                                                viewController:(UIViewController <AccordionControllerVCProtocol>*)[vcs objectAtIndex:i]
                                                                      delegate:self]];
        accordionSections = [mutableSections copy]; //won't actually copy- simple trick to safely return immutable array
    }
    return self;
}

- (void) loadView
{
    //Frame will need to get set in viewWillAppear:
    // http://stackoverflow.com/questions/11305818/create-view-in-load-view-and-set-its-frame-but-frame-auto-changes
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    for(int i = 0; i < [accordionSections count]; i++)
    {
        AccordionSection *asv = ((AccordionSection *)[accordionSections objectAtIndex:i]);
        [self.view addSubview:asv.view];
        [self addChildViewController:asv.viewController];
        [asv.viewController didMoveToParentViewController:self];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void) accordionSectionWasSelected:(AccordionSection *)a
{
    
}

@end
