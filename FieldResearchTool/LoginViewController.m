//
//  LoginViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/12/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "LoginViewController.h"
#import "AppModel.h"

#import "ObservationProfileViewController.h"

#import "RegisterNewAccountViewController.h"


@interface LoginViewController (){
    CGRect viewRect;
    NSString *username;
    NSString *password;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UIAlertView *alert;
}

@end


@implementation LoginViewController

@synthesize table;

-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    viewRect = frame;
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = viewRect;
}

- (void)loadView
{
    
    [super loadView];
    
    self.navigationItem.title = @"Login";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setTitle:@"" forState:UIControlStateNormal];
    dismissButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:dismissButton];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 100) style:UITableViewStyleGrouped];
    table.scrollEnabled = NO;
    
    table.delegate = self;
    table.dataSource = self;
    
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:table];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton addTarget:self action:@selector(attemptLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Login!" forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(10.0, table.bounds.size.height, 300.0, 40.0);
    [self.view addSubview:loginButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerButton addTarget:self action:@selector(registerNewAccount) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"Join now!" forState:UIControlStateNormal];
    registerButton.frame = CGRectMake(10.0, table.bounds.size.height + loginButton.bounds.size.height, 300.0, 40.0);
    [self.view addSubview:registerButton];
    
    alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a valid username and password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerNewAccount{
    RegisterNewAccountViewController *registerNewAccountVC = [[RegisterNewAccountViewController alloc]initWithFrame:self.view.bounds];
    [self.navigationController pushViewController:registerNewAccountVC animated:YES];
}

- (void)attemptLogin{
    username = usernameTextField.text;
    password = passwordTextField.text;
    NSLog(@"USER: %@ PASS: %@",username, password);
    
    if ([username length] != 0 && [password length] != 0){
        [[AppModel sharedAppModel] getUserForName:username password:password withHandler:@selector(handleFetchOfUser:) target:self];
    }
    else{
        NSLog(@"Error");
        [alert show];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{    
    if (textField.tag == 1){
        [passwordTextField becomeFirstResponder];
    }
    else {
        [self attemptLogin];
    }
    return NO;
}

- (void)dismissKeyboard{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        default:
            return 0;
    };
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Make the identifier unique to that row so cell pictures don't get reused in funky ways.
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
            
        case 0:{
            
            if(indexPath.row == 0){
                usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(cell.bounds.origin.x + 8, cell.bounds.origin.y + 10, cell.bounds.size.width, cell.bounds.size.height)];
                usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                usernameTextField.placeholder = @"Enter your Username";
                usernameTextField.returnKeyType = UIReturnKeyNext;
                usernameTextField.tag = 1;
                usernameTextField.delegate = self;
                [cell.contentView addSubview:usernameTextField];
            }
            
            else if (indexPath.row == 1){
                passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(cell.bounds.origin.x + 8, cell.bounds.origin.y + 10, cell.bounds.size.width, cell.bounds.size.height)];
                passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                passwordTextField.secureTextEntry = YES;
                passwordTextField.placeholder = @"Enter your Password";
                passwordTextField.returnKeyType = UIReturnKeyDone;
                passwordTextField.tag = 2;
                passwordTextField.delegate = self;
                [cell.contentView addSubview:passwordTextField];
            }
            
        }break;
        default:
            cell.textLabel.text = @"Error :[";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0){
//        
//    }
//    else if (indexPath.section == 1){
//        
//    }
//    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - async calls

-(void)handleFetchOfUser:(NSArray *)users{
    
    if(users == nil || [users count] != 1){
        NSLog(@"Bad username/password combination...");
        [alert show];
    }
    else{
        User *user = users[0];
        [AppModel sharedAppModel].currentUser = user;
        [[AppModel sharedAppModel] getAllProjectsWithHandler:@selector(handleFetchOfAllProjects:) target:self];
    }
    
}

-(void)handleFetchOfAllProjects:(NSArray *)projects{
    ObservationProfileViewController *newObservation = [[ObservationProfileViewController alloc]initWithNibName:@"ObservationProfileViewController" bundle:nil];
    
    Project *project = projects[0];
    [AppModel sharedAppModel].currentProject = project;
    [self.navigationController pushViewController:newObservation animated:YES];
}

@end
