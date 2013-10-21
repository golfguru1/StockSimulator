//
//  UserSettings.h
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-19.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettings : NSObject
@property (nonatomic, strong)NSMutableArray *stockTickers;
@property (nonatomic, strong)NSNumber *userCash;
@property (nonatomic, strong)NSMutableDictionary *sharesOwned;
@property (nonatomic, strong)NSMutableDictionary *priceBought;

+ (id)sharedManager;
-(void)setStockList:(NSMutableArray *)stockTickers;
-(void)loadUserSettings;
-(void)setUserCash:(NSNumber*)cash;
-(void)setSharesOwned:(NSMutableDictionary *)sharesOwned;
-(void)setPriceBought:(NSMutableDictionary*)priceBought;

@end
