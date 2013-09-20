//
//  MainViewController.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-16.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "MainViewController.h"
#import "SearchViewController.h"
#import "StockDataManager.h"
#import "UserSettings.h"



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
    NSDictionary *results=[[StockDataManager sharedManager] fetchQuotesFor:[[UserSettings sharedManager]stockTickers]];
    NSMutableString *resultsString=[[NSMutableString alloc]init];
    for(int i=0;i<[[[[UserSettings sharedManager]stockTickers]mutableCopy] count];++i){
        [resultsString appendString:[NSString stringWithFormat:@"%@ : %@\n",[results valueForKey:@"Symbol"][i],[results valueForKey:@"LastTradePriceOnly"][i]]];
    }
    field.text=resultsString;
    //[[StockDataManager sharedManager] fetchQuotesFor:[[[UserSettings sharedManager]stockTickers]mutableCopy]];
}
-(void)search{
    if(!sVc) sVc=[[SearchViewController alloc]init];
    sVc.parent=self;
    [self.view addSubview:sVc.view];
   
}
-(void)hideSearch{
    if([sVc.view superview]){
        [sVc.view removeFromSuperview];
        [self refresh];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
