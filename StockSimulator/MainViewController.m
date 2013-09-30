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
        self.view.backgroundColor=[UIColor darkGrayColor];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 55, 50, 15)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text=@"Ticker";
        titleLabel.textColor=[UIColor yellowColor];
        titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [self.view addSubview:titleLabel];
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 55, 50, 15)];
        priceLabel.backgroundColor=[UIColor clearColor];
        priceLabel.text=@"Price";
        priceLabel.textColor=[UIColor yellowColor];
        priceLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [self.view addSubview:priceLabel];
        
        UILabel *changeTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(125, 55, 50, 15)];
        changeTitleLabel.backgroundColor=[UIColor clearColor];
        changeTitleLabel.text=@"Change";
        changeTitleLabel.textColor=[UIColor yellowColor];
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
        
        UIView *marquee=[[UIView alloc]initWithFrame:CGRectMake(0,25, self.view.frame.size.width,20)];
        marquee.backgroundColor=[UIColor clearColor];
        
        indexLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width+10, 2, 1000, 15)];
        indexLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        indexLabel.textColor=[UIColor colorWithRed:58.0/255.0f green:169.0/255.0f blue:234.0/255.0f alpha:1.0f];
        [self getIndex];
        [marquee addSubview:indexLabel];
        [self animateMarquee];
        [self.view addSubview:marquee];

        [self refresh];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];

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
        tickerLabel=[[UILabel alloc]initWithFrame:CGRectMake(17, 80+i*20, 50, 15)];
        tickerLabel.textColor=[UIColor whiteColor];
        tickerLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        [tickerLabelsArray addObject:tickerLabel];
        tickerLabel.tag=7;
        [self.view addSubview:tickerLabel];
        
        costLabel=[[UILabel alloc]initWithFrame:CGRectMake(72, 80+i*20, 50, 15)];
        costLabel.textColor=[UIColor whiteColor];
        costLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        [costLabelsArray addObject:costLabel];
        costLabel.tag=7;
        [self.view addSubview:costLabel];
        
        changeLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 80+i*20, 50, 15)];
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
            changeLabel.textColor=[UIColor colorWithRed:58.0/255.0f green:169.0/255.0f blue:234.0/255.0f alpha:1.0f];
            changeLabel.text=[NSString stringWithFormat:@"+%.02f",[changeSt floatValue]];
        }
        else{
            changeLabel.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
            changeLabel.text=[NSString stringWithFormat:@"%.02f",[changeSt floatValue]];
        }
    }
}
-(void)getIndex{
    NSDictionary *indexes=[[StockDataManager sharedManager]getIndex];
    NSMutableString *resultsString=[[NSMutableString alloc]init];
    for(int i=0;i<[indexes count];++i){
        [resultsString appendString:[indexes valueForKey:@"Name"][i]];
        [resultsString appendString:@" "];
        [resultsString appendString:[indexes valueForKey:@"LastTradePriceOnly"][i]];
        [resultsString appendString:@" ("];
        [resultsString appendString:[indexes valueForKey:@"Change"][i]];
        [resultsString appendString:@")   "];
    }
    indexLabel.text=resultsString;
}
-(void)animateMarquee{
    [UIView animateWithDuration:20 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
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

@end
