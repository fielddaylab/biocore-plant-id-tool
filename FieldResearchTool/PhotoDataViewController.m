//
//  PhotoDataViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "PhotoDataViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "AppModel.h"
#import "SaveObservationAndJudgementDelegate.h"


#define HEIGHT_OF_RECORD 44



@interface PhotoDataViewController ()<SaveObservationDelegate>{
    AVCaptureDevice *photoCaptureDevice;
    AVCaptureDeviceInput *photoInput;
    UIView *recorderView;
    UIImageView *showPictureView;
    UIButton *testButton;
    int count;
    UIImage *image;
    UIBarButtonItem *saveButton;
}



@end

@implementation PhotoDataViewController


@synthesize stillImageOutput;
@synthesize projectComponent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObservationData)];
    [saveButton setEnabled:NO];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
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

//Get to make this sweet ass dummy method because view hierarchy makes me feel bad about myself...
- (void) swapViews
{
    if(count % 2 == 0){
        NSLog(@"DUMMY START RECORD");
        [testButton setTitle:@"Tap me!" forState:UIControlStateNormal];
        [saveButton setEnabled:NO];
        
        [self startRecord];
    }
    else if(count % 2 == 1){
        NSLog(@"DUMMY TAKE PHOTO");
        [testButton setTitle:@"Tap to retake" forState:UIControlStateNormal];
        [saveButton setEnabled:YES];
        
        [self takePhoto];
    }
}

- (void) startRecord
{
    //Create new image because it shows the previous one, which looks like shiiiit
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
         image = [[UIImage alloc] initWithData:imageData];
         
         showPictureView.contentMode = UIViewContentModeScaleAspectFill;
         showPictureView.image = image;
         showPictureView.contentMode = UIViewContentModeScaleAspectFill;
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark save observation data
-(void)saveObservationData{
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
    //                                                         NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    //should we use the library folder or the documents folder?
    //    NSString *path = [documentsDirectory stringByAppendingPathComponent:
    //                      @"userObservationComponentDataPicture.png"]; //replace this with a uuid
    //    NSData* data = UIImagePNGRepresentation(image);
    //    [data writeToFile:path atomically:YES];
    //
    //    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    //    [attributes setObject:[NSDate date] forKey:@"created"];
    //    [attributes setObject:[NSDate date] forKey:@"updated"];
    //    Media *media = [[AppModel sharedAppModel] createNewMediaWithAttributes:attributes forPath:path withType:MEDIA_PHOTO];
    //    projectComponent.media = media;
    //    projectComponent.wasObserved = [NSNumber numberWithBool:YES];
    //    [[AppModel sharedAppModel] save];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
