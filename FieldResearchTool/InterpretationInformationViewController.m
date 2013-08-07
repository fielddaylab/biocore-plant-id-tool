//
//  InterpretationInformationViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/2/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "InterpretationInformationViewController.h"
#import "AppModel.h"
#import "ProjectIdentificationDiscussion.h"
#import "InterpretationDiscussionViewController.h"

#define PICTURE_OFFSET 252

@interface InterpretationInformationViewController (){
    NSMutableArray *identificationInformation;
    UIScrollView *scrollGallery;
    UIScrollView *scrollView;
    UIWebView *webView;
}

@end

@implementation InterpretationInformationViewController
@synthesize identification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    identificationInformation = [[NSMutableArray alloc]init];
    
    scrollGallery = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, PICTURE_OFFSET)];
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 252)];
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, PICTURE_OFFSET, 320, [UIScreen mainScreen].bounds.size.height - 252 - 64)];//Will need to do javascript stuffs to make webview better.
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AppModel sharedAppModel] getProjectIdentificationDiscussionsWithHandler:@selector(handleDiscussionRetrieval:) target:self];
    
    //Placeholder for now. Aligns text correctly, and we'll need for later Identifying
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:nil];
    
    //Create navigation bar titles
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 14.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@\n%@", identification.alternateName, identification.title];
    self.navigationItem.titleView = label;
    
    scrollView.contentSize = CGSizeMake(320, 2000);//2000 is arbitrary here. don't do that later >.>
    
    NSString *url=@"http://www.google.com";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    webView.scrollView.scrollEnabled = NO;
    [scrollView addSubview:webView];
    
    scrollGallery.contentSize = CGSizeMake(1600, PICTURE_OFFSET);//1600 = 320*5 change later to how many pics we have.
    scrollGallery.pagingEnabled = YES;
    
    for (int i = 0; i < 5; i++) {
        UIImageView *imageGallery = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Flower_color.png"]];
        [imageGallery setFrame:CGRectMake(i * 320, 0, 320, PICTURE_OFFSET)];
        
        [scrollGallery addSubview:imageGallery];
    }
    [self.view addSubview:scrollGallery];

}

- (void) pushDiscussionViewController:(id) sender{
    //Create new button to get the tag of the tapped button.
    UIButton *button = (UIButton *) sender;
    
    InterpretationDiscussionViewController *discussionViewController = [[InterpretationDiscussionViewController alloc] initWithNibName:@"InterpretationDiscussionViewController" bundle:nil];
    
    discussionViewController.discussion = [identificationInformation objectAtIndex:button.tag];
    
    discussionViewController.identification = identification;
    
    [self.navigationController pushViewController:discussionViewController animated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    ProjectIdentificationDiscussion *discussion;
    
    for (int i = 0; i < identificationInformation.count; i++) {
        
        discussion = [identificationInformation objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:discussion.title forState:UIControlStateNormal];
        [button setTag:i];
        [button setFrame:CGRectMake(0, webView.bounds.size.height + 44*i, 320, 44)];//change webView bounds to some height determined by delegate javascript document.height kind of thing?
        [button addTarget:self
                   action:@selector(pushDiscussionViewController:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:button];
        
    }
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark handle the discussion retrieval
-(void)handleDiscussionRetrieval:(NSArray *)discussions{
    identificationInformation = [NSMutableArray arrayWithArray:discussions];
}


@end