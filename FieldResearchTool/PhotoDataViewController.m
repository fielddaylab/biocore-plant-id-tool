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



@interface PhotoDataViewController ()<SaveObservationDelegate>{
    UIImageView *showPictureView;
    UIView *recorderView;
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
-(UserObservationComponentData *)saveObservationData{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //get uuid here to uniquely identify the pictures
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"picTaken.png"];
    [UIImagePNGRepresentation(showPictureView.image) writeToFile:filePath atomically:YES];
    
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
