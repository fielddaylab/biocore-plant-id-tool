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



@interface InterpretationChoiceViewController ()

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
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return projectIdentifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ProjectIdentification *identification = [projectIdentifications objectAtIndex:indexPath.row];
    cell.textLabel.text = identification.title;
    
    if(dataToFilter.count > 0){
        float decimal = [identification.score floatValue];
        float percent = decimal * 100;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%f percent match with %@ nil", percent, identification.numOfNils];
    }
    else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i percent match with %@ nil", 100, identification.numOfNils];
    }
    

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InterpretationInformationViewController *interpretationInformationVC = [[InterpretationInformationViewController alloc]initWithNibName:@"InterpretationInformationViewController" bundle:nil];
    ProjectIdentification *identification = [projectIdentifications objectAtIndex:indexPath.row];
    interpretationInformationVC.identification = identification;
    [self.navigationController pushViewController:interpretationInformationVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
