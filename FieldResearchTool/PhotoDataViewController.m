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



@interface PhotoDataViewController ()<SaveObservationDelegate, PhotoNextButtonWasPressed>{
    UIImageView *showPictureView;
    //UIImageView *cameraImageView;
    UIView *recorderView;
    //UIButton *retakeButton;
    UIButton *arrowButton;
    UIButton *deleteImageButton;
    CGRect viewRect;
    UIImage *deleteImageImage;
    UIImage *arrowImage;
    BOOL judgementIsHidden;
    UIImage *tutorialPhoto;
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
    
    NSString *tutorialLargeString = projectComponent.title;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    tutorialLargeString = [[tutorialLargeString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
    tutorialLargeString = [tutorialLargeString stringByAppendingString:@"_TutorialLarge"];
    
    tutorialPhoto = [[MediaManager sharedMediaManager] getImageNamed:tutorialLargeString];
    
    if(prevData){
        //this will change once the media manager is implemented
        Media *media = prevData.media;
        NSString *path = media.mediaURL;
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        showPictureView.image = image;
    }
    else{
        showPictureView.image = tutorialPhoto;
    }
    
    deleteImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteImageButton.backgroundColor = [UIColor colorWithRed:172 green:172 blue:172 alpha:.75];
    [deleteImageButton setTitle:@"Retake Photo!" forState:UIControlStateNormal];
    
    [deleteImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteImageButton setTitleColor:[UIColor colorWithRed:69 green:69 blue:69 alpha:1.0] forState:UIControlStateHighlighted];
    
    [deleteImageButton addTarget:self action:@selector(deleteImagePressed) forControlEvents:UIControlEventTouchUpInside];
    deleteImageButton.frame = CGRectMake(0, 0, 320, 44);
    
    arrowImage = [[MediaManager sharedMediaManager] getImageNamed:@"03-arrow-north.png"];
    arrowButton = [[UIButton alloc] initWithFrame:CGRectMake((viewRect.size.width / 2.0f) - (arrowImage.size.width / 2.0f) - 5, viewRect.size.height - arrowImage.size.height - 10 - 5, arrowImage.size.width + 10, arrowImage.size.height + 10)];
    [arrowButton setImage:arrowImage forState:UIControlStateNormal];
    [arrowButton addTarget:self action:@selector(arrowButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    if(!prevData){
        deleteImageButton.hidden = YES;
        arrowButton.hidden = YES;
        [self.saveDelegate disableSaveButton];
    }
    else{
        if (newObservation) {
            deleteImageButton.hidden = NO;
        }
        else{
            deleteImageButton.hidden = YES;
        }
        arrowButton.hidden = NO;
    }
    
    

    [self.view addSubview:showPictureView];
    [self.view addSubview:deleteImageButton];
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
//    [self presentViewController:[[UIViewController alloc] init] animated:YES completion:nil];
//    [self performSelector:@selector(imagePickerControllerDidCancel:) withObject:nil afterDelay:5];
}


#pragma mark - Image Picker Controller Functions
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    showPictureView.image = chosenImage;
    
    deleteImageButton.hidden = NO;
    arrowButton.hidden = NO;
    [self.saveDelegate enableSaveButton];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self arrowButtonPressed];//Brings up the judgement automatically
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - deleteImagePressed
-(void)deleteImagePressed{
    deleteImageButton.hidden = YES;
    arrowButton.hidden = YES;
    showPictureView.image = tutorialPhoto;
    if(!judgementIsHidden){
        arrowButton.frame = CGRectMake((viewRect.size.width / 2.0f) - (arrowImage.size.width / 2.0f), viewRect.size.height - arrowImage.size.height - 10, arrowImage.size.width, arrowImage.size.height);
        [arrowButton setImage:[[MediaManager sharedMediaManager] getImageNamed:@"03-arrow-north.png"] forState:UIControlStateNormal];
        [self.judgementDelegate disableJudgementView];
        judgementIsHidden = YES;
    }
    [self.saveDelegate disableSaveButton];
    [self.saveDelegate setNextAsRightButton];
}

#pragma mark - arrow button pressed
-(void)arrowButtonPressed{
    if (judgementIsHidden) {
        arrowButton.frame = CGRectMake((viewRect.size.width / 2.0f) - (arrowImage.size.width / 2.0f), viewRect.size.height - arrowImage.size.height - (viewRect.size.height * (.43f)), arrowImage.size.width, arrowImage.size.height);
        [arrowButton setImage:[[MediaManager sharedMediaManager] getImageNamed:@"06-arrow-south.png"] forState:UIControlStateNormal];
        [self.judgementDelegate enableJudgementView];
        judgementIsHidden = NO;
    }
    else{
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

#pragma mark photo next button was pressed
-(void)photoNextButtonWasPressed{
    [self startRecord];
}

@end
