//
//  StockDataManager.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-19.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "StockDataManager.h"

#define QUOTE_QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20("
#define QUOTE_QUERY_SUFFIX @")&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

@implementation StockDataManager

+ (id)sharedManager
{
    static dispatch_once_t pred = 0;
    static id instance = nil;
    
    dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    return instance;
}
- (id)init
{
    self = [super init];
    if ( self ) {
//        stockTickers=[[[NSUserDefaults standardUserDefaults]objectForKey:@"stocks"]mutableCopy];
    }
    
    return self;
}
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
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil] : nil;
        
        NSDictionary *quoteEntry = [results valueForKeyPath:@"query.results.quote"];
        return quoteEntry;
    }
    return quotes;
}

#define INDEX @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22%5ENYA%22%2C%20%22%5EGSPTSE%22%2C%22%5EIXIC%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
-(NSDictionary *)getIndex{
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:INDEX] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil] : nil;
    
    NSDictionary *quoteEntry = [results valueForKeyPath:@"query.results.quote"];
    return quoteEntry;
}

@end
