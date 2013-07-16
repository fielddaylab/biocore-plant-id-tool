//
//  ObservationViewController.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationViewController.h"
#import "ObservationBooleanViewController.h"
#import "ObservationAudioVideoViewController.h"
#import "ObservationNumberViewController.h"
#import "ObservationPhotoViewController.h"
#import "ObservationTextViewController.h"
#import "InterpretationChoiceViewController.h"
#import "AppDelegate.h"
#import "ProjectComponent.h"
#import "Project.h"
#import "AppModel.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Backzz" style:UIBarButtonItemStyleBordered target:nil action:nil]];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:nil]];
    
    [[AppModel sharedAppModel]getAllProjectComponentsForProjectName:@"Biocore"];
    [[AppModel sharedAppModel]getAllProjectIdentificationsForProjectName:@"Biocore"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Table View Controller Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
        case 3:
            return 5;
        case 4:
            return 1;
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
            cell.textLabel.text = [projectIdentifications count] != 0 ?[NSString stringWithFormat:@"%d identifications", [projectIdentifications count]] : [NSString stringWithFormat:@"%d identifications", 0];
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
        case 3:
            if(indexPath.row == 0){
                cell.textLabel.text = @"BOOL";
            }
            else if (indexPath.row == 1){
                cell.textLabel.text = @"AV";
            }
            else if (indexPath.row == 2){
                cell.textLabel.text = @"TEXT";
            }
            else if (indexPath.row == 3){
                cell.textLabel.text = @"NUMBER";
            }
            else if (indexPath.row == 4){
                cell.textLabel.text = @"PHOTO";
            }
            break;
        case 4:
            cell.textLabel.text = @"INTERPRETATION CHOICE";
            break;
        default:
            cell.textLabel.text = @"Dummy Data";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 3 && indexPath.row == 0){
        ObservationBooleanViewController *vc = [[ObservationBooleanViewController alloc]initWithNibName:@"ObservationBooleanViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == 3 && indexPath.row == 1){
        ObservationAudioVideoViewController *vc = [[ObservationAudioVideoViewController alloc]initWithNibName:@"ObservationAudioVideoViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == 3 && indexPath.row == 2){
        ObservationTextViewController *vc = [[ObservationTextViewController alloc]initWithNibName:@"ObservationTextViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == 3 && indexPath.row == 3){
        ObservationNumberViewController *vc = [[ObservationNumberViewController alloc]initWithNibName:@"ObservationNumberViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == 3 && indexPath.row == 4){
        ObservationPhotoViewController *vc = [[ObservationPhotoViewController alloc]initWithNibName:@"ObservationPhotoViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == 4 && indexPath.row == 0){
        InterpretationChoiceViewController *vc = [[InterpretationChoiceViewController alloc]initWithNibName:@"InterpretationChoiceViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Asynchronous responses

-(void)projectComponentsResponseReady{
    projectComponents = [AppModel sharedAppModel].projectComponents;
    [self.table reloadData];
}

-(void)projectIdentificationsResponseReady{
    projectIdentifications = [AppModel sharedAppModel].projectIdentifications;
    [self.table reloadData];
}

@end
