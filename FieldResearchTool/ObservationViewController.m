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
#import "ObservationJudgementType.h"

#define ENUM_SCORE 1.0
#define NIL_SCORE 1.0
#define BOOL_SCORE 1.0

@interface ObservationViewController (){
    NSMutableArray *projectComponents;
    NSMutableArray *projectIdentifications;
    
    NSMutableArray *componentsToFilter;
    NSMutableArray *savedComponents;
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
        componentsToFilter = [[NSMutableArray alloc]init];
        savedComponents = [[NSMutableArray alloc]init];
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
            return [projectComponents count];
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
            int identifications = [projectIdentifications count];
            if(componentsToFilter.count > 0){
                identifications = 0;
                for (int i = 0; i < projectIdentifications.count; i++) {
                    ProjectIdentification *iden = [projectIdentifications objectAtIndex:i];
                    if([iden.score floatValue] >= .8){
                        identifications++;
                    }
                }
            }
            cell.textLabel.text = identifications != 1 ?[NSString stringWithFormat:@"%d ids with > .8 match", identifications] : [NSString stringWithFormat:@"%d id with > .8 match", 1];
            break;
        case 1:
            com = (ProjectComponent *)[savedComponents objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", com.title];
            break;
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
        vc.projectIdentifications = projectIdentifications;
        vc.componentsToFilter = componentsToFilter;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 2){
        
        ObservationContainerViewController *containerView = [[ObservationContainerViewController alloc]initWithNibName:@"ObservationContainerViewController" bundle:nil];
        
        ProjectComponent *projectComponent = [projectComponents objectAtIndex:indexPath.row];
        containerView.projectComponent = projectComponent;
        containerView.dismissDelegate = self;
        
        if(![projectComponent.wasObserved boolValue]){
            [self.navigationController pushViewController:containerView animated:YES];
        }
        else{
            NSLog(@"This component has already been observed!");
        }
        
        
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
    for (int i = 0; i < projectComponents.count; i++) {
        ProjectComponent *com = [projectComponents objectAtIndex:i];
        if([com.wasObserved boolValue]){
            [savedComponents addObject:com];
            [projectComponents removeObject:com];
        }
    }
    [self.table reloadData];
}

-(void)projectIdentificationsResponseReady{
    projectIdentifications = [NSMutableArray arrayWithArray:[AppModel sharedAppModel].allProjectIdentifications];
    [self.table reloadData];
}

- (void)dismissContainerViewAndSetProjectComponentObserved:(ProjectComponent *)projectComponent{
    
    [componentsToFilter addObject:projectComponent];
    [savedComponents addObject:projectComponent];
    [projectComponents removeObject:projectComponent];
    [self rankIdentifications];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rankIdentifications{
    NSArray *allProjectIdentifications = [AppModel sharedAppModel].allProjectIdentifications;
    for (int i = 0; i < allProjectIdentifications.count; i++) {
        ProjectIdentification *identification = [allProjectIdentifications objectAtIndex:i];
        identification.score = [NSNumber numberWithFloat:0.0f];
        identification.numOfNils = [NSNumber numberWithInt:0];
        for (int j = 0; j < componentsToFilter.count; j++) {
            ProjectComponent *component = [componentsToFilter objectAtIndex:j];
            switch ([component.observationJudgementType intValue]) {
                case JUDGEMENT_BOOLEAN:{
                    float score = [identification.score floatValue];
                    score += [self getBoolScoreForComponent:component withIdentification:identification];
                    identification.score = [NSNumber numberWithFloat:score];
                }
                    break;
                case JUDGEMENT_ENUMERATOR:{
                    float score = [identification.score floatValue];
                    score += [self getEnumScoreForComponent:component withIdentification:identification];
                    identification.score = [NSNumber numberWithFloat:score];
                }
                    break;
                case JUDGEMENT_NUMBER:{
                    float score = [identification.score floatValue];
                    score += [self getNumberScoreForComponent:component withIdentification:identification];
                    identification.score = [NSNumber numberWithFloat:score];
                    //NSLog(@"Haven't implemented sorting for numbers yet.");
                }
                    break;
                default:
                    NSLog(@"Not adjusting score because component is of type text or long text");
                    break;
            }
        }
    }
    
    //scale score to be 0 to 1
    for (int i = 0; i < allProjectIdentifications.count; i++) {
        ProjectIdentification *identification = [allProjectIdentifications objectAtIndex:i];
        float score = [identification.score floatValue];
        float scaledScore = score / [componentsToFilter count];
        float roundedScore = floorf(scaledScore * 100 + 0.5) / 100;
        identification.score = [NSNumber numberWithFloat:roundedScore];
    }
    
    //sort array
    NSSortDescriptor *scoreDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSSortDescriptor *nilsDescriptor = [[NSSortDescriptor alloc] initWithKey:@"numOfNils" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:scoreDescriptor, nilsDescriptor, nil];
    NSArray *sortedIdentifications = [allProjectIdentifications sortedArrayUsingDescriptors:descriptors];
    
    //for debugging purposes
    for (int i = 0; i < sortedIdentifications.count; i++) {
        ProjectIdentification *identification = [sortedIdentifications objectAtIndex:i];
        int numberOfNils = [identification.numOfNils intValue];
        NSLog(@"%i: %@ with score %@ and %i nils. Sorting on %lu components", i, identification.title, identification.score, numberOfNils, (unsigned long)componentsToFilter.count);
    }
    
    projectIdentifications = [NSArray arrayWithArray:sortedIdentifications];
    [self.table reloadData];
}

-(float)getNumberScoreForComponent:(ProjectComponent *)component withIdentification:(ProjectIdentification *)identification{
    
    NSArray *userData = [NSArray arrayWithArray:[component.userObservationComponentData allObjects]];
    
    if(!userData){
        NSLog(@"ERROR: userData is nil. Returning 0.0f");
        return 0.0f;
    }
    else if(userData.count < 1){
        NSLog(@"ERROR: There is no data associated with this component. Returning 0.0f");
        return 0.0f;
    }
    else if (userData.count > 1){
        NSLog(@"There is currently more than one data object associated with this component. This is either an error, or a feature to be implemented in the future. Returning 0.0f");
        return 0.0f;
    }
    
    UserObservationComponentData *data = [userData objectAtIndex:0];
    
    if (!data) {
        NSLog(@"ERROR: data for this component is nil. Returning 0.0f");
        return 0.0f;
    }
    
    NSArray *judgementSet = [NSArray arrayWithArray:[data.userObservationComponentDataJudgement allObjects]];
    
    if(!judgementSet){
        NSLog(@"ERROR: judgementSet is nil. Returning 0.0f");
        return 0.0f;
    }
    else if (judgementSet.count < 1){
        NSLog(@"There is no judgement associated with this data. Returning 0.0f");
        return 0.0f;
    }
    else if (judgementSet.count > 1){
        NSLog(@"There is currently more than one judgement associated with this data. This is probably a feature that needs to be implemented in the future. Currently returning 0.0f");
        return 0.0f;
    }
    
    UserObservationComponentDataJudgement *judgement = [judgementSet objectAtIndex:0];
    
    if (!judgement) {
        NSLog(@"ERROR: judgement for this data is nil, when it shouldn't be. Returning 0.0f");
        return 0.0f;
    }
    
    NSArray *componentPossibilities = [NSArray arrayWithArray:[judgement.projectComponentPossibilities allObjects]];
    
    if (!componentPossibilities) {
        NSLog(@"ERROR: componentPossibilities is nil. Returning 0.0f");
        return 0.0f;
    }
    
    //find the correct possibility for the identification
    ProjectComponentPossibility *possibility;
    for (int i = 0; i < componentPossibilities.count; i++) {
        possibility = [componentPossibilities objectAtIndex:i];
        NSArray *pairs = [NSArray arrayWithArray:[possibility.projectIdentificationComponentPossibilities allObjects]];
        if(!pairs){
            NSLog(@"ERROR: pairs is nil. Returning 0.0f");
            return 0.0f;
        }
        else if (pairs.count < 1){
            NSLog(@"ERROR: pairs has no options for number. The number possibilities were not read in correctly. Returning 0.0f");
            return 0.0f;
        }
        else if (pairs.count > 1){
            NSLog(@"ERROR: pairs has more than on option for number. The number possibilities were not read in correctly. Returning 0.0f");
            return 0.0f;
        }
        ProjectIdentificationComponentPossibility *identificationProjectPossibility = [pairs objectAtIndex:0];
        ProjectIdentification *idToCompare = identificationProjectPossibility.projectIdentification;
        if([idToCompare.title isEqualToString:identification.title]){
            //NSLog(@"Component: %@ Identification: %@ Mean: %@ StdDev: %@", component.title, identification.title, possibility.number, possibility.stdDev);
            break;
        }
    }
    
    ProjectComponent *componentToCompare = possibility.projectComponent;
    if([componentToCompare.title isEqualToString:component.title] && [possibility.enumValue isEqualToString:@""]){
        int nils = [identification.numOfNils intValue];
        nils++;
        identification.numOfNils = [NSNumber numberWithInt:nils];
        return NIL_SCORE;
    }
    
    float mean = [possibility.number floatValue];
    float stdDev = [possibility.stdDev floatValue];
    float x = [judgement.number floatValue];
    float zScore = (x - mean) / stdDev;
    float absZ = fabsf(zScore);
    float score = 1 / expf(absZ);
    float roundedToTwoDecimals = floorf(score * 100 + 0.5) / 100;
    
    //NSLog(@"Z-Score: %f Adding %f to identification: %@ for component: %@", absZ, score, identification.title, component.title);
    
    return roundedToTwoDecimals;
    
}


-(float)getEnumScoreForComponent:(ProjectComponent *)component withIdentification:(ProjectIdentification *)identification{
    NSArray *userData = [NSArray arrayWithArray:[component.userObservationComponentData allObjects]];
    
    if(!userData){
        NSLog(@"ERROR: userData is nil. Returning 0.0f");
        return 0.0f;
    }
    else if(userData.count < 1){
        NSLog(@"ERROR: There is no data associated with this component. Returning 0.0f");
        return 0.0f;
    }
    else if (userData.count > 1){
        NSLog(@"There is currently more than one data object associated with this component. This is either an error, or a feature to be implemented in the future. Returning 0.0f");
        return 0.0f;
    }
    
    UserObservationComponentData *data = [userData objectAtIndex:0];
    
    if (!data) {
        NSLog(@"ERROR: data for this component is nil. Returning 0.0f");
        return 0.0f;
    }
    
    NSArray *judgementSet = [NSArray arrayWithArray:[data.userObservationComponentDataJudgement allObjects]];
    
    if(!judgementSet){
        NSLog(@"ERROR: judgementSet is nil. Returning 0.0f");
        return 0.0f;
    }
    else if (judgementSet.count < 1){
        NSLog(@"There is no judgement associated with this data. Returning 0.0f");
        return 0.0f;
    }
    else if (judgementSet.count > 1){
        NSLog(@"There is currently more than one judgement associated with this data. This is probably a feature that needs to be implemented in the future. Currently returning 0.0f");
        return 0.0f;
    }
    
    UserObservationComponentDataJudgement *judgement = [judgementSet objectAtIndex:0];
    
    if (!judgement) {
        NSLog(@"ERROR: judgement for this data is nil, when it shouldn't be. Returning 0.0f");
        return 0.0f;
    }
    
    NSArray *componentPossibilities = [NSArray arrayWithArray:[judgement.projectComponentPossibilities allObjects]];
    
    if (!componentPossibilities) {
        NSLog(@"ERROR: componentPossibilities is nil. Returning 0.0f");
        return 0.0f;
    }
    else if (componentPossibilities.count < 1){
        NSLog(@"ERROR: componentPossibilities doesn't have any values, when it should have 1. Returning 0.0f");
        return 0.0f;
    }
    else if (componentPossibilities.count > 1){
        NSLog(@"ERROR: componentPossibilities has more than one value, when it should have 1. Returning 0.0f");
        return 0.0f;
    }
    
    ProjectComponentPossibility *possibility = [componentPossibilities objectAtIndex:0];
    
    if(!possibility){
        NSLog(@"ERROR: possibility is nil. Returning 0.0f");
        return 0.0f;
    }
    
    //NSLog(@"Checking if identification: %@ has possibility: %@", identification.title, possibility.enumValue);
        
    NSArray *pairs = [NSArray arrayWithArray:[identification.projectIdentificationComponentPossibilities allObjects]];
    for (int i = 0; i < pairs.count; i++) {
        ProjectIdentificationComponentPossibility *pair = [pairs objectAtIndex:i];
        ProjectComponentPossibility *possibilityToCompare = pair.projectComponentPossibility;
        ProjectComponent *componentToCompare = possibilityToCompare.projectComponent;
        if([component.title isEqualToString:componentToCompare.title] && [possibilityToCompare.enumValue isEqualToString:@""]){
            //NSLog(@"Identification: %@ has nil possibility. Adding 0.9 to its score.", identification.title);
            int nils = [identification.numOfNils intValue];
            nils++;
            identification.numOfNils = [NSNumber numberWithInt:nils];
            return NIL_SCORE;
        }
        else if([possibilityToCompare.enumValue isEqualToString:possibility.enumValue]){
            //NSLog(@"Identification: %@ has possibility: %@. Adding 1 to its score.", identification.title, possibility.enumValue);
            return ENUM_SCORE;
        }
    }
    
    return 0.0f;
}

-(float)getBoolScoreForComponent:(ProjectComponent *)component withIdentification:(ProjectIdentification *)identification{
    NSArray *userData = [NSArray arrayWithArray:[component.userObservationComponentData allObjects]];
    
    if(!userData){
        NSLog(@"ERROR: userData is nil. Returning 0.0f");
        return 0.0f;
    }
    else if(userData.count < 1){
        NSLog(@"ERROR: There is no data associated with this component. Returning 0.0f");
        return 0.0f;
    }
    else if (userData.count > 1){
        NSLog(@"There is currently more than one data object associated with this component. This is either an error, or a feature to be implemented in the future. Returning 0.0f");
        return 0.0f;
    }
    
    UserObservationComponentData *data = [userData objectAtIndex:0];
    
    if (!data) {
        NSLog(@"ERROR: data for this component is nil. Returning 0.0f");
        return 0.0f;
    }
    
    NSArray *judgementSet = [NSArray arrayWithArray:[data.userObservationComponentDataJudgement allObjects]];
    
    if(!judgementSet){
        NSLog(@"ERROR: judgementSet is nil. Returning 0.0f");
        return 0.0f;
    }
    else if (judgementSet.count < 1){
        NSLog(@"There is no judgement associated with this data. Returning 0.0f");
        return 0.0f;
    }
    else if (judgementSet.count > 1){
        NSLog(@"There is currently more than one judgement associated with this data. This is probably a feature that needs to be implemented in the future. Currently returning 0.0f");
        return 0.0f;
    }
    
    UserObservationComponentDataJudgement *judgement = [judgementSet objectAtIndex:0];
    
    if (!judgement) {
        NSLog(@"ERROR: judgement for this data is nil, when it shouldn't be. Returning 0.0f");
        return 0.0f;
    }
    
    NSArray *componentPossibilities = [NSArray arrayWithArray:[judgement.projectComponentPossibilities allObjects]];
    
    if (!componentPossibilities) {
        NSLog(@"ERROR: componentPossibilities is nil. Returning 0.0f");
        return 0.0f;
    }
    else if (componentPossibilities.count < 1){
        NSLog(@"ERROR: componentPossibilities doesn't have any values, when it should have 1. Returning 0.0f");
        return 0.0f;
    }
    else if (componentPossibilities.count > 1){
        NSLog(@"ERROR: componentPossibilities has more than one value, when it should have 1. Returning 0.0f");
        return 0.0f;
    }
    
    ProjectComponentPossibility *possibility = [componentPossibilities objectAtIndex:0];
    
    if(!possibility){
        NSLog(@"ERROR: possibility is nil. Returning 0.0f");
        return 0.0f;
    }
    
    NSArray *pairs = [NSArray arrayWithArray:[identification.projectIdentificationComponentPossibilities allObjects]];
    for (int i = 0; i < pairs.count; i++) {
        ProjectIdentificationComponentPossibility *pair = [pairs objectAtIndex:i];
        ProjectComponentPossibility *possibilityToCompare = pair.projectComponentPossibility;
        ProjectComponent *componentToCompare = possibilityToCompare.projectComponent;
        //NSLog(@"PAIR Identification: %@ Possibility: %@", identification.title, possibilityToCompare.enumValue);
        if([component.title isEqualToString:componentToCompare.title] && [possibilityToCompare.enumValue isEqualToString:@""]){
            //NSLog(@"Identification: %@ has nil possibility. Adding 0.9 to its score.", identification.title);
            int nils = [identification.numOfNils intValue];
            nils++;
            identification.numOfNils = [NSNumber numberWithInt:nils];
            return NIL_SCORE;
        }
        else if ([possibilityToCompare.boolValue boolValue] == [possibility.boolValue boolValue] && [component.title isEqualToString:componentToCompare.title]) {
            //NSLog(@"Identification: %@ has possibility: %@. Adding 1 to its score.", identification.title, possibility.boolValue);
            return BOOL_SCORE;
        }
    }
    
    
    return 0.0f;
}
@end
