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
#import "UIImage+Rotation.h"
#import "MediaManager.h"



@interface PhotoDataViewController ()<SaveObservationDelegate>{
    UIImageView *showPictureView;
    UIImageView *cameraImageView;
    UIView *recorderView;
    UIButton *retakeButton;
    UIButton *redXButton;
    UIButton *arrowButton;
    CGRect viewRect;
    UIImage *arrowImage;
    UIImage *redX;
    BOOL judgementIsHidden;
}
@end

@implementation PhotoDataViewController
@synthesize projectComponent;
@synthesize prevData;
@synthesize newObservation;
@synthesize judgementDelegate;
@synthesize saveDelegate;
@synthesize redXButton;


-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    viewRect = frame;
    judgementIsHidden = YES;
    return self;
}

-(void)loadView{
    [super loadView];
    showPictureView = [[UIImageView alloc] initWithFrame:viewRect];
    showPictureView.backgroundColor = [UIColor blackColor];
    showPictureView.contentMode = UIViewContentModeScaleAspectFit;
    
    if(prevData){
        //this will change once the media manager is implemented
        Media *media = prevData.media;
        NSString *path = media.mediaURL;
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        showPictureView.image = image;
    }
    else{
        UIImage *image = [[MediaManager sharedMediaManager] getImageNamed:@"tutorialPhoto.jpg"];
        showPictureView.image = image;
    }

    
    redX = [[MediaManager sharedMediaManager] getImageNamed:@"60-xRED.png"];
    redXButton = [[UIButton alloc] initWithFrame:CGRectMake(0, viewRect.size.height - redX.size.height - 10, redX.size.width, redX.size.height)];
    [redXButton setImage:redX forState:UIControlStateNormal];
    [redXButton addTarget:self
                   action:@selector(redXPressed)
         forControlEvents:UIControlEventTouchUpInside];
    
    retakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retakeButton.frame = viewRect;
    if (newObservation) {
        [retakeButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    }

    UIImage *cameraImage = [[MediaManager sharedMediaManager] getImageNamed:@"86-camera.png"];
    cameraImageView = [[UIImageView alloc] initWithImage:cameraImage];
    cameraImageView.frame = CGRectMake((viewRect.size.width / 2.0f) - (cameraImage.size.width / 2.0f), (viewRect.size.height / 2.0f) - (cameraImage.size.height / 2.0f), cameraImage.size.width, cameraImage.size.height);
    
    arrowImage = [[MediaManager sharedMediaManager] getImageNamed:@"03-arrow-north.png"];
    arrowButton = [[UIButton alloc] initWithFrame:CGRectMake((viewRect.size.width / 2.0f) - (arrowImage.size.width / 2.0f), viewRect.size.height - arrowImage.size.height - 10, arrowImage.size.width, arrowImage.size.height)];
    [arrowButton setImage:arrowImage forState:UIControlStateNormal];
    [arrowButton addTarget:self action:@selector(arrowButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    if(!prevData){
        cameraImageView.hidden = NO;
        redXButton.hidden = YES;
        retakeButton.enabled = YES;
        arrowButton.hidden = YES;
    }
    else{
        cameraImageView.hidden = YES;
        redXButton.hidden = NO;
        retakeButton.enabled = NO;
        arrowButton.hidden = NO;
    }
    
    [self.saveDelegate disableSaveButton];

    [self.view addSubview:showPictureView];
    [self.view addSubview:cameraImageView];
    [self.view addSubview:redXButton];
    [self.view addSubview:retakeButton];
    [self.view addSubview:arrowButton];
}


-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = viewRect;
}


-(void)startRecord{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Image Picker Controller Functions
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    showPictureView.image = chosenImage;
    cameraImageView.hidden = YES;
    
    redXButton.hidden = NO;
    retakeButton.enabled = NO;
    arrowButton.hidden = NO;
    [self.saveDelegate enableSaveButton];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark red x pressed
-(void)redXPressed{
    redXButton.hidden = YES;
    retakeButton.enabled = YES;
    cameraImageView.hidden = NO;
    arrowButton.hidden = YES;
    UIImage *image = [[MediaManager sharedMediaManager] getImageNamed:@"tutorialPhoto.jpg"];
    showPictureView.image = image;
    if(!judgementIsHidden){
        redXButton.frame = CGRectMake(0, viewRect.size.height - redX.size.height - 10, redX.size.width, redX.size.height);
        arrowButton.frame = CGRectMake((viewRect.size.width / 2.0f) - (arrowImage.size.width / 2.0f), viewRect.size.height - arrowImage.size.height - 10, arrowImage.size.width, arrowImage.size.height);
        [arrowButton setImage:[[MediaManager sharedMediaManager] getImageNamed:@"03-arrow-north.png"] forState:UIControlStateNormal];
        [self.judgementDelegate disableJudgementView];
        judgementIsHidden = YES;
    }
    [self.saveDelegate disableSaveButton];
}

#pragma mark arrow button pressed
-(void)arrowButtonPressed{
    if (judgementIsHidden) {
        redXButton.frame = CGRectMake(0, viewRect.size.height - redX.size.height - (viewRect.size.height * (1.0f/3.0f)), redX.size.width, redX.size.height);
        arrowButton.frame = CGRectMake((viewRect.size.width / 2.0f) - (arrowImage.size.width / 2.0f), viewRect.size.height - arrowImage.size.height - (viewRect.size.height * (1.0f/3.0f)), arrowImage.size.width, arrowImage.size.height);
        [arrowButton setImage:[[MediaManager sharedMediaManager] getImageNamed:@"06-arrow-south.png"] forState:UIControlStateNormal];
        [self.judgementDelegate enableJudgementView];
        judgementIsHidden = NO;
    }
    else{
        redXButton.frame = CGRectMake(0, viewRect.size.height - redX.size.height - 10, redX.size.width, redX.size.height);
        arrowButton.frame = CGRectMake((viewRect.size.width / 2.0f) - (arrowImage.size.width / 2.0f), viewRect.size.height - arrowImage.size.height - 10, arrowImage.size.width, arrowImage.size.height);
        [arrowButton setImage:[[MediaManager sharedMediaManager] getImageNamed:@"03-arrow-north.png"] forState:UIControlStateNormal];
        [self.judgementDelegate disableJudgementView];
        judgementIsHidden = YES;
    }
}


#pragma mark - Save Observation Data
-(UserObservationComponentData *)saveObservationData{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //get uuid here to uniquely identify the pictures
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"picTaken.png"];
    UIImage *rotation = [showPictureView.image fixOrientation];
    [UIImagePNGRepresentation(rotation) writeToFile:filePath atomically:YES];
    
    NSMutableDictionary *mediaAttributes = [[NSMutableDictionary alloc]init];
    [mediaAttributes setObject:[NSDate date] forKey:@"created"];
    [mediaAttributes setObject:[NSDate date] forKey:@"updated"];
    [mediaAttributes setObject:[NSNumber numberWithInt:MEDIA_PHOTO] forKey:@"type"];
    [mediaAttributes setObject:filePath forKey:@"mediaURL"];
    
    Media *picTaken = [[AppModel sharedAppModel]createNewMediaWithAttributes:mediaAttributes];
    
    NSMutableDictionary *dataAttributes = [[NSMutableDictionary alloc]init];
    [dataAttributes setObject:[NSDate date] forKey:@"created"];
    [dataAttributes setObject:[NSDate date] forKey:@"updated"];
    [dataAttributes setObject:picTaken forKey:@"media"];
    [dataAttributes setObject:projectComponent forKey:@"projectComponent"];
    
    UserObservationComponentData *data = [[AppModel sharedAppModel] createNewObservationDataWithAttributes:dataAttributes];
    return data;
}

#pragma mark - Cleanup
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
