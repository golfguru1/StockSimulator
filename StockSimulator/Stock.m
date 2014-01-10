//
//  Stock.m
//  StockSimulator
//
//  Created by Mark Hall on 1/6/2014.
//  Copyright (c) 2014 Mark Hall. All rights reserved.
//

#import "Stock.h"

@implementation Stock

-(instancetype)initWithTicker:(NSString*)ticker withPriceBoughtAt:(float)priceBoughtAt withShares:(int)shares{
    self=[super init];
    if(self){
        self.ticker=ticker;
        self.priceBoughtAt=priceBoughtAt;
        self.shares=shares;
        self.currentPrice=0;
        self.change=0;
    }
    return self;
}
-(NSString*)formatNumber:(float)num{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setGroupingSize:3];
    [nf setGroupingSeparator:@","];
    [nf setUsesGroupingSeparator:YES];
    [nf setMaximumFractionDigits:2];
    [nf setMinimumFractionDigits:2];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *n = [NSNumber numberWithFloat: num];
    NSString *str = [nf stringFromNumber:n];
    
    if(num>0)   return [NSString stringWithFormat:@"+%@",str];
    else    return [NSString stringWithFormat:@"-%@",str];
}


@end
