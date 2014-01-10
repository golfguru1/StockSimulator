//
//  Stock.h
//  StockSimulator
//
//  Created by Mark Hall on 1/6/2014.
//  Copyright (c) 2014 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stock : NSObject

@property (nonatomic,strong)NSString* ticker;
@property (nonatomic)float priceBoughtAt;
@property (nonatomic)float currentPrice;
@property (nonatomic)float change;
@property (nonatomic)int shares;
-(NSString*)formatNumber:(float)num;
-(instancetype)initWithTicker:(NSString*)ticker withPriceBoughtAt:(float)priceBoughtAt withShares:(int)shares;
@end
