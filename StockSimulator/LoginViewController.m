//
//  LoginViewController.m
//  StockSimulator
//
//  Created by Mark Hall on 1/10/2014.
//  Copyright (c) 2014 Mark Hall. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=[UIColor stockSimulatorLightGrey];
    }
    return self;
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
