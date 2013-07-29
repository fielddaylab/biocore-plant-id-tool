//
//  VideoDataViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "VideoDataViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppModel.h"
#import "SaveObservationAndJudgementDelegate.h"


#define HEIGHT_OF_RECORD 44


@interface VideoDataViewController ()<SaveObservationDelegate>{
    UIImageView *imageView;
    AVCaptureSession *captureSession;
    AVCaptureDevice *videoCaptureDevice;
    AVCaptureDeviceInput *videoInput;
    AVCaptureDevice *audioCaptureDevice;
    AVCaptureDeviceInput *audioInput;
}

@property (nonatomic, retain) NSMutableArray *items;

@end

@implementation VideoDataViewController


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
    

    
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.movieController = [[MPMoviePlayerController alloc] init];
    
    [self.movieController setContentURL:self.movieURL];
    [self.movieController.view setFrame:CGRectMake (0, 0, 320, self.view.frame.size.height * .75)];//*.75for3/4
    [self.view addSubview:self.movieController.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.movieController];
    
    [self.movieController play];
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
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.movieURL = info[UIImagePickerControllerMediaURL];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


//- (IBAction)takeVideo:(UIButton *)sender {
//    
//    captureSession = [[AVCaptureSession alloc] init];
//    
//    [captureSession startRunning];
//    
//    videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//    //audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
//    
//    
//    NSError *error = nil;
//    videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
//    
//    //audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
//
//    if (videoInput) {
//        
//        NSLog(@"YEAEAEA");
//        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
//
//
//        
//        UIView* aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - HEIGHT_OF_RECORD)];
//        
//        
//        
//        previewLayer.frame = aView.bounds; // Assume you want the preview layer to fill the view.
//        [aView.layer addSublayer:previewLayer];
//        [imageView addSubview:aView];
//        
//        CGRect bounds = aView.layer.bounds;
//        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        previewLayer.bounds = bounds;
//        previewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
//
//        [captureSession addInput:videoInput];//
//
//    }
//    else {
//        // Handle the failure.
//        
//        NSLog(@"NOOOO");
//    }
//    
//    
//}


//
//
//

//























- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark save observation data
-(void)saveObservationData{
    //save the video to core data here
    //    projectComponent.wasObserved = [NSNumber numberWithBool:YES];
    //    [[AppModel sharedAppModel] save];
    [self.navigationController popViewControllerAnimated:YES];
}


@end

