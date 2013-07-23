//
//  ObservationAudioViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/18/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//


#import "ObservationAudioViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "iCarousel.h"


#define HEIGHT_OF_RECORD 44

@interface ObservationAudioViewController () <iCarouselDataSource, iCarouselDelegate>{
    UIImageView *imageView;
    AVCaptureSession *captureSession;
    AVCaptureDevice *videoCaptureDevice;
    AVCaptureDeviceInput *videoInput;
    AVCaptureDevice *audioCaptureDevice;
    AVCaptureDeviceInput *audioInput;
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) iCarousel *carousel;

@end

@implementation ObservationAudioViewController

@synthesize carousel;
@synthesize items;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.items = [NSMutableArray array];
        for (int i = 0; i < 100; i++)
        {
            [items addObject:[NSNumber numberWithInt:i]];
        }
    }
    return self;
}

-(void)dealloc{
    carousel.delegate = nil;
    carousel.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObservationData)]];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - HEIGHT_OF_RECORD)];
    [self.view addSubview:imageView];
    
    carousel.type = iCarouselTypeLinear;
    
    carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height - (100 + [UIApplication sharedApplication].statusBarFrame.size.height), [UIScreen mainScreen].bounds.size.width, 100)];
    
	carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeLinear;
	carousel.delegate = self;
	carousel.dataSource = self;
    carousel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    [self.view addSubview:carousel];
    
    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(self.carousel.frame.size.width - 50, self.carousel.frame.origin.y - 50, 44, 44)];
    [recordButton setImage:[UIImage imageNamed:@"29-circle-pause"] forState:UIControlStateNormal];
    [recordButton addTarget:self action:@selector(takeVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:recordButton];
    
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.movieController stop];
    [self.movieController.view removeFromSuperview];
    self.movieController = nil;
    
}

- (IBAction)takeVideo:(UIButton *)sender {
    
    captureSession = [[AVCaptureSession alloc] init];
    
    [captureSession startRunning];
    
    videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    
    NSError *error = nil;
    videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    
    //audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    
    if (videoInput) {
        [captureSession addInput:videoInput];
        
        NSLog(@"YEAEAEA");
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
        
        UIView* aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - HEIGHT_OF_RECORD)];
        
        
        
        previewLayer.frame = aView.bounds; // Assume you want the preview layer to fill the view.
        [aView.layer addSublayer:previewLayer];
        [imageView addSubview:aView];
        
        CGRect bounds = aView.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.bounds = bounds;
        previewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    }
    else {
        // Handle the failure.
        
        NSLog(@"NOOOO");
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return 100;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 200.0f)];
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    if(index % 2 == 0){
        ((UIImageView *)view).image = [UIImage imageNamed:@"35-circle-stop.png"];
    }
    else{
        ((UIImageView *)view).image = [UIImage imageNamed:@"30-circle-play.png"];
    }
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}

#pragma mark - iCarousel taps

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Tapped view number: %i", index);
}

#pragma mark save observation data
-(void)saveObservationData{
    //save the audio here
    [self.navigationController popViewControllerAnimated:YES];
}


@end
