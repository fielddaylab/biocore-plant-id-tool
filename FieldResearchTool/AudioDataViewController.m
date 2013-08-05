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
#import "SaveObservationAndJudgementDelegate.h"


#define HEIGHT_OF_RECORD 44

@interface AudioDataViewController ()<SaveObservationDelegate>{
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    UIBarButtonItem *stopButton;
    UIBarButtonItem *playButton;
    UIBarButtonItem *recordPauseButton;
    UIToolbar *toolbar;
}


@end

@implementation AudioDataViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
        
//    stopButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 44, 44)];
//    [stopButton setImage:[UIImage imageNamed:@"29-circle-pause"] forState:UIControlStateNormal];
//    [stopButton addTarget:self action:@selector(stopTapped:) forControlEvents:UIControlEventTouchUpInside];
//
//    playButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 44, 44)];
//    [playButton setImage:[UIImage imageNamed:@"29-circle-pause"] forState:UIControlStateNormal];
//    [playButton addTarget:self action:@selector(playTapped:) forControlEvents:UIControlEventTouchUpInside];
//
//    recordPauseButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 44, 44)];
//    [recordPauseButton setImage:[UIImage imageNamed:@"29-circle-pause"] forState:UIControlStateNormal];
//    [recordPauseButton addTarget:self action:@selector(recordPauseTapped:) forControlEvents:UIControlEventTouchUpInside];

    //////
    
    toolbar = [[UIToolbar alloc]init];
    toolbar.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height-88, self.view.frame.size.width, 44);
    
    UIButton *withoutBorderButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [withoutBorderButton setImage:[UIImage imageNamed:@"30-circle-play.png"] forState:UIControlStateNormal];
    [withoutBorderButton addTarget:self action:@selector(playTapped:) forControlEvents:UIControlEventTouchUpInside];
    playButton = [[UIBarButtonItem alloc]initWithCustomView:withoutBorderButton];
    
    UIButton *withoutBorderButtonStop = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [withoutBorderButtonStop setImage:[UIImage imageNamed:@"30-circle-play.png"] forState:UIControlStateNormal];
    [withoutBorderButtonStop addTarget:self action:@selector(stopTapped:) forControlEvents:UIControlEventTouchUpInside];
    stopButton = [[UIBarButtonItem alloc]initWithCustomView:withoutBorderButtonStop];
    
    UIButton *withoutBorderButtonRecordPause = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [withoutBorderButtonRecordPause setImage:[UIImage imageNamed:@"30-circle-play.png"] forState:UIControlStateNormal];
    [withoutBorderButtonRecordPause addTarget:self action:@selector(recordPauseTapped:) forControlEvents:UIControlEventTouchUpInside];
    recordPauseButton = [[UIBarButtonItem alloc]initWithCustomView:withoutBorderButtonRecordPause];

    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    fixedSpace.width = ([UIScreen mainScreen].bounds.size.width)/3;//wizardry stolen from AudioRecorder - Make more general.
    
    NSArray *toolbarButtons = [NSArray arrayWithObjects:playButton, fixedSpace, recordPauseButton, fixedSpace, stopButton, nil];
    [toolbar setItems:toolbarButtons animated:NO];
    [self.view addSubview:toolbar];

    ////////
    
    // Disable Stop/Play button when application launches
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    
#warning TODO
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        //[recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [recorder pause];
        //[recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stopTapped:(id)sender {
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    //[recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
}

- (IBAction)playTapped:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


@end
