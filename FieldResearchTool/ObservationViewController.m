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
    NSLog(@"PRINT DAT TEST");
    for(int i = 0; i<userObservationComponents.count; i++){
        UserObservationComponentData *u = userObservationComponents[i];
        NSLog(@"Blah: %@\n", u.data_int);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    //Using only for testing.
    
    [[AppModel sharedAppModel] getUserObservationComponentsDataWithHandler:@selector(printTest:) target:self];
    
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ProjectComponent *com;
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [projectIdentifications count] != 1 ?[NSString stringWithFormat:@"%d identifications", [projectIdentifications count]] : [NSString stringWithFormat:@"%d identification", 1];
            break;
        case 1:
            com = (ProjectComponent *)[projectComponents objectAtIndex:indexPath.row];
            cell.textLabel.text = com.title;
            break;
        case 2:
            if(indexPath.row == 0){
                cell.textLabel.text = @"Location";
            }
            else if(indexPath.row == 1){
                cell.textLabel.text = @"Date Time";
            }
            else if(indexPath.row == 2){
                cell.textLabel.text = @"Weather";
            }
            else{
                cell.textLabel.text = @"Author";
            }
            break;
        default:
            cell.textLabel.text = @"Dummy Data";
            break;
    }
    return cell;
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
            case TEXT:
                viewControllerToPush = [[ObservationTextViewController alloc]initWithNibName:@"ObservationTextViewController" bundle:nil];
                break;
            case LONG_TEXT:
                viewControllerToPush = [[ObservationTextViewController alloc]initWithNibName:@"ObservationTextViewController" bundle:nil];
                break;
            case NUMBER:{
                ObservationNumberViewController *numberViewController = [[ObservationNumberViewController alloc]initWithNibName:@"ObservationNumberViewController" bundle:nil];
                ProjectComponent *projectComponent = [[AppModel sharedAppModel].currentProjectComponents objectAtIndex:indexPath.row];
                numberViewController.projectComponent = projectComponent;
                viewControllerToPush = numberViewController;
            }
                break;
            case BOOLEAN:{
                ObservationBooleanViewController *boolViewController = [[ObservationBooleanViewController alloc]initWithNibName:@"ObservationBooleanViewController" bundle:nil];
                ProjectComponent *projectComponent = [[AppModel sharedAppModel].currentProjectComponents objectAtIndex:indexPath.row];
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
