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
- (void)loadUserSettings
{
    _stockTickers = [[NSUserDefaults standardUserDefaults] objectForKey:@"stocks"];
    if (!_stockTickers) _stockTickers = [[NSMutableArray alloc]initWithObjects:@"AAPL",@"GOOG",@"YHOO", nil];
    
    _userCash=[[NSUserDefaults standardUserDefaults]objectForKey:@"cash"];
    if(!_userCash)_userCash=[NSNumber numberWithFloat:100000.00f];
    
    _sharesOwned=[[NSUserDefaults standardUserDefaults]objectForKey:@"owned"];
    if(!_sharesOwned){
        _sharesOwned=[[NSMutableDictionary alloc]init];
        [_sharesOwned setObject:@"0" forKey:@"AAPL"];
        [_sharesOwned setObject:@"0" forKey:@"GOOG"];
        [_sharesOwned setObject:@"0" forKey:@"YHOO"];
    }
    _priceBought=[[NSUserDefaults standardUserDefaults]objectForKey:@"bought"];
    if(!_priceBought){
        _priceBought=[[NSMutableDictionary alloc]init];
        [_priceBought setObject:@"-" forKey:@"AAPL"];
        [_priceBought setObject:@"-" forKey:@"GOOG"];
        [_priceBought setObject:@"-" forKey:@"YHOO"];
    }
    
}
- (void)setStockList:(NSMutableArray *)stockTickers
{
    _stockTickers=stockTickers;
    [[NSUserDefaults standardUserDefaults] setObject:_stockTickers forKey:@"stocks"];
    [self sync];
}
- (void)setUserCash:(NSNumber*)cash{
    _userCash=cash;
    [[NSUserDefaults standardUserDefaults]setObject:_userCash forKey:@"cash"];
    [self sync];
}
-(void)setSharesOwned:(NSMutableDictionary *)sharesOwned{
    _sharesOwned=sharesOwned;
    [[NSUserDefaults standardUserDefaults]setObject:_sharesOwned forKey:@"owned"];
    [self sync];
}
-(void)setPriceBought:(NSMutableDictionary *)priceBought{
    _priceBought=priceBought;
    [[NSUserDefaults standardUserDefaults]setObject:_priceBought forKey:@"bought"];
    [self sync];
}
-(void)sync{
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
