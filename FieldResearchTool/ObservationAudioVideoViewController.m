//
//  ObservationAudioVideoViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationAudioVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ObservationAudioVideoViewController (){
    AVCaptureSession *captureSession;
    AVCaptureDevice *videoCaptureDevice;
    AVCaptureDeviceInput *videoInput;
    AVCaptureDevice *audioCaptureDevice;
    AVCaptureDeviceInput *audioInput;
}

@end

@implementation ObservationAudioVideoViewController

@synthesize imageView;

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
    // Do any additional setup after loading the view from its nib.
    
#warning TODO

}

- (void)viewDidAppear:(BOOL)animated {
    
//    self.movieController = [[MPMoviePlayerController alloc] init];
//    
//    [self.movieController setContentURL:self.movieURL];
//    [self.movieController.view setFrame:CGRectMake (0, 0, 320, 320)];
//    [self.view addSubview:self.movieController.view];
//    
//    [self.movieController play];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:self.movieController];
    
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
        UIView* aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-244)];//-44 navbar; -200 for scroller
        
        
        
        previewLayer.frame = aView.bounds; // Assume you want the preview layer to fill the view.
        [aView.layer addSublayer:previewLayer];
        [self.imageView addSubview:aView];
        
        CGRect bounds = aView.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.bounds=bounds;
        previewLayer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    }
    else {
        // Handle the failure.
        
        NSLog(@"NOOOO");
    }
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
//    
//    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.movieURL = info[UIImagePickerControllerMediaURL];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
