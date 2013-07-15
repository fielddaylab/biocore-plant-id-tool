//
//  FieldResearchNavigationController.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "FieldResearchNavigationController.h"

@interface FieldResearchNavigationController ()

@end

@implementation FieldResearchNavigationController

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else {
        return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
}

- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSInteger) supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end
