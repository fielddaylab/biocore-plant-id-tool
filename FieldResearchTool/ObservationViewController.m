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
    
    NSMutableArray *savedComponents;
    int savedCount;
    
}

@end

@implementation ObservationViewController

@synthesize table;

// Implement the delegate methods for ChildViewControllerDelegate
- (void)observationContainerViewController:(ProjectComponent *)projectComponent{
    
    // Do something with value...
    
    // ...then dismiss the child view controller
    savedCount ++;

    [savedComponents insertObject:projectComponent atIndex:[savedComponents count]];
    
    NSLog(@"EAEAAEAAEAE");
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New Observation";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectComponentsResponseReady) name:@"ProjectComponentsResponseReady" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectIdentificationsResponseReady) name:@"ProjectIdentificationsResponseReady" object:nil];
        savedComponents = [[NSMutableArray alloc]init];
        savedCount = 0;
        
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
    [table reloadData];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [savedComponents count];//savedCount;
        case 2:
            return [projectComponents count] - [savedComponents count];//savedCount;
        case 3:
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
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [projectIdentifications count] != 1 ?[NSString stringWithFormat:@"%d identifications", [projectIdentifications count]] : [NSString stringWithFormat:@"%d identification", 1];
            break;
            
        case 1:{
            com = [savedComponents objectAtIndex:indexPath.row];

            //exception >:/
            if(com.wasObserved){
                cell.accessoryType= UITableViewCellAccessoryCheckmark;
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
                
                imgView.image = [UIImage imageNamed:@"19-circle-checkGREEN.png"];
                
                cell.imageView.image = imgView.image;
                
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@", com.title];
            }
            
        }break;
        case 2:{

            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            if(!com.wasObserved){
                com = (ProjectComponent *)[projectComponents objectAtIndex:indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@", com.title];
            }
        }break;
        case 3:{
            
            cell.accessoryType= UITableViewCellAccessoryCheckmark;
            
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
        //saved filter toggler
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if(indexPath.section == 2){
        ProjectComponent *projectComponent = [projectComponents objectAtIndex:indexPath.row];
        UIViewController *viewControllerToPush;
        
        ObservationContainerViewController *viewControllerToPushB;
        
        BOOL pushViewController = YES;
        switch ([projectComponent.observationType intValue]) {
            case PHOTO:{
                ObservationContainerViewController *photoViewController = [[ObservationContainerViewController alloc]initWithNibName:@"ObservationContainerViewController" bundle:nil];
                photoViewController.projectComponent = projectComponent;
                viewControllerToPushB = photoViewController;
                //pushViewController = NO;
            }
                break;
            case AUDIO:{
                ObservationAudioViewController *audioViewController = [[ObservationAudioViewController alloc]initWithNibName:@"ObservationAudioViewController" bundle:nil];
                audioViewController.projectComponent = projectComponent;
                viewControllerToPush = audioViewController;
            }
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
            
            viewControllerToPushB.delegate = self;
            [self.navigationController pushViewController:viewControllerToPushB animated:YES];
        }
        else{
            NSLog(@"Not pushing view controller because it will CRASH on simulator");
        }
    }
    else if (indexPath.section == 3){
        //metadata
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
