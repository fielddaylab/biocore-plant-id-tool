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

@interface InterpretationInformationViewController() <UIScrollViewDelegate>
{
	NSMutableArray *identificationInformation;
	UIScrollView *scrollGallery;
	UIScrollView *scrollView;
	UIWebView *webView;
	UIPageControl *pageControl;
}

@property (nonatomic, strong) NSMutableArray *identificationInformation;
@property (nonatomic, strong) UIScrollView *scrollGallery;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation InterpretationInformationViewController

@synthesize identificationInformation;
@synthesize scrollGallery;
@synthesize scrollView;
@synthesize webView;
@synthesize pageControl;

@synthesize identification;
@synthesize delegate;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		self.identificationInformation = [[NSMutableArray alloc] init];
	}

	return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
    
	[[AppModel sharedAppModel] getProjectIdentificationDiscussionsWithHandler:@selector(handleDiscussionRetrieval:) target:self];

	NSArray *userIdentificationSet = [[AppModel sharedAppModel].currentUserObservation.userObservationIdentifications allObjects];
	if(userIdentificationSet.count < 1)
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ID" style:UIBarButtonItemStyleDone target:self action:@selector(makeIdentification)];
	else
	{
		UserObservationIdentification *userIdentification = [userIdentificationSet objectAtIndex:0];
		if([userIdentification.projectIdentification.title isEqualToString:self.identification.title])
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"UN-ID" style:UIBarButtonSystemItemTrash target:self action:@selector(removeUserObservationIdentification)];
		else
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ID" style:UIBarButtonItemStyleDone target:self action:@selector(makeIdentification)];
	}

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
	label.backgroundColor = [UIColor clearColor];
	label.numberOfLines = 2;
	label.font = [UIFont boldSystemFontOfSize: 14.0f];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.text = [NSString stringWithFormat:@"%@\n%@", self.identification.alternateName, self.identification.title];
	self.navigationItem.titleView = label;

	self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].bounds.size.height-PICTURE_OFFSET-64)];
	self.webView.backgroundColor = [UIColor clearColor];
	self.webView.scrollView.scrollEnabled = NO;
	self.webView.opaque = NO;
	self.webView.delegate = self;
	[self.webView loadHTMLString:[NSString stringWithFormat:@"<html><div id='Description' style=\"font-family:'helvetica neue';\">%@</div></html>", self.identification.identificationDescription] baseURL:nil];

	NSMutableArray *mediaArray = [NSMutableArray arrayWithArray:[self.identification.media allObjects]];

	self.scrollGallery = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,PICTURE_OFFSET*([UIScreen mainScreen].bounds.size.width/320))];
	self.scrollGallery.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*[mediaArray count],PICTURE_OFFSET*([UIScreen mainScreen].bounds.size.width/320));
	self.scrollGallery.delegate = self;
	self.scrollGallery.pagingEnabled = YES;
	[self.scrollGallery setShowsHorizontalScrollIndicator:NO];

	for(int i = 0; i < [mediaArray count]; i++)
	{
		Media *mediaObject = mediaArray[i];
		UIImageView *imageGallery;

		if([mediaObject.mediaURL isEqualToString:@""])
		{
            //Must use imageWithContentsOfFile because the [UIImage imageNamed] will cache the image which causes the memory a leak in memory
            NSBundle *bundle = [NSBundle bundleWithIdentifier:@"org.arisgames.FieldResearchTool"];
            NSString *imagePath = [bundle pathForResource:@"defaultIdentificationNoPhoto" ofType:@"png"];
            UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
			imageGallery = [[UIImageView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width,0,[UIScreen mainScreen].bounds.size.width,PICTURE_OFFSET*([UIScreen mainScreen].bounds.size.width/320))];
			imageGallery.image = image;
		}
		else
		{
            NSBundle *bundle = [NSBundle bundleWithIdentifier:@"org.arisgames.FieldResearchTool"];
            NSString *imagePath = [bundle pathForResource:[NSString stringWithFormat:@"%@",mediaObject.mediaURL] ofType:@"jpg"];
            UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
			imageGallery = [[UIImageView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width,0,[UIScreen mainScreen].bounds.size.width,PICTURE_OFFSET*([UIScreen mainScreen].bounds.size.width/320))];
			imageGallery.image = image;
		}

		[self.scrollGallery addSubview:imageGallery];
	}

	[self.view addSubview:self.scrollGallery];

	if(mediaArray.count > 1)
	{
		self.pageControl = [[UIPageControl alloc]init];
		self.pageControl.frame = CGRectMake((self.scrollGallery.frame.size.width/2.0f)-(mediaArray.count*10.0f/2.0f),self.scrollGallery.frame.size.height-10,(mediaArray.count*10.0f),5.0f);
		self.pageControl.numberOfPages = mediaArray.count;
		self.pageControl.currentPage = 0;
		[self.view addSubview:self.pageControl];
	}
}

- (void) webViewDidFinishLoad:(UIWebView *)webViewThatLoaded
{
	NSString *output = [webViewThatLoaded stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"Description\").offsetHeight;"];
	NSLog(@"height: %@", output);
	int webViewHeight = 15+[output intValue];
	self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, webViewHeight);

	self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,PICTURE_OFFSET,320,[UIScreen mainScreen].bounds.size.height-PICTURE_OFFSET-64)];
	[self.identificationInformation sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
	ProjectIdentificationDiscussion *discussion;
	int heightOfAllButtons = 0;
	for(int i = 0; i < self.identificationInformation.count; i++)
	{
		discussion = [self.identificationInformation objectAtIndex:i];

		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button setTitle:discussion.title forState:UIControlStateNormal];
		[button setTag:i];
		[button setFrame:CGRectMake(0, webViewHeight + 44*i, 320, 44)];
		[button addTarget:self action:@selector(pushDiscussionViewController:) forControlEvents:UIControlEventTouchUpInside];

		[self.scrollView addSubview:button];
		heightOfAllButtons += 44;
	}

	self.scrollView.contentSize = CGSizeMake(320, self.webView.frame.size.height + heightOfAllButtons);
	[self.scrollView addSubview:self.webView];
	[self.view addSubview:self.scrollView];
}

- (void) pushDiscussionViewController:(id)sender
{
	UIButton *button = (UIButton *)sender;
	InterpretationDiscussionViewController *discussionViewController = [[InterpretationDiscussionViewController alloc] initWithNibName:@"InterpretationDiscussionViewController" bundle:nil];
	discussionViewController.discussion = [self.identificationInformation objectAtIndex:button.tag];
	discussionViewController.identification = self.identification;
	[self.navigationController pushViewController:discussionViewController animated:YES];
}

- (void) dealloc
{
    while([self.scrollGallery.subviews count] > 0)
        [(UIView *)[self.scrollGallery.subviews objectAtIndex:0] removeFromSuperview];
	self.webView.delegate = nil;
	self.scrollGallery.delegate = nil;
	self.scrollView.delegate = nil;
}

#pragma mark handle the discussion retrieval
- (void) handleDiscussionRetrieval:(NSArray *)discussions
{
	self.identificationInformation = [NSMutableArray arrayWithArray:discussions];
}

#pragma mark make identification
- (void) makeIdentification
{
	[self.delegate makeIdentification:identification];
}

- (void) removeUserObservationIdentification
{
	NSArray *userIdentificationSet = [[AppModel sharedAppModel].currentUserObservation.userObservationIdentifications allObjects];
	if (userIdentificationSet.count < 1)
	{
		NSLog(@"ERROR trying to remove user observation that doesn't exist. Not calling delegate.");
		return;
	}
	UserObservationIdentification *userIdentification = [userIdentificationSet objectAtIndex:0];
	[self.delegate removeIdentification:userIdentification];
}

#pragma mark scrollview delegate methods
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = self.scrollGallery.frame.size.width;
	float fractionalPage = self.scrollGallery.contentOffset.x / pageWidth;
	NSInteger page = lround(fractionalPage);
	self.pageControl.currentPage = page;
}

@end
