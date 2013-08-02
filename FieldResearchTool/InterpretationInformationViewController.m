//
//  InterpretationInformationViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/2/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "InterpretationInformationViewController.h"

@interface InterpretationInformationViewController (){
    NSMutableArray *identificationInformation;
    UIImageView *identificationGallery;
}

@end

@implementation InterpretationInformationViewController

@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    identificationInformation = [[NSMutableArray alloc]init];
    
    identificationGallery = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 252.0f)];//252 because tableview in xib is fixed at that. (for now)

    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *a = @"Look-alikes";
    NSString *b = @"Uses";
    NSString *c = @"Fun Facts";
    [identificationInformation addObject:[NSString stringWithString:a]];
    [identificationInformation addObject:[NSString stringWithString:b]];
    [identificationInformation addObject:[NSString stringWithString:c]];

    NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"MAX_Height_of_stem"], [UIImage imageNamed:@"MAX_length_of_flower_cluster"], nil];
    
    //[identificationGallery initWithImage:[UIImage imageNamed:@"page.png"]];
    identificationGallery.animationImages = arr;
    identificationGallery.animationDuration = 5.0f;
    //identificationGallery.image = [UIImage imageNamed:@"MAX_Height_of_stem"];
    [self.view addSubview:identificationGallery];
    [identificationGallery startAnimating];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            cell.textLabel.text = [NSString stringWithFormat:@"%@",identificationInformation[indexPath.row]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",identificationInformation[indexPath.row]];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",identificationInformation[indexPath.row]];
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
