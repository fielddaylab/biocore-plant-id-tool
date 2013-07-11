//
//  RootViewController.m
//  FieldResearchTool
//
//  Created by Phil Dougherty on 7/11/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
{
    UIViewController *currentChildViewController;
}

- (void) displayContentController:(UIViewController*)content;

@end

@implementation RootViewController

- (id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

- (void) loadView
{
    //Frame will need to get set in viewWillAppear:
    // http://stackoverflow.com/questions/11305818/create-view-in-load-view-and-set-its-frame-but-frame-auto-changes
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.view.frame = [UIScreen mainScreen].bounds;
}

// Container VC Functions pulled from Apple Docs 5/6/13
// http://developer.apple.com/library/ios/#featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html
- (void) displayContentController:(UIViewController*)content
{
    if(currentChildViewController) [self hideContentController:currentChildViewController];
    
    [self addChildViewController:content];
    content.view.frame = self.view.bounds;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
    
    currentChildViewController = content;
}

- (void) hideContentController:(UIViewController*)content
{
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
    
    currentChildViewController = nil;
}

- (NSInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
