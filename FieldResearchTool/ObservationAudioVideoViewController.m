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

@property (nonatomic, retain) NSMutableArray *items;

@end

@implementation ObservationAudioVideoViewController

@synthesize imageView;
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
    carousel.type = iCarouselTypeLinear;
    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(self.carousel.frame.size.width - 50, self.carousel.frame.origin.y - 50, 44, 44)];
    [recordButton setImage:[UIImage imageNamed:@"29-circle-pause.png"] forState:UIControlStateNormal];
    [recordButton addTarget:self action:@selector(takeVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:recordButton];
    
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

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [items count];
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
    label.text = [[items objectAtIndex:index] stringValue];
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
    NSNumber *item = [self.items objectAtIndex:index];
    NSLog(@"Tapped view number: %@", item);
}

@end
