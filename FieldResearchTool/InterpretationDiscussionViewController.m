//
//  InterpretationDiscussionViewController.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 8/6/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "InterpretationDiscussionViewController.h"
#import "AppModel.h"
#import "InterpretationDiscussionPostViewController.h"

@interface InterpretationDiscussionViewController ()<TextViewControlDelegate>{
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
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:identification.title forKey:@"projectIdentification.title"];
    [attributes setObject:discussion.title forKey:@"projectIdentificationDiscussion.title"];
    [[AppModel sharedAppModel] getProjectIdentificationDiscussionPostsWithAttributes:attributes withHandler:@selector(handleFetchOfDiscussionPosts:) target:self];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ProjectIdentificationDiscussionPost *post = [posts objectAtIndex:indexPath.row];
        [posts removeObject:post];
        [[AppModel sharedAppModel] deleteObject:post];
        [self.table reloadData];
    }
}

#pragma mark handle fetch of discussion posts
-(void)handleFetchOfDiscussionPosts:(NSArray *)discussionPosts{
    posts = [NSMutableArray arrayWithArray:discussionPosts];
    [self.table reloadData];
}

-(void)makeNewPost{
    InterpretationDiscussionPostViewController *postVC = [[InterpretationDiscussionPostViewController alloc] initWithNibName:@"InterpretationDiscussionPostViewController" bundle:nil];
    postVC.delegate = self;
    postVC.prevPost = nil;
    [self.navigationController  pushViewController:postVC animated:NO];
}

#pragma mark text field delegate methods
-(void)cancelled{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)textChosen:(NSString *)text{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    [attributes setObject:text forKey:@"text"];
    [attributes setObject:discussion forKey:@"projectIdentificationDiscussion"];
    [attributes setObject:identification forKey:@"projectIdentification"];
    ProjectIdentificationDiscussionPost *post = [[AppModel sharedAppModel] createNewProjectIdentificationDiscussionPostWithAttributes:attributes];
    [posts addObject:post];
    [self.table reloadData];

    [self.navigationController popViewControllerAnimated:NO];
}

@end
