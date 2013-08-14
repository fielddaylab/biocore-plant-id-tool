//
//  RegisterNewAccountViewController.m
//  FieldResearchTool
//
//  Created by Nick Heindl on 8/13/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "RegisterNewAccountViewController.h"
#import "AppModel.h"
#import "ObservationProfileViewController.h"

@interface RegisterNewAccountViewController (){
    CGRect viewRect;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UIAlertView *failureAlert;
    UIAlertView *takenUsernameAlert;
    NSString *username;
    NSString *password;
}

@end

@implementation RegisterNewAccountViewController

@synthesize table;

-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    viewRect = frame;
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = viewRect;
}

- (void) loadView
{
    [super loadView];
    
    self.navigationItem.title = @"New Account";
    
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
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerButton addTarget:self action:@selector(attemptToRegister) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"Create account!" forState:UIControlStateNormal];
    registerButton.frame = CGRectMake(10.0, table.bounds.size.height, 300.0, 40.0);
    [self.view addSubview:registerButton];
    
    failureAlert = [[UIAlertView alloc]initWithTitle:@"Enter a valid username" message:@"Use characters a-z, 0-9, underscore, hyphen and between 3 and 15 characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    takenUsernameAlert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"This username is already taken." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)attemptToRegister{
    username = usernameTextField.text;
    password = passwordTextField.text;
    NSLog(@"USER: %@ PASS: %@",username, password);
    NSString *usernameRegex = @"^[a-z0-9_-]{3,15}$";
    NSPredicate *testRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    BOOL validUser = [testRegex evaluateWithObject: username];
    
    if (validUser && password.length > 0){
        [[AppModel sharedAppModel] getUserForName:username withHandler:@selector(handleFetchOfUser:) target:self];
    }
    else{
        NSLog(@"Error");
        [failureAlert show];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField.tag == 1){
        [passwordTextField becomeFirstResponder];
    }
    else {
        [self attemptToRegister];
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
                usernameTextField.placeholder = @"Username";
                usernameTextField.returnKeyType = UIReturnKeyNext;
                usernameTextField.tag = 1;
                usernameTextField.delegate = self;
                [cell.contentView addSubview:usernameTextField];
            }
            
            else if (indexPath.row == 1){
                passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(cell.bounds.origin.x + 8, cell.bounds.origin.y + 10, cell.bounds.size.width, cell.bounds.size.height)];
                passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                passwordTextField.secureTextEntry = YES;
                passwordTextField.placeholder = @"Password";
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
    
    if (users != nil && [users count] == 0){
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
        [attributes setObject:[NSDate date] forKey:@"created"];
        [attributes setObject:[NSDate date] forKey:@"updated"];
        [attributes setObject:username forKey:@"name"];
        [attributes setObject:password forKey:@"password"];
        
        User *user = [[AppModel sharedAppModel]createNewUserWithAttributes:attributes];
        [AppModel sharedAppModel].currentUser = user;
        [[AppModel sharedAppModel] getAllProjectsWithHandler:@selector(handleFetchOfAllProjects:) target:self];
        
    }
    else{
        NSLog(@"Bad username/password combination...(already taken)");
        [takenUsernameAlert show];
    }
    
}

-(void)handleFetchOfAllProjects:(NSArray *)projects{
    ObservationProfileViewController *newObservation = [[ObservationProfileViewController alloc]initWithNibName:@"ObservationProfileViewController" bundle:nil];
    
    Project *project = projects[0];
    [AppModel sharedAppModel].currentProject = project;
    [usernameTextField setText:@""];
    [passwordTextField setText:@""];
    [self.navigationController pushViewController:newObservation animated:YES];
}

@end
