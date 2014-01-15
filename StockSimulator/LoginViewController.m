//
//  LoginViewController.m
//  StockSimulator
//
//  Created by Mark Hall on 1/10/2014.
//  Copyright (c) 2014 Mark Hall. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SignUpViewController.h"

@interface LoginViewController (){
UITextField* userName;
UITextField* password;
}

@end

@implementation LoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        // Custom initialization
        self.view.backgroundColor=[UIColor stockSimulatorLightGrey];
        
        userName=[[UITextField alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 40)];
        userName.backgroundColor=[UIColor whiteColor];
        userName.placeholder=@"Username";
        userName.font=[UIFont stockSimulatorFontWithSize:18];
        [userName setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:userName];
        
        password=[[UITextField alloc]initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 40)];
        password.backgroundColor=[UIColor whiteColor];
        [password setTextAlignment:NSTextAlignmentCenter];
        password.secureTextEntry=YES;
        password.font=[UIFont stockSimulatorFontWithSize:18];
        password.placeholder=@"Password";
        [self.view addSubview:password];
        
        UIButton* loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.backgroundColor=[UIColor stockSimulatorGreen];
        loginButton.frame=CGRectMake(0, 400, self.view.frame.size.width, 50);
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor stockSimulatorDarkGrey] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor stockSimulatorLightGrey] forState:UIControlStateSelected];
        [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [loginButton.titleLabel setFont:[UIFont stockSimulatorFontWithSize:20]];
        [self.view addSubview:loginButton];
        
        UIButton* signUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
        signUpButton.backgroundColor=[UIColor stockSimulatorDarkRed];
        signUpButton.frame=CGRectMake(0, 500, self.view.frame.size.width, 50);
        [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        [signUpButton setTitleColor:[UIColor stockSimulatorDarkGrey] forState:UIControlStateNormal];
        [signUpButton setTitleColor:[UIColor stockSimulatorLightGrey] forState:UIControlStateSelected];
        [signUpButton addTarget:self action:@selector(beginSignup) forControlEvents:UIControlEventTouchUpInside];
        [signUpButton.titleLabel setFont:[UIFont stockSimulatorFontWithSize:20]];
        [self.view addSubview:signUpButton];
    }
    return self;
}
-(void)login{
    if ( userName.text == nil || password.text == nil ) {
        return;
    }
    
    if ( [userName.text isEqualToString:@""] || [password.text isEqualToString:@""] ) {
        return;
    }
    
    [PFUser logInWithUsernameInBackground:userName.text
                                 password:password.text
                                    block:^(PFUser *user, NSError *error)
     {
         if ( user ) {
             [AppDelegate launchMainScreen];
         }
         else {
             NSString *errorString = [[error userInfo] objectForKey:@"error"];
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
             userName.text=nil;
             password.text=nil;
             [userName becomeFirstResponder];
         }
     }];

}
- (void)beginSignup
{
    [self.view endEditing:YES];
    SignUpViewController *signup = [[SignUpViewController alloc]init];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController pushViewController:signup animated:YES];
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSTimeInterval time=[[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:time animations:^{
        [self.view setFrame:CGRectMake(0,-keyboardFrameBeginRect.size.height,self.view.frame.size.width, self.view.frame.size.height)];
    }];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSTimeInterval time=[[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:time animations:^{
        [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
