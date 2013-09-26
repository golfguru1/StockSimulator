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
    
    UILabel *tickerLabel;
    UILabel *costLabel;
    UILabel *changeLabel;
    
    NSMutableArray *tickerLabelsArray;
    NSMutableArray *costLabelsArray;
    NSMutableArray *changeLabelsArray;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (id)init{
    self = [super init];
    if (self) {
        self.view.backgroundColor=[UIColor blackColor];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 25, 50, 15)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text=@"Ticker";
        titleLabel.textColor=[UIColor redColor];
        titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [self.view addSubview:titleLabel];
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 25, 50, 15)];
        priceLabel.backgroundColor=[UIColor clearColor];
        priceLabel.text=@"Price";
        priceLabel.textColor=[UIColor redColor];
        priceLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [self.view addSubview:priceLabel];
        
        UILabel *changeTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(125, 25, 50, 15)];
        changeTitleLabel.backgroundColor=[UIColor clearColor];
        changeTitleLabel.text=@"Change";
        changeTitleLabel.textColor=[UIColor redColor];
        changeTitleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [self.view addSubview:changeTitleLabel];
        
        
        tickerLabelsArray=[[NSMutableArray alloc]init];
        costLabelsArray=[[NSMutableArray alloc]init];
        changeLabelsArray=[[NSMutableArray alloc]init];
        
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
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 7) {
            [subview removeFromSuperview];
        }
    }
    for(int i=0;i<[[[UserSettings sharedManager]stockTickers]count];++i){
        tickerLabel=[[UILabel alloc]initWithFrame:CGRectMake(17, 50+i*20, 50, 15)];
        tickerLabel.textColor=[UIColor whiteColor];
        tickerLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        [tickerLabelsArray addObject:tickerLabel];
        tickerLabel.tag=7;
        [self.view addSubview:tickerLabel];
        
        costLabel=[[UILabel alloc]initWithFrame:CGRectMake(72, 50+i*20, 50, 15)];
        costLabel.textColor=[UIColor whiteColor];
        costLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        [costLabelsArray addObject:costLabel];
        costLabel.tag=7;
        [self.view addSubview:costLabel];
        
        changeLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 50+i*20, 50, 15)];
        changeLabel.textColor=[UIColor whiteColor];
        changeLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        [changeLabelsArray addObject:changeLabel];
        changeLabel.tag=7;
        [self.view addSubview:changeLabel];
        
        tickerLabel.text=[results valueForKey:@"Symbol"][i];
        NSString *price=[results valueForKey:@"LastTradePriceOnly"][i];
        costLabel.text=[NSString stringWithFormat:@"%.02f",[price floatValue]];
        NSString *changeSt=[results valueForKey:@"Change"][i];
        if([changeSt floatValue]>=0){
            changeLabel.textColor=[UIColor greenColor];
            changeLabel.text=[NSString stringWithFormat:@"+%.02f",[changeSt floatValue]];
        }
        else{
            changeLabel.textColor=[UIColor redColor];
            changeLabel.text=[NSString stringWithFormat:@"%.02f",[changeSt floatValue]];
        }
    }
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
- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
