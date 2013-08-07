//
//  InterpretationInformationViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/2/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "InterpretationInformationViewController.h"
#import "AppModel.h"
#import "ProjectIdentificationDiscussion.h"
#import "InterpretationDiscussionViewController.h"

#define PICTURE_OFFSET 252

@interface InterpretationInformationViewController (){
    NSMutableArray *identificationInformation;
    UIImageView *identificationGallery;
    UIScrollView *scrollView;
    UIWebView *webView;
}

@end

@implementation InterpretationInformationViewController
@synthesize identification;
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    identificationInformation = [[NSMutableArray alloc]init];
    
    identificationGallery = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, PICTURE_OFFSET)];//252 because tableview in xib is fixed at that. (for now)
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 252)];

    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, PICTURE_OFFSET, 320, [UIScreen mainScreen].bounds.size.height - 252 - 64)];//Will need to do javascript stuffs to make webview better.
    
    //NSLog(@"%@",identification.title);

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AppModel sharedAppModel] getProjectIdentificationDiscussionsWithHandler:@selector(handleDiscussionRetrieval:) target:self];
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"MAX_Height_of_stem"], [UIImage imageNamed:@"MAX_length_of_flower_cluster"], nil];
    
    //[identificationGallery initWithImage:[UIImage imageNamed:@"page.png"]];
    identificationGallery.animationImages = arr;
    identificationGallery.animationDuration = 10.0f;
    //identificationGallery.image = [UIImage imageNamed:@"MAX_Height_of_stem"];
    [self.view addSubview:identificationGallery];
    [identificationGallery startAnimating];
    
    //Placeholder for now. Aligns text correctly, and we'll need for later Identifying
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"UPL" style:UIBarButtonItemStyleDone target:self action:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 14.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@\n%@", identification.alternateName, identification.title];
    
    self.navigationItem.titleView = label;
        
    scrollView.contentSize = CGSizeMake(320, 2000);
    
    NSString *url=@"http://www.google.com";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    webView.scrollView.scrollEnabled = NO;
    [scrollView addSubview:webView];
    

}


- (void) method0{
    NSLog(@"METHOD WAS CLICKED: 0");
}
- (void) method2{
    NSLog(@"METHOD WAS CLICKED: 2");
}
- (void) method1{
    NSLog(@"METHOD WAS CLICKED: 1");
}


- (void) viewDidAppear:(BOOL)animated
{
    for (int i = 0; i < identificationInformation.count; i++) {
        ProjectIdentificationDiscussion *discussion = [identificationInformation objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:discussion.title forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, webView.bounds.size.height + 44*i, 320, 44)];//change webView bounds to some height determined by delegate javascript document.height kind of thing?
        [button addTarget:self
                   action:NSSelectorFromString([NSString stringWithFormat:@"method%d",i])
         forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
    }
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [identificationInformation count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ProjectIdentificationDiscussion *discussion = [identificationInformation objectAtIndex:indexPath.row];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = discussion.title;
            break;
        case 1:
            cell.textLabel.text = discussion.title;
            break;
        case 2:
            cell.textLabel.text = discussion.title;
            break;
            
        default:
            break;
    }
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InterpretationDiscussionViewController *discussionViewController = [[InterpretationDiscussionViewController alloc] initWithNibName:@"InterpretationDiscussionViewController" bundle:nil];
    ProjectIdentificationDiscussion *discussion = [identificationInformation objectAtIndex:indexPath.row];
    discussionViewController.discussion = discussion;
    discussionViewController.identification = identification;
    [self.navigationController pushViewController:discussionViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark handle the discussion retrieval
-(void)handleDiscussionRetrieval:(NSArray *)discussions{
    identificationInformation = [NSMutableArray arrayWithArray:discussions];
    [self.table reloadData];
}


@end
