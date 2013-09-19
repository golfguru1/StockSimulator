//
//  MainViewController.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-16.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "MainViewController.h"
#import "SearchViewController.h"


#define QUOTE_QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20("
#define QUOTE_QUERY_SUFFIX @")&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

@interface MainViewController (){
    SearchViewController *sVc;
}

@end

@implementation MainViewController{
    NSArray *symbols;
    UITextView *field;
}

- (id)init{
    self = [super init];
    if (self) {
        symbols=@[@"AAPL", @"YHOO",@"GOOG"];
        self.view.backgroundColor=[UIColor redColor];
        
        field=[[UITextView alloc]initWithFrame:CGRectMake(10, 22, self.view.frame.size.width-20, self.view.frame.size.height/2-40)];
        field.backgroundColor=[UIColor clearColor];
        field.editable=NO;
        [self.view addSubview:field];
        
        UIButton *refresh=[UIButton buttonWithType:UIButtonTypeCustom];
        refresh.frame=CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2+20, 100, 20);
        [refresh setTitle:@"Refresh" forState:UIControlStateNormal];
        [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:refresh];
        
        UIButton *search=[UIButton buttonWithType:UIButtonTypeCustom];
        search.frame=CGRectMake(10, self.view.frame.size.height/2+20, 100, 20);
        [search setTitle:@"Search" forState:UIControlStateNormal];
        [search addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:search];
        
        [self refresh];
    }
    return self;
}
-(void)refresh{
    NSDictionary *results=[self fetchQuotesFor:symbols];
    //NSLog(@"%@",results);
    NSMutableString *resultsString=[[NSMutableString alloc]init];
    for(int i=0;i<[symbols count];++i){
        [resultsString appendString:[NSString stringWithFormat:@"%@ : %@\n",[results valueForKey:@"Symbol"][i],[results valueForKey:@"LastTradePriceOnly"][i]]];
    }
    field.text=resultsString;
    [self fetchQuotesFor:symbols];
}
-(void)search{
    if(!sVc) sVc=[[SearchViewController alloc]init];
    sVc.parent=self;
    [self.view addSubview:sVc.view];
   
}
-(void)hideSearch{
    if([sVc.view superview]){
        [sVc.view removeFromSuperview];
    }
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
