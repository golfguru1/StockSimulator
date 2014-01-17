//
//  SignUpViewController.m
//  StockSimulator
//
//  Created by Mark Hall on 1/10/2014.
//  Copyright (c) 2014 Mark Hall. All rights reserved.
//
#import "AppDelegate.h"
#import "SignUpViewController.h"
#import "Stock.h"
@interface SignUpViewController (){
    UITextField* userName;
    UITextField* password;
}

@end

@implementation SignUpViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=[UIColor stockSimulatorBlue];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        
        userName=[[UITextField alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 40)];
        userName.backgroundColor=[UIColor whiteColor];
        userName.font=[UIFont stockSimulatorFontWithSize:18];
        userName.placeholder=@"Username";
        [userName setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:userName];
        
        password=[[UITextField alloc]initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 40)];
        password.backgroundColor=[UIColor whiteColor];
        password.font=[UIFont stockSimulatorFontWithSize:18];
        password.secureTextEntry=YES;
        [password setTextAlignment:NSTextAlignmentCenter];
        password.placeholder=@"Password";
        [self.view addSubview:password];
        
        UIButton* signUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
        signUpButton.backgroundColor=[UIColor stockSimulatorGreen];
        signUpButton.frame=CGRectMake(0, 400, self.view.frame.size.width, 50);
        [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        [signUpButton setTitleColor:[UIColor stockSimulatorDarkGrey] forState:UIControlStateNormal];
        [signUpButton setTitleColor:[UIColor stockSimulatorLightGrey] forState:UIControlStateSelected];
        [signUpButton addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
        [signUpButton.titleLabel setFont:[UIFont stockSimulatorFontWithSize:20]];
        [self.view addSubview:signUpButton];
        
        UIButton* backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        backButton.backgroundColor=[UIColor stockSimulatorRed];
        backButton.frame=CGRectMake(0, 500, self.view.frame.size.width, 50);
        [backButton setTitle:@"< Back" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor stockSimulatorDarkGrey] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor stockSimulatorLightGrey] forState:UIControlStateSelected];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backButton.titleLabel setFont:[UIFont stockSimulatorFontWithSize:20]];
        [self.view addSubview:backButton];
        
        UIImageView* logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Stox-Logo.png"]];
        logo.frame=CGRectMake(20, 15, 280, 280);
        [self.view addSubview:logo];
    }
    return self;
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
-(void)signup{
    PFUser *user=[PFUser user];
    user.username=userName.text;
    user.password=password.text;
    user[@"cash"]=@100000;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(!error){
            [AppDelegate launchMainScreen];
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
            userName.text=nil;
            [userName becomeFirstResponder];
        }
    }];
    
}
-(void)back{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
