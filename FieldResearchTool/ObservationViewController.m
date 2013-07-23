//
//  ObservationViewController.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationViewController.h"
#import "ObservationBooleanViewController.h"
#import "ObservationVideoViewController.h"
#import "ObservationAudioViewController.h"
#import "ObservationNumberViewController.h"
#import "ObservationPhotoViewController.h"
#import "ObservationTextViewController.h"
#import "InterpretationChoiceViewController.h"
#import "AppDelegate.h"
#import "ProjectComponent.h"
#import "Project.h"
#import "AppModel.h"
#import "ProjectComponentDataType.h"
#import "UserObservation.h"
#import "UserObservationComponentData.h"
#import "Media.h"

@interface ObservationViewController (){
    NSArray *projectComponents;
    NSArray *projectIdentifications;
}

@end

@implementation ObservationViewController

@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New Observation";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectComponentsResponseReady) name:@"ProjectComponentsResponseReady" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectIdentificationsResponseReady) name:@"ProjectIdentificationsResponseReady" object:nil];
    }
    return self;
}

- (void)printTest:(NSArray *)userObservationComponents{
    for(int i = 0; i<userObservationComponents.count; i++){
        UserObservationComponentData *u = userObservationComponents[i];
        NSLog(@"Blah: %@\n", u.dataInt);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    //Using only for testing
    //[[AppModel sharedAppModel] getUserObservationComponentsDataWithHandler:@selector(printTest:) target:self];
    

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Backzz" style:UIBarButtonItemStyleBordered target:nil action:nil]];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:nil]];
    
    [[AppModel sharedAppModel]getAllProjectComponentsWithHandler:@selector(handleFetchAllProjectComponentsForProjectName:) target:[AppModel sharedAppModel]];
    [[AppModel sharedAppModel]getAllProjectIdentificationsWithHandler:@selector(handleFetchProjectIdentifications:) target:[AppModel sharedAppModel]];
    
    //get the location here
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setValue:[NSNumber numberWithFloat:1.0f] forKey:@"latitude"];
    [attributes setValue:[NSNumber numberWithFloat:1.0f] forKey:@"longitude"];
    [attributes setValue:[NSDate date] forKey:@"created"];
    [attributes setValue:[NSDate date] forKey:@"updated"];
    [[AppModel sharedAppModel] createNewUserObservationWithAttributes:attributes];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Table View Controller Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [projectComponents count];
        case 2:
            return 4;
        default:
            return 0;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Make the identifier unique to that row so cell pictures don't get reused in funky ways.
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ProjectComponent *com;
    
    switch (indexPath.section) {
        case 0:

            cell.textLabel.text = [projectIdentifications count] != 1 ?[NSString stringWithFormat:@"%d identifications", [projectIdentifications count]] : [NSString stringWithFormat:@"%d identification", 1];
            break;
        case 1:{

            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];

            if(indexPath.row % 4 == 1 && indexPath.section == 1){
                imgView.image = [UIImage imageNamed:@"17-checkGREEN.png"];

            }
            else if(indexPath.row % 4 ==2 && indexPath.section == 1){
                imgView.image = [UIImage imageNamed:@"19-circle-checkGREEN.png"];

            }
            else if(indexPath.row % 4 == 3 && indexPath.section == 1){
                imgView.image = [UIImage imageNamed:@"37-circle-xRED.png"];

            }
            else if(indexPath.row % 4 == 0 && indexPath.section == 1){
                imgView.image = [UIImage imageNamed:@"60-xRED.png"];

            }
            
            cell.imageView.image = imgView.image;
            
            
            com = (ProjectComponent *)[projectComponents objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", com.title];
        }break;
        case 2:{
          
            UIButton *downloadButton = nil;
            //this is the custom cell i have created one class for this in that i am place the string titlelabel.
                downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
            float wizardry = ([UIScreen mainScreen].bounds.size.width - cell.frame.size.width) + 8; // 8 looks nice on iphone sim.
            float magic = cell.frame.size.height/4; // 8 looks nice on iphone sim.
            NSLog(@"%f uoihiphion %f", [UIScreen mainScreen].bounds.size.width, cell.frame.size.width);
                downloadButton.frame = CGRectMake(wizardry, 8, 28, 28);
                [downloadButton setImage:[UIImage imageNamed:@"19-circle-checkGREEN.png"] forState:UIControlStateNormal];
                [downloadButton addTarget:self action:@selector(datLog) forControlEvents:UIControlEventTouchUpInside];
                downloadButton.userInteractionEnabled = YES;
                [cell.contentView addSubview:downloadButton];

            
            //add empty immage of 28x28 so that spacing is current.//NOT DONE YET...
            if(indexPath.row == 0){
                cell.textLabel.text = @"       Location";
            }
            else if(indexPath.row == 1){
                cell.textLabel.text = @"       Date Time";
            }
            else if(indexPath.row == 2){
                cell.textLabel.text = @"       Weather";
            }
            else{
                cell.textLabel.text = @"       Author";
            }
        }break;
        default:
            cell.textLabel.text = @"Dummy Data";
            break;
    }
    return cell;
}

- (void) datLog{
    NSLog(@"DAT LOG");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        InterpretationChoiceViewController *vc = [[InterpretationChoiceViewController alloc]initWithNibName:@"InterpretationChoiceViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 1){
        ProjectComponent *projectComponent = [projectComponents objectAtIndex:indexPath.row];
        UIViewController *viewControllerToPush;
        BOOL pushViewController = YES;
        switch ([projectComponent.observationType intValue]) {
            case PHOTO:
                viewControllerToPush = [[ObservationPhotoViewController alloc]initWithNibName:@"ObservationPhotoViewController" bundle:nil];
                pushViewController = NO;
                break;
            case AUDIO:
                viewControllerToPush = [[ObservationAudioViewController alloc]initWithNibName:@"ObservationAudioViewController" bundle:nil];
                break;
            case TEXT:{
                ObservationTextViewController *textViewController = [[ObservationTextViewController alloc]initWithNibName:@"ObservationTextViewController" bundle:nil];
                textViewController.projectComponent = projectComponent;
                viewControllerToPush = textViewController;
            }
                break;
            case LONG_TEXT:{
                ObservationTextViewController *textViewController = [[ObservationTextViewController alloc]initWithNibName:@"ObservationTextViewController" bundle:nil];
                textViewController.projectComponent = projectComponent;
                viewControllerToPush = textViewController;
            }
                break;
            case NUMBER:{
                ObservationNumberViewController *numberViewController = [[ObservationNumberViewController alloc]initWithNibName:@"ObservationNumberViewController" bundle:nil];
                numberViewController.projectComponent = projectComponent;
                viewControllerToPush = numberViewController;
            }
                break;
            case BOOLEAN:{
                ObservationBooleanViewController *boolViewController = [[ObservationBooleanViewController alloc]initWithNibName:@"ObservationBooleanViewController" bundle:nil];
                boolViewController.projectComponent = projectComponent;
                viewControllerToPush = boolViewController;
            }
                break;
            case VIDEO:
                viewControllerToPush = [[ObservationVideoViewController alloc]initWithNibName:@"ObservationVideoViewController" bundle:nil];
                break;
            default:
                NSLog(@"Pushing on Bool view controller as default");
                viewControllerToPush = [[ObservationBooleanViewController alloc]initWithNibName:@"ObservationBooleanViewController" bundle:nil];
                break;
        }
        if(pushViewController){
            [self.navigationController pushViewController:viewControllerToPush animated:YES];
        }
        else{
            NSLog(@"Not pushing view controller because it will CRASH on simulator");
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Asynchronous responses

-(void)projectComponentsResponseReady{
    projectComponents = [AppModel sharedAppModel].currentProjectComponents;
    [self.table reloadData];
}

-(void)projectIdentificationsResponseReady{
    projectIdentifications = [AppModel sharedAppModel].currentProjectIdentifications;
    [self.table reloadData];
}

@end
