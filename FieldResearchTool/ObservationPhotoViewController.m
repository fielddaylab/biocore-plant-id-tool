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
    UIView *showPictureView;
    UIImageView *imageView;

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
    showPictureView.hidden = YES;
    
    startRecording = [UIButton buttonWithType:UIButtonTypeCustom];
    startRecording.frame = showPictureView.bounds;
    [startRecording setTitle:@"Retake PHOOOOTOOOOO" forState:UIControlStateNormal];
    [startRecording addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    
    
    recorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - HEIGHT_OF_RECORD)];//44 nav bar 200 space for slider
    [self.view addSubview:recorderView];

    takePicture = [UIButton buttonWithType:UIButtonTypeCustom];
    takePicture.frame = recorderView.bounds;
    [takePicture setTitle:@"Touch Me!" forState:UIControlStateNormal];
    [takePicture addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];

    
    [self startRecord];
}

- (void) startRecord
{
    NSLog(@"START RECORD");
    recorderView.hidden = NO;
    takePicture.hidden = NO;

    showPictureView.hidden = YES;
    startRecording.hidden = YES;
    
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    
//    CGRect bounds = recorderView.bounds;
//    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    previewLayer.bounds = bounds;
//    previewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
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
    
    NSLog(@"TAKE PHOTO");

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
         
         imageView.image = image;
         
         [showPictureView addSubview:startRecording];
         
         recorderView.hidden = YES;
         takePicture.hidden = YES;
         
         showPictureView.hidden = NO;
         startRecording.hidden = NO;

     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
