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
#import "ComponentSwitch.h"
#import "UserObservationIdentification.h"
#import "MediaManager.h"
#import "InterpretationInformationViewController.h"

#define ENUM_SCORE 1.0
#define NIL_SCORE 1.0
#define BOOL_SCORE 1.0

@interface ObservationViewController ()<UIAlertViewDelegate, CreateUserIdentificationDelegate>{
    NSMutableArray *projectComponents;
    NSMutableArray *projectIdentifications;
    NSMutableArray *requiredComImages;
    NSMutableArray *optionalComImages;
    NSMutableArray *dataToFilter;
    NSMutableArray *requiredComponents;
    NSMutableArray *optionalComponents;
    UserObservation *observation;
    int requiredFieldsFilledOut;
    
    NSMutableArray *metadata;
    NSMutableArray *requiredCheckmarkImageViews;
    NSMutableArray *optionalCheckmarkImageViews;
}

@end

@implementation ObservationViewController

@synthesize table;
@synthesize newObservation;
@synthesize prevObservation;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectComponentsResponseReady) name:@"ProjectComponentsResponseReady" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectIdentificationsResponseReady) name:@"ProjectIdentificationsResponseReady" object:nil];
        dataToFilter = [[NSMutableArray alloc]init];
        
        requiredComponents = [[NSMutableArray alloc]init];
        optionalComponents = [[NSMutableArray alloc]init];
        requiredComImages = [[NSMutableArray alloc] init];
        optionalComImages = [[NSMutableArray alloc] init];
        requiredCheckmarkImageViews = [[NSMutableArray alloc] init];
        optionalCheckmarkImageViews = [[NSMutableArray alloc] init];
        requiredFieldsFilledOut = 0;
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    metadata = [[NSMutableArray alloc]initWithArray:[self getMetadata]];
    
    [table reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(popToObservationScreen)];
    self.navigationItem.RightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ID" style:UIBarButtonItemStyleBordered target:self action:@selector(pushInterpretationViewController)];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    if(newObservation){
        [[AppModel sharedAppModel]getAllProjectComponentsWithHandler:@selector(handleFetchAllProjectComponentsForProjectName:) target:[AppModel sharedAppModel]];
        [[AppModel sharedAppModel]getAllProjectIdentificationsWithHandler:@selector(handleFetchProjectIdentifications:) target:[AppModel sharedAppModel]];
        
        //get the location here
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
        [attributes setValue:self.title forKey:@"identificationString"];
        observation = [[AppModel sharedAppModel] createNewUserObservationWithAttributes:attributes];
        observation.latitude = [NSNumber numberWithFloat:locationManager.location.coordinate.latitude];
        observation.longitude = [NSNumber numberWithFloat:locationManager.location.coordinate.longitude];
        observation.locationAccuracy = [NSNumber numberWithFloat:locationManager.location.horizontalAccuracy];
        observation.created = [NSDate date];
        observation.updated = [NSDate date];
        [AppModel sharedAppModel].currentUserObservation = observation;
        [[AppModel sharedAppModel] save];
    }
    else{
        observation = prevObservation;
        NSArray *dataSet = [observation.userObservationComponentData allObjects];
        UIImage *checkmarkImage = [[MediaManager sharedMediaManager] getImageNamed:@"17-checkGREEN"];
        //create the identifications
        if(dataSet){
            for (int i = 0; i < dataSet.count; i++) {
                UserObservationComponentData *data = [dataSet objectAtIndex:i];
                if ([data.wasJudged boolValue] && [data.isFiltered boolValue]) {
                    [dataToFilter addObject:data];
                }
                ProjectComponent *component = data.projectComponent;
                [projectComponents addObject:component];
                UIImageView *checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(35, 19, 25, 25)];
                checkmark.image = checkmarkImage;
                if([component.required boolValue]){
                    requiredFieldsFilledOut++;
                    [requiredComponents addObject:component];
                    UIImage *requiredImage = [self loadImageForComponent:component];
                    [requiredComImages addObject:requiredImage];
                    [requiredCheckmarkImageViews addObject:checkmark];
                }
                else{
                    [optionalComponents addObject:component];
                    UIImage *optionalImage = [self loadImageForComponent:component];
                    [optionalComImages addObject:optionalImage];
                    [optionalCheckmarkImageViews addObject:checkmark];
                }
            }
        }
        
        [[AppModel sharedAppModel]getAllProjectIdentificationsWithHandler:@selector(handleFetchProjectIdentifications:) target:[AppModel sharedAppModel]];
    }
    
}

-(void)popToObservationScreen{
    if (requiredFieldsFilledOut == requiredComponents.count) {
        if (newObservation) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save and Lock" message:@"Once you save this observation it cannot be changed." delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Keep Editing", nil];
            alert.tag = 0;
            [alert show];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Required Fields Not Filled Out!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    observation.identificationString = self.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)pushInterpretationViewController{
    InterpretationChoiceViewController *vc = [[InterpretationChoiceViewController alloc]initWithNibName:@"InterpretationChoiceViewController" bundle:nil];
    vc.projectIdentifications = projectIdentifications;
    vc.dataToFilter = dataToFilter;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [requiredComponents count];
        case 1:
            return [optionalComponents count];
        case 2:
            return 3;
        default:
            return 0;
    };
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //update the title of the view
    //    int identifications = [projectIdentifications count];
    //    if(dataToFilter.count > 0){
    //        identifications = 0;
    //        for (int i = 0; i < projectIdentifications.count; i++) {
    //            ProjectIdentification *iden = [projectIdentifications objectAtIndex:i];
    //            if([iden.score floatValue] >= .8){
    //                identifications++;
    //            }
    //        }
    //    }
    //
    //    if (observation.userObservationIdentifications.count < 1) {
    //        self.title = identifications != 1 ?[NSString stringWithFormat:@"%d possible matches", identifications] : [NSString stringWithFormat:@"%d possible match", 1];
    //    }
    //    else{
    //        NSArray *userIdentificationArray = [observation.userObservationIdentifications allObjects];
    //        UserObservationIdentification *userIdentification = [userIdentificationArray objectAtIndex:0];
    //        ProjectIdentification *projectIdentification = userIdentification.projectIdentification;
    //        self.title = projectIdentification.alternateName;
    //    }
    
    
    //Make the identifier unique to that row so cell pictures don't get reused in funky ways.
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ProjectComponent *com;
    UIImage *comImage;
    UIImageView *checkmark;
    
    switch (indexPath.section) {
            
        case 0:
        case 1:{
            
            if (indexPath.section == 0) {
                com = (ProjectComponent *)[requiredComponents objectAtIndex:indexPath.row];
                comImage = (UIImage *)[requiredComImages objectAtIndex:indexPath.row];
                checkmark = (UIImageView *)[requiredCheckmarkImageViews objectAtIndex:indexPath.row];
            }
            else{
                com = (ProjectComponent *)[optionalComponents objectAtIndex:indexPath.row];
                comImage = (UIImage *)[optionalComImages objectAtIndex:indexPath.row];
                checkmark = (UIImageView *)[optionalCheckmarkImageViews objectAtIndex:indexPath.row];
            }
            
            
            
            UserObservationComponentData *data = [self findDataForComponent:com];
            if(data){
                cell = [tableView dequeueReusableCellWithIdentifier:@"Data"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Data"];
                }
                [cell addSubview:checkmark];
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@", com.title];
            cell.detailTextLabel.text = @"Not Interpreted";
            
            
            if ([data.wasJudged boolValue]) {
                
                if([com.filter boolValue]){
                    cell = [tableView dequeueReusableCellWithIdentifier:@"Judgement"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Judgement"];
                        ComponentSwitch *boolSwitch = [[ComponentSwitch alloc]initWithFrame:CGRectZero];
                        [boolSwitch addTarget:self action:@selector(toggleFilter:) forControlEvents:UIControlEventValueChanged];
                        cell.accessoryView = boolSwitch;
                    }
                    [cell addSubview:checkmark];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@", com.title];
                    
                    ComponentSwitch *boolSwitch = (ComponentSwitch *)cell.accessoryView;
                    if(data && [data.isFiltered boolValue]){
                        [boolSwitch setOn:YES animated:NO];
                    }
                    boolSwitch.data = data;
                    
                }
                
                NSArray *judgementSet = [data.userObservationComponentDataJudgement allObjects];
                UserObservationComponentDataJudgement *judgement = judgementSet[0];
                
                if(com.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_BOOLEAN]){
                    cell.detailTextLabel.text = judgement.boolValue == [NSNumber numberWithInt:1] ?[NSString stringWithFormat:@"True"] : [NSString stringWithFormat:@"False"];
                }
                else if(com.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_NUMBER]){
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", judgement.number];
                }
                else if(com.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_ENUMERATOR]){
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", judgement.enumValue];
                }
                else if (com.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_TEXT]){
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", judgement.text];
                }
                else if (com.observationJudgementType == [NSNumber numberWithInt:JUDGEMENT_LONG_TEXT]){
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", judgement.longText];
                }
                
                
            }
            
            cell.imageView.image = comImage;
            
        }break;
        case 2:{
            
            cell.userInteractionEnabled = NO;
            
            if (newObservation) {
                if(indexPath.row == 0){
                    cell.textLabel.text = @"Author";
                    cell.detailTextLabel.text = [metadata objectAtIndex:0];
                    
                }
                else if(indexPath.row == 1){
                    cell.textLabel.text = @"Date";
                    cell.detailTextLabel.text = [metadata objectAtIndex:1];
                    
                }
                else if(indexPath.row == 2){
                    cell.textLabel.text = @"Location";
                    cell.detailTextLabel.text = [metadata objectAtIndex:2];
                    
                }
            }
            else{
                if(indexPath.row == 0){
                    cell.textLabel.text = @"Author";
                    cell.detailTextLabel.text = observation.user.name;
                    
                }
                else if(indexPath.row == 1){
                    cell.textLabel.text = @"Date";
                    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:observation.updated
                                                                               dateStyle:NSDateFormatterShortStyle
                                                                               timeStyle:NSDateFormatterFullStyle];
                    
                }
                else if(indexPath.row == 2){
                    cell.textLabel.text = @"Location";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Lat: %f, Long: %f", [observation.latitude floatValue], [observation.longitude floatValue]];
                    
                }
            }
            
        }break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 || indexPath.section == 1){
        
        ObservationContainerViewController *containerView = [[ObservationContainerViewController alloc]init];
        
        ProjectComponent *projectComponent;
        if(indexPath.section == 0){
            projectComponent = [requiredComponents objectAtIndex:indexPath.row];
        }
        else{
            projectComponent = [optionalComponents objectAtIndex:indexPath.row];
        }
        UserObservationComponentData *prevData = [self findDataForComponent:projectComponent];
        containerView.prevData = prevData;
        containerView.projectComponent = projectComponent;
        containerView.newObservation = newObservation;
        containerView.dismissDelegate = self;
        
        
        [self.navigationController pushViewController:containerView animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    switch (section) {
        case 0:
            return @"Required Components";
            break;
        case 1:
            return @"Optional Components";
        case 2:
            return @"Metadata";
        default:
            return @"Error :'[";
            break;
    }
    
}

#pragma mark - Asynchronous responses

-(void)projectComponentsResponseReady{

    projectComponents = [NSMutableArray arrayWithArray:[AppModel sharedAppModel].currentProjectComponents];
    
    for (int i = 0; i < [projectComponents count]; i++) {
        ProjectComponent *com = [projectComponents objectAtIndex:i];
        if([com.required boolValue]){
            [requiredComponents addObject:com];
        }
        else{
            [optionalComponents addObject:com];
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [requiredComponents sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [optionalComponents sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    UIImage *checkmarkImage = [[MediaManager sharedMediaManager] getImageNamed:@"17-checkGREEN"];
    
    for (int i = 0; i < [requiredComponents count]; i++){
        ProjectComponent *com = [requiredComponents objectAtIndex:i];
        UIImage *componentImage = [self loadImageForComponent:com];
        UIImageView *checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(35, 19, 25, 25)];
        checkmark.image = checkmarkImage;
        
        [requiredComImages addObject:componentImage];
        [requiredCheckmarkImageViews addObject:checkmark];
    }
    
    for (int i = 0; i < [optionalComponents count]; i++){
        ProjectComponent *com = [optionalComponents objectAtIndex:i];
        UIImage *componentImage = [self loadImageForComponent:com];
        UIImageView *checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(35, 19, 25, 25)];
        checkmark.image = checkmarkImage;
        
        [optionalComImages addObject:componentImage];
        [optionalCheckmarkImageViews addObject:checkmark];
    }
    
    [self.table reloadData];
}

-(UIImage *)loadImageForComponent:(ProjectComponent *)com{
    NSString *projectComponentTitleString = com.title;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    projectComponentTitleString = [[projectComponentTitleString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
    projectComponentTitleString = [projectComponentTitleString stringByAppendingString:@".png"];
    return [[MediaManager sharedMediaManager] imageWithImage:[[MediaManager sharedMediaManager] getImageNamed:projectComponentTitleString] scaledToSize:CGRectMake(0, 0, 40, 40).size];
}

-(void)projectIdentificationsResponseReady{
    projectIdentifications = [NSMutableArray arrayWithArray:[AppModel sharedAppModel].allProjectIdentifications];
    [self rankIdentifications];
    //[self performSelectorInBackground:@selector(rankIdentifications) withObject:self];
    [self.table reloadData];
}

- (void)dismissContainerViewAndSetProjectComponentObserved:(UserObservationComponentData *)data{
    
    dataToFilter = [[NSMutableArray alloc]init];
    requiredFieldsFilledOut = 0;
    NSArray *dataSet = [observation.userObservationComponentData allObjects];
    for (int i = 0; i < dataSet.count; i++) {
        UserObservationComponentData *currData = [dataSet objectAtIndex:i];
        ProjectComponent *associateProjCom;
        if (currData) {
            associateProjCom = currData.projectComponent;
            if ([associateProjCom.required boolValue]) {
                requiredFieldsFilledOut++;
            }
        }
        if ([currData.wasJudged boolValue] && [associateProjCom.filter boolValue]) {
            [dataToFilter addObject:currData];
        }
    }
    [self rankIdentifications];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(UserObservationComponentData *)filterHasProjectComponentTitle:(NSString *)title{
    for (int i = 0; i < dataToFilter.count; i++) {
        UserObservationComponentData *currData = [dataToFilter objectAtIndex:i];
        ProjectComponent *currCom = currData.projectComponent;
        //NSLog(@"Comparing %@ and %@", currCom.title, title);
        if ([currCom.title isEqualToString:title]) {
            return currData;
        }
    }
    return nil;
}


-(void)rankIdentifications{
    NSLog(@"Filtering on %lu components", (unsigned long)dataToFilter.count);
    NSArray *allProjectIdentifications = [AppModel sharedAppModel].allProjectIdentifications;
    for (int i = 0; i < allProjectIdentifications.count; i++) {
        ProjectIdentification *identification = [allProjectIdentifications objectAtIndex:i];
        identification.score = [NSNumber numberWithFloat:0.0f];
        identification.numOfNils = [NSNumber numberWithInt:0];
        for (int j = 0; j < dataToFilter.count; j++) {
            UserObservationComponentData *currData = [dataToFilter objectAtIndex:j];
            ProjectComponent *component = currData.projectComponent;
            switch ([component.observationJudgementType intValue]) {
                case JUDGEMENT_BOOLEAN:{
                    float score = [identification.score floatValue];
                    score += [self getBoolScoreForData:currData withIdentification:identification];
                    identification.score = [NSNumber numberWithFloat:score];
                }
                    break;
                case JUDGEMENT_ENUMERATOR:{
                    float score = [identification.score floatValue];
                    score += [self getEnumScoreForData:currData withIdentification:identification];
                    identification.score = [NSNumber numberWithFloat:score];
                }
                    break;
                case JUDGEMENT_NUMBER:{
                    float score = [identification.score floatValue];
                    score += [self getNumberScoreForData:currData withIdentification:identification];
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
    int possibleIdentifications = projectIdentifications.count;
    if (dataToFilter.count > 0) {
        possibleIdentifications = 0;
        for (int i = 0; i < allProjectIdentifications.count; i++) {
            ProjectIdentification *identification = [allProjectIdentifications objectAtIndex:i];
            float score = [identification.score floatValue];
            float scaledScore = score / [dataToFilter count];
            float roundedScore = floorf(scaledScore * 100 + 0.5) / 100;
            identification.score = [NSNumber numberWithFloat:roundedScore];
            if ([identification.score floatValue] > .8) {
                possibleIdentifications++;
            }
        }
    }
    
    
    self.title = possibleIdentifications != 1 ?[NSString stringWithFormat:@"%d possible matches", possibleIdentifications] : [NSString stringWithFormat:@"%d possible match", 1];
    
    //sort array
    NSSortDescriptor *scoreDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSSortDescriptor *nilsDescriptor = [[NSSortDescriptor alloc] initWithKey:@"numOfNils" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:scoreDescriptor, nilsDescriptor, nil];
    NSArray *sortedIdentifications = [allProjectIdentifications sortedArrayUsingDescriptors:descriptors];
    
    //for debugging purposes
    //    for (int i = 0; i < sortedIdentifications.count; i++) {
    //        ProjectIdentification *identification = [sortedIdentifications objectAtIndex:i];
    //        int numberOfNils = [identification.numOfNils intValue];
    //        NSLog(@"%i: %@ with score %@ and %i nils. Sorting on %lu components", i, identification.title, identification.score, numberOfNils, (unsigned long)dataToFilter.count);
    //    }
    
    projectIdentifications = [NSArray arrayWithArray:sortedIdentifications];
    [[AppModel sharedAppModel]save];
}

-(float)getNumberScoreForData:(UserObservationComponentData *)data withIdentification:(ProjectIdentification *)identification{
    
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
    
    ProjectComponent *currComponent = data.projectComponent;
    NSArray *componentPossibilities = [currComponent.projectComponentPossibilities allObjects];
    
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
    ProjectComponent *component = data.projectComponent;
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


-(float)getEnumScoreForData:(UserObservationComponentData *)data withIdentification:(ProjectIdentification *)identification{
    
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
    
    ProjectComponentPossibility *possibility = judgement.projectComponentPossibility;
    
    if(!possibility){
        NSLog(@"ERROR: possibility is nil. Returning 0.0f");
        return 0.0f;
    }
    
    //NSLog(@"Checking if identification: %@ has possibility: %@", identification.title, possibility.enumValue);
    ProjectComponent *component = data.projectComponent;
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

-(float)getBoolScoreForData:(UserObservationComponentData *)data withIdentification:(ProjectIdentification *)identification{
    
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
    
    ProjectComponentPossibility *possibility = judgement.projectComponentPossibility;
    
    if(!possibility){
        NSLog(@"ERROR: possibility is nil. Returning 0.0f");
        return 0.0f;
    }
    
    ProjectComponent *component = data.projectComponent;
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

-(void)toggleFilter:(id)sender{
    ComponentSwitch *boolSwitch = (ComponentSwitch *)sender;
    UserObservationComponentData *data = boolSwitch.data;
    if (boolSwitch.isOn) {
        [dataToFilter addObject:data];
    }
    else{
        [dataToFilter removeObject:data];
    }
    [self rankIdentifications];
    //[self performSelectorInBackground:@selector(rankIdentifications) withObject:self];
    data.isFiltered = [NSNumber numberWithBool:boolSwitch.isOn];
    [[AppModel sharedAppModel] save];
}

-(UserObservationComponentData *)findDataForComponent:(ProjectComponent *)com{
    NSArray *dataSet = [observation.userObservationComponentData allObjects];
    for (int i = 0; i < dataSet.count; i++) {
        UserObservationComponentData *tempData = [dataSet objectAtIndex:i];
        if([tempData.projectComponent.title isEqualToString:com.title]){
            return tempData;
        }
    }
    return nil;
}

#pragma mark - Metadata

- (NSMutableArray*) getMetadata{
    NSMutableArray *metadataToSend = [[NSMutableArray alloc]init];
    
    //User
    NSLog(@"User: %@", observation.user.name);
    [metadataToSend addObject:observation.user.name];
    
    //Date
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    [metadataToSend addObject:dateString];
    
    //Location
    NSLog(@"Lat: %f , LONG: %f",locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    [metadataToSend addObject:[NSString stringWithFormat:@"Lat: %f, Long: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude]];
    
    //Weather
    
    return metadataToSend;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    [table reloadData];
}

#pragma mark make an identification
-(void)makeIdentification:(ProjectIdentification *)projectIdentification{
    if (observation.userObservationIdentifications.count > 0) {
        NSArray *userIdentificationSet = [observation.userObservationIdentifications allObjects];
        UserObservationIdentification *userIdentification = [userIdentificationSet objectAtIndex:0];
        [self removeIdentification:userIdentification];
    }
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    UserObservationIdentification *userIdentification = [[AppModel sharedAppModel] createNewUserObservationIdentificationWithProjectIdentification:projectIdentification withAttributes:attributes];
    NSSet *userIdentifications = [NSSet setWithObject:userIdentification];
    observation.userObservationIdentifications = userIdentifications;
    [AppModel sharedAppModel].currentUserObservation = observation;
    [[AppModel sharedAppModel] save];
    [self.navigationController popToViewController:self animated:YES];
}

-(void)removeIdentification:(UserObservationIdentification *)userIdentificationToDelete{
    NSMutableSet *userIdentifications = [NSMutableSet setWithSet:observation.userObservationIdentifications];
    [userIdentifications removeObject:userIdentificationToDelete];
    observation.userObservationIdentifications = userIdentifications;
    [AppModel sharedAppModel].currentUserObservation = observation;
    [[AppModel sharedAppModel] deleteObject:userIdentificationToDelete];
    [[AppModel sharedAppModel] save];
    [self.navigationController popToViewController:self animated:YES];
}

@end
