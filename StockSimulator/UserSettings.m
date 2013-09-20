//
//  UserSettings.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-19.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

- (id)init
{
    self = [super init];
    
    if (self) {
        [self loadUserSettings];
    }
    
    return self;
}
+ (id)sharedManager{
    static dispatch_once_t pred = 0;
    static id instance = nil;
    
    dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (void)setStockList:(NSMutableArray *)stockTickers
{
    _stockTickers=stockTickers;
    [[NSUserDefaults standardUserDefaults] setObject:_stockTickers forKey:@"stocks"];
    [self sync];
}

- (void)loadUserSettings
{
    _stockTickers = [[NSUserDefaults standardUserDefaults] objectForKey:@"stocks"];
    if (!_stockTickers) _stockTickers = [[NSMutableArray alloc]initWithObjects:@"AAPL",@"GOOG",@"YHOO", nil];
}
- (void)saveUserSettings
{
    [[NSUserDefaults standardUserDefaults] setObject:_stockTickers forKey:@"stocks"];
}
-(void)sync{
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
