//
//  StockDataManager.h
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-19.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockDataManager : NSObject{
    NSMutableArray *stockTickers;
}

+(StockDataManager *)sharedManager;
- (NSDictionary *)fetchQuotesFor:(NSArray *)tickers;

@end
