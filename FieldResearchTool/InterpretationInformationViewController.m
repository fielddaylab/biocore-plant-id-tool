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

@end

@implementation InterpretationInformationViewController
@synthesize identification;
@synthesize delegate;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		identificationInformation = [[NSMutableArray alloc] init];
	}

	return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	[[AppModel sharedAppModel] getProjectIdentificationDiscussionsWithHandler:@selector(handleDiscussionRetrieval:) target:self];

	//Placeholder for now. Aligns text correctly, and we'll need for later Identifying
	NSArray *userIdentificationSet = [[AppModel sharedAppModel].currentUserObservation.userObservationIdentifications allObjects];
	if(userIdentificationSet.count < 1)
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ID" style:UIBarButtonItemStyleDone target:self action:@selector(makeIdentification)];
	else
	{
		UserObservationIdentification *userIdentification = [userIdentificationSet objectAtIndex:0];
		ProjectIdentification *idToCompare = userIdentification.projectIdentification;
		if([idToCompare.title isEqualToString:identification.title])
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"UN-ID" style:UIBarButtonSystemItemTrash target:self action:@selector(removeUserObservationIdentification)];
		else
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ID" style:UIBarButtonItemStyleDone target:self action:@selector(makeIdentification)];
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

	webView = [[UIWebView alloc]    initWithFrame:CGRectMake(0,              0, 320, [UIScreen mainScreen].bounds.size.height - PICTURE_OFFSET - 64)];
	webView.delegate = self;
	webView.scrollView.scrollEnabled = NO;
	webView.opaque = NO;
	webView.backgroundColor = [UIColor clearColor];
	[webView loadHTMLString:[NSString stringWithFormat:@"<html><div id='Description' style=\"font-family:'helvetica neue';\">%@</div></html>", identification.identificationDescription] baseURL:nil];

	NSMutableArray *mediaArray = [NSMutableArray arrayWithArray:[identification.media allObjects]];

	scrollGallery = [[UIScrollView alloc] initWithFrame:CGRectMake(0,              0, 320, PICTURE_OFFSET)];
	scrollGallery.contentSize = CGSizeMake(320 * [mediaArray count], PICTURE_OFFSET);
	scrollGallery.delegate = self;
	scrollGallery.pagingEnabled = YES;
	[scrollGallery setShowsHorizontalScrollIndicator:NO];

	for(int i = 0; i < [mediaArray count]; i++)
	{
		Media *mediaObject = mediaArray[i];
		UIImageView *imageGallery;

		if([mediaObject.mediaURL isEqualToString:@""])
		{
			UIImage *defaultImage = [[MediaManager sharedMediaManager] getImageNamed:@"defaultIdentificationNoPhoto.png"];
			imageGallery = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, PICTURE_OFFSET)];
			imageGallery.image = defaultImage;
		}
		else
		{
			UIImage *image = [[MediaManager sharedMediaManager] getImageNamed:[NSString stringWithFormat:@"%@.jpg",mediaObject.mediaURL]];
			imageGallery = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, PICTURE_OFFSET)];
			imageGallery.image = image;
		}

		[scrollGallery addSubview:imageGallery];
	}

	[self.view addSubview:scrollGallery];

	if(mediaArray.count > 1)
	{
		pageControl = [[UIPageControl alloc]init];
		pageControl.frame = CGRectMake((scrollGallery.frame.size.width / 2.0f) - (mediaArray.count * 10.0f / 2.0f), scrollGallery.frame.size.height - 10, (mediaArray.count * 10.0f), 5.0f);
		pageControl.numberOfPages = mediaArray.count;
		pageControl.currentPage = 0;
		[self.view addSubview:pageControl];
	}

	NSLog(@"INFORMATION VC ViewDidLoad");


}

- (void) webViewDidFinishLoad:(UIWebView *)webViewThatLoaded
{
	NSString *output = [webViewThatLoaded stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"Description\").offsetHeight;"];
	NSLog(@"height: %@", output);
	int webViewHeight;
	webViewHeight = 15;//initialize to 15 because there is a slight offset with HTML
	webViewHeight += [output intValue];
	webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, webViewHeight);

	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, PICTURE_OFFSET, 320, [UIScreen mainScreen].bounds.size.height - PICTURE_OFFSET - 64)];
	[identificationInformation sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
	ProjectIdentificationDiscussion *discussion;
	int heightOfAllButtons = 0;
	for (int i = 0; i < identificationInformation.count; i++)
	{
		discussion = [identificationInformation objectAtIndex:i];

		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button setTitle:discussion.title forState:UIControlStateNormal];
		[button setTag:i];
		[button setFrame:CGRectMake(0, webViewHeight + 44*i, 320, 44)];//change webView bounds to some height determined by delegate javascript document.height kind of thing?
		[button addTarget:self action:@selector(pushDiscussionViewController:) forControlEvents:UIControlEventTouchUpInside];

		[scrollView addSubview:button];
		heightOfAllButtons += 44;
	}

	scrollView.contentSize = CGSizeMake(320, webView.frame.size.height + heightOfAllButtons);
	[scrollView addSubview:webView];
	[self.view addSubview:scrollView];
}

- (void) pushDiscussionViewController:(id)sender
{
	UIButton *button = (UIButton *)sender;
	InterpretationDiscussionViewController *discussionViewController = [[InterpretationDiscussionViewController alloc] initWithNibName:@"InterpretationDiscussionViewController" bundle:nil];
	discussionViewController.discussion = [identificationInformation objectAtIndex:button.tag];
	discussionViewController.identification = identification;
	[self.navigationController pushViewController:discussionViewController animated:YES];
}

- (void) dealloc
{
	webView.delegate = nil;
	scrollGallery.delegate = nil;
	scrollView.delegate = nil;
}

#pragma mark handle the discussion retrieval
- (void) handleDiscussionRetrieval:(NSArray *)discussions
{
	identificationInformation = [NSMutableArray arrayWithArray:discussions];
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
	CGFloat pageWidth = scrollGallery.frame.size.width;
	float fractionalPage = scrollGallery.contentOffset.x / pageWidth;
	NSInteger page = lround(fractionalPage);
	pageControl.currentPage = page;
}

@end
