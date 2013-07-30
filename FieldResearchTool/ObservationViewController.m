//
//  ObservationViewController.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationViewController.h"
#import "InterpretationChoiceViewController.h"
#import "AppDelegate.h"
#import "ProjectComponent.h"
#import "Project.h"
#import "AppModel.h"
#import "UserObservation.h"
#import "UserObservationComponentData.h"
#import "Media.h"
#import "ObservationDataType.h"

#import "PhotoDataViewController.h"
#import "AudioDataViewController.h"
#import "VideoDataViewController.h"
#import "NumberDataViewController.h"
#import "BooleanDataViewController.h"
#import "ProjectIdentificationComponentPossibility.h"
#import "ProjectIdentification.h"

@interface ObservationViewController (){
    NSMutableArray *projectComponents;
    NSMutableArray *projectIdentifications;
    
    NSMutableArray *savedComponents;
    int savedCount;
    
}

@end

@implementation ObservationViewController

@synthesize table;

// Implement the delegate methods for ChildViewControllerDelegate
- (void)dismissContainerViewAndSetProjectComponentObserved:(ProjectComponent *)projectComponent{
    savedCount ++;
    [savedComponents insertObject:projectComponent atIndex:[savedComponents count]];
    [projectComponents removeObject:projectComponent];
    [self.navigationController popViewControllerAnimated:YES];
    
    //manage filtering here
    NSArray *userData = [NSArray arrayWithArray:[projectComponent.userObservationComponentData allObjects]];
    for(int i = 0; i < userData.count; i++){
        UserObservationComponentData *data = [userData objectAtIndex:i];
        UserObservationComponentDataJudgement *judgement = data.userObservationComponentDataJudgement;
        if(judgement){
            NSLog(@"Judgement: %@", judgement.enumValue);
            NSArray *componentPossibilities = [NSArray arrayWithArray:[judgement.projectComponentPossibilities allObjects]];
            for(int j = 0; j < judgement.projectComponentPossibilities.count; j++){
                ProjectComponentPossibility *possibility = [componentPossibilities objectAtIndex:j];
                NSLog(@"Possibility: %@", possibility.enumValue);
                [[AppModel sharedAppModel] getProjectIdentificationComponentPossibilitiesForPossibility:possibility withHandler:@selector(updateProjectIdentifications:) target:self];
            }
        }
    }
}

//move this method later
-(void)updateProjectIdentifications:(NSArray *)projectIdentificationComponentPossibilities{
    
    //completely start over the identification process....this will need to change
    projectIdentifications = [[NSMutableArray alloc]init];
    for(int i = 0; i < projectIdentificationComponentPossibilities.count; i++){
        ProjectIdentificationComponentPossibility *identificationComponentPossibility = [projectIdentificationComponentPossibilities objectAtIndex:i];
        ProjectIdentification *identification = identificationComponentPossibility.projectIdentification;
        NSLog(@"Adding identification: %@", identification.title);
        [projectIdentifications addObject:identification];
    }
    
    //possibily set the current project identifications to project identifications
    [table reloadData];
    
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

- (void)viewDidAppear:(BOOL)animated
{
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
            return [savedComponents count];
        case 2:
            return [projectComponents count] - [savedComponents count];
        case 3:
            return 4;
        default:
            return 0;
    };
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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

            if(com.wasObserved){
                cell.accessoryType= UITableViewCellAccessoryCheckmark;
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
                
                imgView.image = [UIImage imageNamed:@"19-circle-checkGREEN.png"];
                
                //cell.imageView.image = imgView.image;
                
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@", com.title];
            }
            
        }break;
        case 2:{

            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            if(!com.wasObserved){

                com = (ProjectComponent *)[projectComponents objectAtIndex:indexPath.row];
                
//                cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"test.png"] scaledToSize:CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, cell.bounds.size.height, cell.bounds.size.height).size];
                
                cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"SwitchYesBig.png"] scaledToSize:CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, cell.bounds.size.height, cell.bounds.size.height).size];
  
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
        
        ObservationContainerViewController *containerView = [[ObservationContainerViewController alloc]initWithNibName:@"ObservationContainerViewController" bundle:nil];
        
        ProjectComponent *projectComponent = [projectComponents objectAtIndex:indexPath.row];
        containerView.projectComponent = projectComponent;
        containerView.dismissDelegate = self;
        [self.navigationController pushViewController:containerView animated:YES];
    }
    else if (indexPath.section == 3){
        //metadata
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//        else{
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
        
        
        AudioDataViewController *photoDataView = [[AudioDataViewController alloc]initWithNibName:@"AudioDataViewController" bundle:nil];
        ProjectComponent *projectComponent = [projectComponents objectAtIndex:indexPath.row];
        photoDataView.projectComponent = projectComponent;
        [self.navigationController pushViewController:photoDataView animated:YES];
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Asynchronous responses

-(void)projectComponentsResponseReady{
    projectComponents = [NSMutableArray arrayWithArray:[AppModel sharedAppModel].currentProjectComponents];
    for(int i = 0; i < projectComponents.count; i++){
        ProjectComponent *component = [projectComponents objectAtIndex:i];
        if([component.wasObserved boolValue]){
            [projectComponents removeObject:component];
            [savedComponents addObject:component];
        }
    }
    [self.table reloadData];
}

-(void)projectIdentificationsResponseReady{
    projectIdentifications = [NSMutableArray arrayWithArray:[AppModel sharedAppModel].currentProjectIdentifications];
    [self.table reloadData];
}

@end
