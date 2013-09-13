//
//  appAppDelegate.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-13.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "appAppDelegate.h"

@implementation appAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    NSArray *symbols=@[@"AAPL", @"YHOO",@"GOOG"];
    NSDictionary *results=[self fetchQuotesFor:symbols];
    NSLog(@"%@",results);
    
    return YES;
}
#define QUOTE_QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20("
#define QUOTE_QUERY_SUFFIX @")&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

- (NSDictionary *)fetchQuotesFor:(NSArray *)tickers {
    NSMutableDictionary *quotes;
    
    if (tickers && [tickers count] > 0) {
        NSMutableString *query = [[NSMutableString alloc] init];
        [query appendString:QUOTE_QUERY_PREFIX];
        
        for (int i = 0; i < [tickers count]; i++) {
            NSString *ticker = [tickers objectAtIndex:i];
            [query appendFormat:@"%%22%@%%22", ticker];
            if (i != [tickers count] - 1) [query appendString:@"%2C"];
        }
        
        [query appendString:QUOTE_QUERY_SUFFIX];
        NSLog(@"%@",query);
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil] : nil;
        
        NSDictionary *quoteEntry = [results valueForKeyPath:@"query.results.quote"];
        return quoteEntry;
    }
    return quotes;
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
