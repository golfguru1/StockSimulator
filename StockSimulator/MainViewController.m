//
//  MainViewController.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-16.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "MainViewController.h"

#define QUOTE_QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20("
#define QUOTE_QUERY_SUFFIX @")&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *symbols=@[@"AAPL", @"YHOO",@"GOOG"];
        NSDictionary *results=[self fetchQuotesFor:symbols];
        NSLog(@"%@",results);
        self.view.backgroundColor=[UIColor redColor];
        
        UITextView *field=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height-20)];
        NSMutableString *resultsString=[[NSMutableString alloc]init];
        for(int i=0;i<[symbols count];++i){
            [resultsString appendString:[NSString stringWithFormat:@"%@ : %@\n",[results valueForKey:@"Symbol"][i],[results valueForKey:@"LastTradePriceOnly"][i]]];
        }
        field.text=resultsString;
        field.backgroundColor=[UIColor clearColor];
        field.editable=NO;
        
        [self.view addSubview:field];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
