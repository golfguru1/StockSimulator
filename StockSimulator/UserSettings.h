//
//  UserSettings.h
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-19.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettings : NSObject
@property (nonatomic, strong) NSMutableArray *stockTickers;

+ (id)sharedManager;
-(void)setStockList:(NSMutableArray *)stockTickers;
- (void)loadUserSettings;
- (void)saveUserSettings;

@end
