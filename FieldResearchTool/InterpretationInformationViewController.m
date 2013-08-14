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
#import "MediaManager.h"
#import "UserObservationIdentification.h"

#define PICTURE_OFFSET 240

@interface InterpretationInformationViewController ()<UIScrollViewDelegate>{
    NSMutableArray *identificationInformation;
    UIScrollView *scrollGallery;
    UIScrollView *scrollView;
    UIWebView *webView;
    int webViewHeight;
    UIPageControl *pageControl;
}

@end

@implementation InterpretationInformationViewController
@synthesize identification;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    identificationInformation = [[NSMutableArray alloc]init];
    
    scrollGallery = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, PICTURE_OFFSET)];
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - PICTURE_OFFSET - 64)];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, PICTURE_OFFSET, 320, [UIScreen mainScreen].bounds.size.height - PICTURE_OFFSET - 64)];//Will need to do javascript stuffs to make webview better.
    
    webViewHeight = 15;//initialize to 15 because there is a slight offset with HTML
    
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewThatLoaded
{
    NSString *output = [webViewThatLoaded stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"Description\").offsetHeight;"];
    NSLog(@"height: %@", output);
    webViewHeight += [output intValue];
    webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, webViewHeight);
    scrollView.contentSize = CGSizeMake(320, webView.frame.size.height + [self loadButtons]);
    [scrollView addSubview:webView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AppModel sharedAppModel] getProjectIdentificationDiscussionsWithHandler:@selector(handleDiscussionRetrieval:) target:self];
    
    //Placeholder for now. Aligns text correctly, and we'll need for later Identifying
    NSArray *userIdentificationSet = [[AppModel sharedAppModel].currentUserObservation.userObservationIdentifications allObjects];
    if (userIdentificationSet.count < 1) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ID" style:UIBarButtonItemStyleDone target:self action:@selector(makeIdentification)];
    }
    else{
        UserObservationIdentification *userIdentification = [userIdentificationSet objectAtIndex:0];
        ProjectIdentification *idToCompare = userIdentification.projectIdentification;
        if ([idToCompare.title isEqualToString:identification.title]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"UN-ID" style:UIBarButtonSystemItemTrash target:self action:@selector(removeUserObservationIdentification)];
        }
        else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ID" style:UIBarButtonItemStyleDone target:self action:@selector(makeIdentification)];
        }
    }
    
    
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
    
    webView.delegate = self;
    NSString *myHTML = [NSString stringWithFormat:@"<html><div id='Description'>%@</div></html>", identification.identificationDescription];
    webView.scrollView.scrollEnabled = NO;
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
    
    [webView loadHTMLString:myHTML baseURL:nil];
    
    NSMutableArray *mediaArray = [NSMutableArray arrayWithArray:[identification.media allObjects]];
    
    scrollGallery.contentSize = CGSizeMake(320 * [mediaArray count], PICTURE_OFFSET);
    scrollGallery.pagingEnabled = YES;
    [scrollGallery setShowsHorizontalScrollIndicator:NO];

    
        for (int i = 0; i < [mediaArray count]; i++) {
            
            Media *mediaObject = mediaArray[i];
            
            UIImageView *imageGallery;
            
            if ([mediaObject.mediaURL isEqualToString:@""]){
                imageGallery = [[UIImageView alloc] initWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"defaultIdentificationNoPhoto.png"]];
                [imageGallery setFrame:CGRectMake(i * 320, 0, 320, PICTURE_OFFSET)];
            }
            else{
                imageGallery = [[UIImageView alloc] initWithImage:[[MediaManager sharedMediaManager] getImageNamed:mediaObject.mediaURL]];
                [imageGallery setFrame:CGRectMake(i * 320, 0, 320, PICTURE_OFFSET)];
            }
            [scrollGallery addSubview:imageGallery];
        }

    scrollGallery.delegate = self;
    [self.view addSubview:scrollGallery];
    if (mediaArray.count > 1) {
        pageControl = [[UIPageControl alloc]init];
        pageControl.frame = CGRectMake((scrollGallery.frame.size.width / 2.0f) - (mediaArray.count * 10.0f / 2.0f), scrollGallery.frame.size.height - 10, (mediaArray.count * 10.0f), 5.0f);
        pageControl.numberOfPages = mediaArray.count;
        pageControl.currentPage = 0;
        [self.view addSubview:pageControl];
    }
    
}

- (void) pushDiscussionViewController:(id) sender{
    //Create new button to get the tag of the tapped button.
    UIButton *button = (UIButton *) sender;
    
    InterpretationDiscussionViewController *discussionViewController = [[InterpretationDiscussionViewController alloc] initWithNibName:@"InterpretationDiscussionViewController" bundle:nil];
    
    discussionViewController.discussion = [identificationInformation objectAtIndex:button.tag];
    
    discussionViewController.identification = identification;
    
    [self.navigationController pushViewController:discussionViewController animated:YES];
}

- (int)loadButtons{
    ProjectIdentificationDiscussion *discussion;
    int heightOfAllButtons = 0;
    for (int i = 0; i < identificationInformation.count; i++) {
        
        discussion = [identificationInformation objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:discussion.title forState:UIControlStateNormal];
        [button setTag:i];
        [button setFrame:CGRectMake(0, webViewHeight + 44*i, 320, 44)];//change webView bounds to some height determined by delegate javascript document.height kind of thing?
        [button addTarget:self
                   action:@selector(pushDiscussionViewController:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:button];
        heightOfAllButtons += 44;
    }
    [self.view addSubview:scrollView];
    return heightOfAllButtons;
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

#pragma mark make identification
-(void)makeIdentification{
    [self.delegate makeIdentification:identification];
}

-(void)removeUserObservationIdentification{
    NSArray *userIdentificationSet = [[AppModel sharedAppModel].currentUserObservation.userObservationIdentifications allObjects];
    if (userIdentificationSet.count < 1) {
        NSLog(@"ERROR trying to remove user observation that doesn't exist. Not calling delegate.");
        return;
    }
    UserObservationIdentification *userIdentification = [userIdentificationSet objectAtIndex:0];
    [self.delegate removeIdentification:userIdentification];
}

#pragma mark scrollview delegate methods
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = self->scrollGallery.frame.size.width;
    float fractionalPage = self->scrollGallery.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
}

@end
