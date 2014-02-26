//
//  AppDelegate.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-13.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SearchViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [Parse setApplicationId:@"vse0rtMsfWfB0LYzeh1YrKaj6CGEqBVGAH5n8rdW"
                  clientKey:@"rxEeQX6hLlTUpav6she73DlVl2dNky1omYFPjHLO"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if ( [PFUser currentUser] ) {
        [AppDelegate launchMainScreen];
    }
    else {
        [AppDelegate launchLoginScreen];
    }
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    return YES;
}
+ (void)launchMainScreen
{
    AppDelegate *inst = [[UIApplication sharedApplication] delegate];
    
    SearchViewController *vC = [[SearchViewController alloc] init];
    inst.window.rootViewController = vC;
}
+ (void)launchLoginScreen
{
    AppDelegate *me = [[UIApplication sharedApplication] delegate];
    
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    nav.navigationBarHidden = YES;
    
    me.window.rootViewController = nav;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end