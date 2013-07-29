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


@interface PhotoDataViewController (){
    UIImageView *showPictureView;
    UIButton *retakeButton;
}

@end

@implementation PhotoDataViewController

@synthesize projectComponent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad{
    
    [super viewDidLoad];
    
    //Still has to be resized here because it's parent changes when the PhotoVC is pushed on.
    showPictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * .75)];
    [self.view addSubview:showPictureView];
    
    //May not be what we want. What is the one where aspect ration is kept and black border is filled in empty space?
    //showPictureView.contentMode = UIViewContentModeScaleAspectFit;
    
    retakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retakeButton.frame = showPictureView.bounds;
    [retakeButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    [retakeButton setTitle:@"Tap to retake" forState:UIControlStateNormal];
    [self.view addSubview:retakeButton];

    [self startRecord];

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
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Image Picker Controller Functions
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    showPictureView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if(showPictureView.image == NULL){
        NSLog(@"No photo :(");
        [self.navigationController popViewControllerAnimated:YES];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Save Observation Data
-(void)saveObservationData{

    NSLog(@"Nothing is saving yet...");
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Cleanup
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
