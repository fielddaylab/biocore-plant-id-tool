//
//  InterpretationDiscussionViewController.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 8/6/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "InterpretationDiscussionViewController.h"
#import "AppModel.h"

@interface InterpretationDiscussionViewController (){
    NSMutableArray *posts;
}

@end

@implementation InterpretationDiscussionViewController
@synthesize discussion;
@synthesize identification;
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        posts = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = discussion.title;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(makeNewPost)];
    [self.navigationItem setRightBarButtonItem:addButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ProjectIdentificationDiscussionPost *post = [posts objectAtIndex:indexPath.row];
    User *user = post.user;
    
    cell.textLabel.text = post.text;
    cell.detailTextLabel.text = user.name;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)makeNewPost{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    [attributes setObject:@"Hey this is some test text" forKey:@"text"];
    [attributes setObject:discussion forKey:@"projectIdentificationDiscussion"];
    [attributes setObject:identification forKey:@"projectIdentification"];
    ProjectIdentificationDiscussionPost *post = [[AppModel sharedAppModel] createNewProjectIdentificationDiscussionPostWithAttributes:attributes];
    [posts addObject:post];
    [self.table reloadData];
}

@end
