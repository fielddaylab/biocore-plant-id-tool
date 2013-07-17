//
//  ObservationAudioVideoViewController.h
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "iCarousel.h"

@interface ObservationAudioVideoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (copy,   nonatomic) NSURL *movieURL;
@property (strong, nonatomic) MPMoviePlayerController *movieController;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet iCarousel *carousel;

@end
