//
//  RootViewController.m
//  FieldResearchTool
//
//  Created by Phil Dougherty on 7/11/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "RootViewController.h"
#import "FieldResearchNavigationController.h"
#import "AppModel.h"

#import "LoginViewController.h"


@interface RootViewController ()
{
    UIViewController *currentChildViewController;
}

- (void) displayContentController:(UIViewController*)content;

@property (nonatomic, strong) FieldResearchNavigationController *observationController;

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
    
    LoginViewController *loginViewController = [[LoginViewController alloc]initWithFrame:self.view.bounds];
    self.observationController = [[FieldResearchNavigationController alloc]initWithRootViewController:loginViewController];
    [self displayContentController:self.observationController];

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

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else {
        return [currentChildViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
}

- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSInteger) supportedInterfaceOrientations
{
    //lock the orientation for now into portrait. simply uncomment to ask the child view controllers their orientation
    //return [currentChildViewController supportedInterfaceOrientations];
    return UIInterfaceOrientationMaskPortrait;
}

@end
