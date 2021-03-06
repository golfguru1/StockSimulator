//
//  SearchViewController.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-19.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "SearchViewController.h"
#import "UserSettings.h"
#import "StockDataManager.h"
#import "AddTickerView.h"
#import "EditCurrentStocks.h"
#import "TickerCell.h"
#import "PortfolioSummaryView.h"
#import "Stock.h"

@interface SearchViewController (){
    AddTickerView *addItemView;
    EditCurrentStocks *editView;
    PortfolioSummaryView *pSv;
    
    UILabel *indexLabel;
    
    UIActivityIndicatorView  *av;
    
    NSMutableArray* selectedIndexPaths;
}

@end

@implementation SearchViewController
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (id)init{
    self = [super init];
    if (self) {
                                                                    // add loading animation
        self.view.backgroundColor=[UIColor stockSimulatorLightGrey];
        _table=[[UITableView alloc]initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height-205) style:UITableViewStyleGrouped];
        [_table setDataSource:self];
        [_table setDelegate:self];
        _table.backgroundColor=[UIColor clearColor];
        [_table registerClass:[TickerCell class] forCellReuseIdentifier:@"MyIdentifier"];
        [_table setShowsVerticalScrollIndicator:NO];
        _table.contentInset=UIEdgeInsetsMake(-35, 0, 0, 0);
        [self.view addSubview:_table];
        
        UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        topView.backgroundColor=[UIColor stockSimulatorDarkGrey];        
        
        UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame=CGRectMake(self.view.frame.size.width-35, 25, 25, 25);
        [addButton setImage:[UIImage imageNamed:@"Plus_03.png"]
                   forState:UIControlStateNormal];
        [addButton addTarget:self
                      action:@selector(add)
            forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:addButton];
        
        UIView *marquee=[[UIView alloc]initWithFrame:CGRectMake(0,70, self.view.frame.size.width,22)];
        marquee.backgroundColor=[UIColor stockSimulatorOrange];
        
        indexLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width+10, 2, 1000, 17)];
        indexLabel.font=[UIFont stockSimulatorFontWithSize:12];
        indexLabel.textColor=[UIColor stockSimulatorDarkGrey];
        [marquee addSubview:indexLabel];
        
        [self.view addSubview:topView];
        [self.view addSubview:marquee];
        pSv=[[PortfolioSummaryView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-100,self.view.frame.size.width, 100)];
        [self.view addSubview:pSv];
        [self refresh];
        [self animateMarquee];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    }
    return self;
}
//-(void)startLoadingAnimation{
//    av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    av.frame=CGRectMake(145, 160, 25, 25);
//    [self.view addSubview:av];
//    [av startAnimating];
//}
//-(void)stopLoadingAnimation{
//    [av removeFromSuperview];
//    
//}
-(void)animateMarquee{
    [UIView animateWithDuration:25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [indexLabel setFrame:CGRectMake(-indexLabel.frame.size.width, 2, indexLabel.frame.size.width, indexLabel.frame.size.height)];
    } completion:^(BOOL finished) {
        [indexLabel setFrame:CGRectMake(self.view.frame.size.width, 2, indexLabel.frame.size.width, indexLabel.frame.size.height)];
        [self animateMarquee];
    }];
}

-(void)refresh{
    if ([selectedIndexPaths count]==0){
        NSDictionary *results=[[StockDataManager sharedManager] fetchQuotesFor:[[UserSettings sharedManager]stockTickers]];
        if([results valueForKey:@"Symbol"]!=(id)[NSNull null] && [results valueForKey:@"LastTradePriceOnly"]!=(id)[NSNull null] && [results valueForKey:@"Change"]!=(id)[NSNull null]){
            NSMutableArray* stockCopy=[[[UserSettings sharedManager]stockTickers]mutableCopy];
            if([[[UserSettings sharedManager]stockTickers]count]>1){
                int i=0;
                for(Stock* stock in stockCopy){
                    stock.currentPrice=[[results valueForKey:@"LastTradePriceOnly"][i] floatValue];
                    stock.change=[[results valueForKey:@"Change"][i] floatValue];
                    i++;
                }
            }
            else{
                for(Stock* stock in stockCopy){
                    stock.currentPrice=[[results valueForKey:@"LastTradePriceOnly"]floatValue];
                    stock.change=[[results valueForKey:@"Change"]floatValue];
                }
            }
            [[UserSettings sharedManager]setStockTickers:stockCopy];
        }
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
        [self populateSummary];
        [_table reloadData];
    }
}
-(void)populateSummary{
    float todayTotal=0;
    float totalStockValue=0;
    float totalValue=0;
    for (int section = 0; section < [_table numberOfSections]; ++section) {
        for (int row = 0; row < [_table numberOfRowsInSection:section]; ++row) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            TickerCell* cell = (TickerCell*)[_table cellForRowAtIndexPath:cellPath];
            NSString* num=cell.numberOfShares.text;
            num=[num substringFromIndex:1];
            num=[num substringToIndex:[num length]-1];
            NSString* currentP=cell.currentPrice.text;
            NSString* boughtAt=cell.boughtAt.text;
            totalValue+=([currentP floatValue]-[boughtAt floatValue])*[num floatValue];
            totalStockValue+=[cell.currentPrice.text floatValue]*[num floatValue];
            
            if ([cell.change.text characterAtIndex:0]=='+'){
                todayTotal+=[[cell.change.text substringFromIndex:1]floatValue];
            }
            else{
                todayTotal-=[[cell.change.text substringFromIndex:1]floatValue];
            }
            
        }
    }
    NSString* totalValueString=[self formatNumber:totalValue];
    if([totalValueString characterAtIndex:0]=='-'){
        [pSv.totalValue setText:[NSString stringWithFormat:@"- $%@",[totalValueString substringFromIndex:1]]];
        [pSv.totalValue setBackgroundColor:[UIColor stockSimulatorRed]];
        [pSv.valueTitle setText:@"Total Loss"];
    }
    else{
        [pSv.totalValue setText:[NSString stringWithFormat:@"+ $%@",totalValueString]];
        [pSv.totalValue setBackgroundColor:[UIColor stockSimulatorGreen]];
        [pSv.valueTitle setText:@"Total Gain"];
    }
    NSString* currentCashString=[self formatNumber:[[[UserSettings sharedManager]userCash]floatValue]];
    if([currentCashString characterAtIndex:0]=='-'){
        [pSv.totalCash setText:[NSString stringWithFormat:@"($%@)",[currentCashString substringFromIndex:1]]];
        [pSv.totalCash setBackgroundColor:[UIColor stockSimulatorRed]];
    }
    else{
        [pSv.totalCash setText:[NSString stringWithFormat:@"$%@",currentCashString]];
        [pSv.totalCash setBackgroundColor:[UIColor stockSimulatorGreen]];
    }
}
-(void)add{
    addItemView=[[AddTickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    if (![addItemView superview])
        [self.view addSubview:addItemView];
    [UIView animateWithDuration:0.2 animations:^{
        [addItemView setFrame:self.view.frame];
    }];
    addItemView.parent=self;
    [addItemView.bar becomeFirstResponder];
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[UserSettings sharedManager]stockTickers] count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TickerCell *selected=(TickerCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSMutableArray *stocks= [[[UserSettings sharedManager]stockTickers]mutableCopy];
        [stocks removeObjectAtIndex:indexPath.row];
        [[UserSettings sharedManager]setStockTickers:stocks];
        NSMutableDictionary *owned=[[[UserSettings sharedManager]sharesOwned]mutableCopy];
        [owned removeObjectForKey:selected.tickerTitle.text];
        [[UserSettings sharedManager]setSharesOwned:owned];
        [_table reloadData];
        [self refresh];
    }
}

//-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
//    NSString *r = [[[UserSettings sharedManager]stockTickers] objectAtIndex:fromIndexPath.row];
//    [[[UserSettings sharedManager]stockTickers] removeObjectAtIndex:fromIndexPath.row];
//    [[[UserSettings sharedManager]stockTickers] insertObject:r atIndex:toIndexPath.row];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    TickerCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (!cell){
        cell = [[TickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    Stock* stock=[[UserSettings sharedManager]stockTickers][indexPath.row];
    cell.tickerTitle.text =stock.ticker;
//    if([changeSt floatValue]>=0){
//        cell.change.textColor=[UIColor stockSimulatorGreen];
//        cell.change.text=[NSString stringWithFormat:@"+%@",changeSt];
//    }
//    else{
//        cell.change.textColor=[UIColor stockSimulatorRed];
//        cell.change.text=[NSString stringWithFormat:@"%@",changeSt];
//    }
        return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!selectedIndexPaths) selectedIndexPaths=[[NSMutableArray alloc]init];
    TickerCell *cell=(TickerCell*)[tableView cellForRowAtIndexPath:indexPath];
    if ([selectedIndexPaths containsObject:indexPath]){
        [cell.sellNum resignFirstResponder];
        [cell.buyNum resignFirstResponder];
        [selectedIndexPaths removeObject:indexPath];
    }
    else{
        [selectedIndexPaths addObject:indexPath];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectedIndexPaths containsObject:indexPath]) {
        return 160;
    }
    return 70;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning");
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
    
    NSNumber *n = [NSNumber numberWithFloat: num];
    NSString *str = [nf stringFromNumber:n];
    
    return str;
}

@end
