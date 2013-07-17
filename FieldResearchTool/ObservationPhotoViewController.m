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

#define HEIGHT_OF_RECORD 244 

@interface ObservationPhotoViewController (){
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

@end

@implementation ObservationPhotoViewController
@synthesize stillImageOutput;

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

@end
