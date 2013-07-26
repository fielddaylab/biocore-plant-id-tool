//
//  AudioDataViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "AudioDataViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppModel.h"


#define HEIGHT_OF_RECORD 44

@interface AudioDataViewController (){
    UIImageView *imageView;
    AVCaptureSession *captureSession;
    AVCaptureDevice *videoCaptureDevice;
    AVCaptureDeviceInput *videoInput;
    AVCaptureDevice *audioCaptureDevice;
    AVCaptureDeviceInput *audioInput;
}

@property (nonatomic, retain) NSMutableArray *items;

@end

@implementation AudioDataViewController



@synthesize items;
@synthesize projectComponent;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObservationData)]];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - HEIGHT_OF_RECORD)];
    [self.view addSubview:imageView];
     
    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 44, 44)];
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
    
    //videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    
    NSError *error = nil;
    //videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    
    audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    
    if (audioInput) {
        [captureSession addInput:audioInput];
        
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

#pragma mark save observation data
-(void)saveObservationData{
    //save the audio here
    //    projectComponent.wasObserved = [NSNumber numberWithBool:YES];
    //    [[AppModel sharedAppModel] save];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
