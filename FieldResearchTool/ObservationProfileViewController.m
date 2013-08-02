//
//  ObservationProfileViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/2/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "ObservationProfileViewController.h"

#import "ObservationViewController.h"


@interface ObservationProfileViewController (){
    NSMutableArray *profileObservations;
}

@end

@implementation ObservationProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    profileObservations = [[NSMutableArray alloc]initWithObjects:@"Observation 1", @"Observation 2", @"Observation 3", nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(makeNewObservation)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeNewObservation
{
    ObservationViewController *observationVC = [[ObservationViewController alloc]initWithNibName:@"ObservationViewController" bundle:nil];
    [self.navigationController pushViewController:observationVC animated:YES];
    
}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",profileObservations[indexPath.row]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",profileObservations[indexPath.row]];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",profileObservations[indexPath.row]];
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
