//
//  ObservationProfileViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/2/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationProfileViewController.h"
#import "ObservationViewController.h"
#import "AppModel.h"
#import "UserObservation.h"


@interface ObservationProfileViewController (){
    NSMutableArray *profileObservations;
}

@end

@implementation ObservationProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    profileObservations = [[NSMutableArray alloc]init];
    if (self) {
        self.title = @"My Observations";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(makeNewObservation)];
    [self.navigationItem setRightBarButtonItem:addButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [[AppModel sharedAppModel] getUserObservationsForCurrentUserWithHandler:@selector(handleFetchOfUserObservations:) target:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeNewObservation
{
    ObservationViewController *observationVC = [[ObservationViewController alloc]initWithNibName:@"ObservationViewController" bundle:nil];
    observationVC.newObservation = YES;
    observationVC.prevObservation = nil;
    [self.navigationController pushViewController:observationVC animated:YES];
}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [profileObservations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UserObservation *observation = [profileObservations objectAtIndex:indexPath.row];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = observation.identificationString;
            break;
        case 1:
            cell.textLabel.text = observation.identificationString;
            break;
        case 2:
            cell.textLabel.text = observation.identificationString;
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserObservation *observation = [profileObservations objectAtIndex:indexPath.row];
    ObservationViewController *observationVC = [[ObservationViewController alloc]initWithNibName:@"ObservationViewController" bundle:nil];
    observationVC.newObservation = NO;
    observationVC.prevObservation = observation;
    [AppModel sharedAppModel].currentUserObservation = observation;
    [self.navigationController pushViewController:observationVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark
-(void)handleFetchOfUserObservations:(NSArray *)observations{
    profileObservations = [NSMutableArray arrayWithArray:observations];
    [self.table reloadData];
}


@end
