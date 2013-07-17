//
//  ObservationPhotoViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "iCarousel.h"

#define HEIGHT_OF_RECORD 244 

@interface ObservationPhotoViewController () <iCarouselDataSource, iCarouselDelegate>{
    AVCaptureDevice *photoCaptureDevice;
    AVCaptureDeviceInput *photoInput;
    UIButton *startRecording;
    UIButton *takePicture;
    UIView *recorderView;
    UIImageView *showPictureView;
    UIImageView *imageView;
    UIButton *testButton;
    int count;
}

@property (nonatomic, retain) iCarousel *carousel;

@end

@implementation ObservationPhotoViewController
@synthesize stillImageOutput;
@synthesize carousel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    showPictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - HEIGHT_OF_RECORD)];//44 nav bar 200 space for slider
    [self.view addSubview:showPictureView];

    recorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - HEIGHT_OF_RECORD)];//44 nav bar 200 space for slider
    [self.view addSubview:recorderView];
    
    count = 0;
    
    testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.frame = showPictureView.bounds;
    [testButton addTarget:self action:@selector(swapViews) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    [self swapViews];
    
    carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, recorderView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - recorderView.frame.size.height)];
	carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeLinear;
	carousel.delegate = self;
	carousel.dataSource = self;
    carousel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:carousel];
    
}

- (void) swapViews
{
    if(count % 2 == 0){
        NSLog(@"DUMMY START RECORD");
        [testButton setTitle:@"Tap me!" forState:UIControlStateNormal];

        [self startRecord];
    }
    else if(count % 2 == 1){
        NSLog(@"DUMMY TAKE PHOTO");
        [testButton setTitle:@"Tap to retake" forState:UIControlStateNormal];

        [self takePhoto];
    }
}

- (void) startRecord
{
    showPictureView.image = [[UIImage alloc]init];

    count ++;
    recorderView.hidden = NO;
    showPictureView.hidden = YES;
    NSLog(@"START RECORD");

    
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    
    //This makes the camera into a square.
    CGRect bounds = recorderView.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.bounds = bounds;
    previewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
    previewLayer.frame = recorderView.bounds;
    [recorderView.layer addSublayer:previewLayer];
    [recorderView addSubview:takePicture];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [captureSession addInput:input];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [captureSession addOutput:stillImageOutput];
    
    [captureSession startRunning];

    
}



- (void)takePhoto {
    
    count ++;
    NSLog(@"TAKE PHOTO");

    recorderView.hidden = YES;
    showPictureView.hidden = NO;
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         } else {
             NSLog(@"no attachments");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         showPictureView.image = image;
         

     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark iCarousel methods

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

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Tapped view number: %i", index);
}

@end
