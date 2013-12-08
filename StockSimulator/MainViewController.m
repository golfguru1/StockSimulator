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
#import "StockSimulatorConstants.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController (){
    SearchViewController *sVc;
}

@end

@implementation MainViewController{
    NSArray *symbols;
    
    UILabel *tickerLabel;
    UILabel *costLabel;
    UILabel *changeLabel;
    UILabel *indexLabel;
    UILabel *shareLabel;
    UILabel *priceLabel;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (id)init{
    self = [super init];
    if (self) {
        int menuFontSize=14;
        UIColor *menuColor=[UIColor stockSimulatorOrange];
        self.view.backgroundColor=[UIColor stockSimulatorDarkGrey];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 55, 50, 15)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text=@"Ticker";
        titleLabel.textColor=menuColor;
        titleLabel.font=[UIFont stockSimulatorFontWithSize:menuFontSize];
        [self.view addSubview:titleLabel];
        
        UILabel *priceTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 55, 50, 15)];
        priceTitleLabel.backgroundColor=[UIColor clearColor];
        priceTitleLabel.text=@"Price";
        priceTitleLabel.textColor=menuColor;
        priceTitleLabel.font=[UIFont stockSimulatorFontWithSize:menuFontSize];
        [self.view addSubview:priceTitleLabel];
        
        UILabel *changeTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 55, 55, 15)];
        changeTitleLabel.backgroundColor=[UIColor clearColor];
        changeTitleLabel.text=@"Change";
        changeTitleLabel.textColor=menuColor;
        changeTitleLabel.font=[UIFont stockSimulatorFontWithSize:menuFontSize];
        [self.view addSubview:changeTitleLabel];
        
        UILabel *ownedLabel=[[UILabel alloc]initWithFrame:CGRectMake(185, 55, 100, 15)];
        ownedLabel.backgroundColor=[UIColor clearColor];
        ownedLabel.text=@"Shares";
        ownedLabel.textColor=menuColor;
        ownedLabel.font=[UIFont stockSimulatorFontWithSize:menuFontSize];
        [self.view addSubview:ownedLabel];
        
        UILabel *boughtLabel=[[UILabel alloc]initWithFrame:CGRectMake(245, 55, 100, 15)];
        boughtLabel.backgroundColor=[UIColor clearColor];
        boughtLabel.text=@"Bought at";
        boughtLabel.textColor=menuColor;
        boughtLabel.font=[UIFont stockSimulatorFontWithSize:menuFontSize];
        [self.view addSubview:boughtLabel];
        
        
        UIButton *search=[UIButton buttonWithType:UIButtonTypeCustom];
        search.frame=CGRectMake(10, self.view.frame.size.height/2+20, 100, 20);
        [search setTitle:@"Search" forState:UIControlStateNormal];
        [search addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:search];
        
        UIView *marquee=[[UIView alloc]initWithFrame:CGRectMake(0,25, self.view.frame.size.width,20)];
        marquee.backgroundColor=[UIColor stockSimulatorOrange];
        
        indexLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width+10, 2, 1000, 15)];
        indexLabel.font=[UIFont stockSimulatorFontWithSize:12];
        indexLabel.textColor=[UIColor stockSimulatorDarkGrey];
        [self getIndex];
        [marquee addSubview:indexLabel];
        [self animateMarquee];
        [self.view addSubview:marquee];

        [self refresh];
        [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
        [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getIndex) userInfo:nil repeats:YES];

    }
    return self;
}
-(void)refresh{
    UIFont *tickerFont=[UIFont stockSimulatorFontWithSize:12];
    NSDictionary *results=[[StockDataManager sharedManager] fetchQuotesFor:[[UserSettings sharedManager]stockTickers]];
    if([results valueForKey:@"Symbol"]!=(id)[NSNull null] && [results valueForKey:@"LastTradePriceOnly"]!=(id)[NSNull null] && [results valueForKey:@"Change"]!=(id)[NSNull null]){
        for (UIView *subview in [self.view subviews]) {
            if (subview.tag == 7) {
                [subview removeFromSuperview];
            }
        }
        for(int i=0;i<[[[UserSettings sharedManager]stockTickers]count];++i){
            tickerLabel=[[UILabel alloc]initWithFrame:CGRectMake(17, 80+i*20, 50, 15)];
            tickerLabel.textColor=[UIColor whiteColor];
            tickerLabel.font=tickerFont;
            tickerLabel.tag=7;
            [self.view addSubview:tickerLabel];
            [self.view sendSubviewToBack:tickerLabel];
            
            costLabel=[[UILabel alloc]initWithFrame:CGRectMake(72, 80+i*20, 50, 15)];
            costLabel.textColor=[UIColor whiteColor];
            costLabel.font=tickerFont;
            costLabel.tag=7;
            [self.view addSubview:costLabel];
            [self.view sendSubviewToBack:costLabel];
            
            changeLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 80+i*20, 50, 15)];
            changeLabel.textColor=[UIColor whiteColor];
            changeLabel.font=tickerFont;
            changeLabel.tag=7;
            [self.view addSubview:changeLabel];
            [self.view sendSubviewToBack:changeLabel];
            
            shareLabel=[[UILabel alloc]initWithFrame:CGRectMake(195, 80+i*20, 50, 15)];
            shareLabel.textColor=[UIColor whiteColor];
            shareLabel.font=tickerFont;
            shareLabel.tag=7;
            [self.view addSubview:shareLabel];
            [self.view sendSubviewToBack:shareLabel];
            
            priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(245, 80+i*20, 70, 15)];
            priceLabel.textColor=[UIColor whiteColor];
            priceLabel.font=tickerFont;
            priceLabel.tag=7;
            [self.view addSubview:priceLabel];
            [self.view sendSubviewToBack:priceLabel];
            
            NSString *name;
            NSString *price;
            NSString *changeSt;
            
            
            if([[[UserSettings sharedManager]stockTickers]count]>1){
                name=[results valueForKey:@"Symbol"][i];
                price=[self formatNumber:[[results valueForKey:@"LastTradePriceOnly"][i] floatValue]];
                changeSt=[self formatNumber:[[results valueForKey:@"Change"][i] floatValue]];
            }
            else{
                name=[results valueForKey:@"Symbol"];
                price=[self formatNumber:[[results valueForKey:@"LastTradePriceOnly"]floatValue]];
                changeSt=[self formatNumber:[[results valueForKey:@"Change"]floatValue]];;
            }
            shareLabel.text=[NSString stringWithFormat:@"%@",[[[UserSettings sharedManager]sharesOwned]valueForKey:name]];
            priceLabel.text=[self formatNumber:[[[[UserSettings sharedManager]priceBought]valueForKey:name]floatValue]];
            tickerLabel.text=name;
            costLabel.text=price;
            
            if([changeSt floatValue]>=0){
                changeLabel.textColor=[UIColor stockSimulatorGreen];
                changeLabel.text=[NSString stringWithFormat:@"+%@",changeSt];
            }
            else{
                changeLabel.textColor=[UIColor stockSimulatorRed];
                changeLabel.text=[NSString stringWithFormat:@"%@",changeSt];
            }
        }
    }
    else{
        NSLog(@"gg");
    }
}
-(void)getIndex{
    NSDictionary *indexes=[[StockDataManager sharedManager]getIndex];
    NSMutableString *resultsString=[[NSMutableString alloc]init];
    if([indexes valueForKey:@"Name"]!=(id)[NSNull null] && [indexes valueForKey:@"LastTradePriceOnly"]!=(id)[NSNull null] && [indexes valueForKey:@"Change"]){
        for(int i=0;i<[indexes count];++i){
            [resultsString appendString:[indexes valueForKey:@"Name"][i]];
            [resultsString appendString:@" "];
            NSString *price=[self formatNumber:[[indexes valueForKey:@"LastTradePriceOnly"][i]floatValue]];
            [resultsString appendString:price];
            [resultsString appendString:@" ("];
            NSString *changeString=[self formatNumber:[[indexes valueForKey:@"Change"][i]floatValue]];
            if ([changeString floatValue]>0)
                [resultsString appendString:[NSString stringWithFormat:@"+%@",changeString]];
            else
                [resultsString appendString:[NSString stringWithFormat:@"%@",changeString]];
            [resultsString appendString:@")   "];
        }
        indexLabel.text=resultsString;
    }
}
-(void)animateMarquee{
    [UIView animateWithDuration:25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [indexLabel setFrame:CGRectMake(-indexLabel.frame.size.width, 2, indexLabel.frame.size.width, indexLabel.frame.size.height)];
    } completion:^(BOOL finished) {
        [indexLabel setFrame:CGRectMake(self.view.frame.size.width, 2, indexLabel.frame.size.width, indexLabel.frame.size.height)];
        [self animateMarquee];
    }];
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
-(NSString*)formatNumber:(float)num{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setGroupingSize:3];
    [nf setGroupingSeparator:@","];
    [nf setUsesGroupingSeparator:YES];
    [nf setMaximumFractionDigits:2];
    [nf setMinimumFractionDigits:2];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // you should create a string from number
    NSNumber *n = [NSNumber numberWithFloat: num];
    NSString *str = [nf stringFromNumber:n];
    
    return str;
}
@end
