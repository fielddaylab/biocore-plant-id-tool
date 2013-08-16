//
//  InterpretationChoiceViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 7/15/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "InterpretationChoiceViewController.h"
#import "ProjectIdentification.h"
#import "InterpretationInformationViewController.h"
#import "ObservationViewController.h"



@interface InterpretationChoiceViewController (){
    
    NSMutableArray *likelyChoices;
    NSMutableArray *unlikelyChoices;
    
}

@end

@implementation InterpretationChoiceViewController
@synthesize table;
@synthesize projectIdentifications;
@synthesize dataToFilter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    likelyChoices = [[NSMutableArray alloc]init];
    unlikelyChoices = [[NSMutableArray alloc]init];
    
    ProjectIdentification *identification;
    for (int i = 0; i < [projectIdentifications count]; i ++) {
        
        identification = [projectIdentifications objectAtIndex:i];
        
        if ([identification.score floatValue] > .8) {
            [likelyChoices addObject:identification];
        }
        else{
            [unlikelyChoices addObject:identification];
        }
    }
    
}

- (void) viewDidAppear:(BOOL)animated{
    [self.table reloadData];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [likelyChoices count];
        case 1:
            return [unlikelyChoices count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    ProjectIdentification *identification;
    
    switch (indexPath.section) {
        case 0:
            identification = [likelyChoices objectAtIndex:indexPath.row];
            break;
        case 1:
            identification = [unlikelyChoices objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = identification.alternateName;
    
    float decimal = [identification.score floatValue];
    float percent = decimal * 100;
    
    if(dataToFilter.count > 0){
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f percent match with %@ nil", percent, identification.numOfNils];
        
    }
    else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"No data to filter upon!"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InterpretationInformationViewController *interpretationInformationVC = [[InterpretationInformationViewController alloc]initWithNibName:@"InterpretationInformationViewController" bundle:nil];
    ProjectIdentification *identification = [projectIdentifications objectAtIndex:indexPath.row];
    interpretationInformationVC.identification = identification;
    ObservationViewController *prevVC = (ObservationViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    interpretationInformationVC.delegate = (id)prevVC;
    [self.navigationController pushViewController:interpretationInformationVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    switch (section) {
        case 0:
            
            if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
                return nil;
            } else {
                return @"Likely options";
            }
            
            break;
        case 1:
            
            if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
                return nil;
            } else {
                return @"Unlikely options";
            }
            
            break;
        default:
            return @"Error :'[";
            break;
    }
    
}

@end
