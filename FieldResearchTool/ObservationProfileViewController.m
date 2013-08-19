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
    NSMutableDictionary *sections;
    NSArray *sortedDays;
    NSDateFormatter *sectionDateFormatter;
    NSDateFormatter *cellDateFormatter;
}

@end

@implementation ObservationProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    //Group navbar buttons here to get rectangle style
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)]];
    
    sectionDateFormatter = [[NSDateFormatter alloc] init];
    [sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    cellDateFormatter = [[NSDateFormatter alloc] init];
    [cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];

}

-(void)viewWillAppear:(BOOL)animated{
    [[AppModel sharedAppModel] getUserObservationsForCurrentUserWithHandler:@selector(handleFetchOfUserObservations:) target:self];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) logout
{
    UIAlertView *logoutAlert = [[UIAlertView alloc]initWithTitle:@"Logout" message:@"Are you sure you wish to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
    [logoutAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) makeNewObservation
{
    ObservationViewController *observationVC = [[ObservationViewController alloc]initWithNibName:@"ObservationViewController" bundle:nil];
    observationVC.newObservation = YES;
    observationVC.prevObservation = nil;
    [self.navigationController pushViewController:observationVC animated:YES];
}

#pragma mark - table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDate *dateRepresentingThisDay = [sortedDays objectAtIndex:section];
    NSArray *observationsThisDay = [sections objectForKey:dateRepresentingThisDay];
    return observationsThisDay.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [sortedDays objectAtIndex:section];
    return [sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    NSDate *dateRepresentingThisDay = [sortedDays objectAtIndex:indexPath.section];
    NSArray *observationsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
    UserObservation *currObservation = [observationsOnThisDay objectAtIndex:indexPath.row];
    
    cell.textLabel.text = currObservation.identificationString;
    cell.detailTextLabel.text = [cellDateFormatter stringFromDate:currObservation.created];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDate *dateRepresentingThisDay = [sortedDays objectAtIndex:indexPath.section];
    NSArray *observationsThisDay = [sections objectForKey:dateRepresentingThisDay];
    UserObservation *observation = [observationsThisDay objectAtIndex:indexPath.row];    
    ObservationViewController *observationVC = [[ObservationViewController alloc]initWithNibName:@"ObservationViewController" bundle:nil];
    observationVC.newObservation = NO;
    observationVC.prevObservation = observation;
    [AppModel sharedAppModel].currentUserObservation = observation;
    [self.navigationController pushViewController:observationVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDate *dateRepresentingThisDay = [sortedDays objectAtIndex:indexPath.section];
        NSMutableArray *observationsThisDay = [sections objectForKey:dateRepresentingThisDay];
        UserObservation *obsToDelete = [observationsThisDay objectAtIndex:indexPath.row];
        [observationsThisDay removeObject:obsToDelete];
        [[AppModel sharedAppModel] deleteObject:obsToDelete];
        [self.table reloadData];
    }
}

#pragma mark handle fetch of user observations
-(void)handleFetchOfUserObservations:(NSArray *)observations{
    NSMutableArray *tempObservations = [(NSArray*)observations mutableCopy];
    for (int i = 0; i < tempObservations.count; i++) {
        UserObservation *currObservation = [tempObservations objectAtIndex:i];
        if (!currObservation.identificationString) {
            [tempObservations removeObject:currObservation];
            [[AppModel sharedAppModel] deleteObject:currObservation];
        }
    }
    
    sections = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < tempObservations.count; i++) {
        UserObservation *currObservation = [tempObservations objectAtIndex:i];
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:currObservation.created];
        
        NSMutableArray *eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
        if (!eventsOnThisDay) {
            eventsOnThisDay = [NSMutableArray array];
            
            [sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
        }
        
        [eventsOnThisDay addObject:currObservation];
    }
    
    NSArray *unsortedDays = [sections allKeys];
    sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    
    [self.table reloadData];
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}


@end
