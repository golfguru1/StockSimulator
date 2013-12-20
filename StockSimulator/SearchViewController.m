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
#import "StockSimulatorConstants.h"
#import "PortfolioSummaryView.h"

@interface SearchViewController (){
    AddTickerView *addItemView;
    EditCurrentStocks *editView;
    PortfolioSummaryView *pSv;
    
    NSDictionary *results;
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
#warning add loading animation
        // Custom initialization
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
    results=[[StockDataManager sharedManager] fetchQuotesFor:[[UserSettings sharedManager]stockTickers]];
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
    if ([selectedIndexPaths count]==0)
        [_table reloadData];
}
-(void)populateSummary{
    float todayTotal=0;
    float totalStockValue=0;
    float totalValue=[[[UserSettings sharedManager]userCash]floatValue];
    for (int section = 0; section < [_table numberOfSections]; ++section) {
        for (int row = 0; row < [_table numberOfRowsInSection:section]; ++row) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            TickerCell* cell = (TickerCell*)[_table cellForRowAtIndexPath:cellPath];
            NSString* num=cell.numberOfShares.text;
            num=[num substringFromIndex:1];
            num=[num substringToIndex:[num length]-1];
            NSString* currentP=cell.currentPrice.text;
            totalValue+=[currentP floatValue]*[num floatValue];
            totalStockValue+=[cell.currentPrice.text floatValue]*[num floatValue];
            
            if ([cell.change.text characterAtIndex:0]=='+'){
                todayTotal+=[[cell.change.text substringFromIndex:1]floatValue];
            }
            else{
                todayTotal-=[[cell.change.text substringFromIndex:1]floatValue];
            }
            
        }
    }
    [pSv.totalValue setText:[NSString stringWithFormat:@"$%@",[self formatNumber:totalValue]]];
    [pSv.totalCash setText:[self formatNumber:[[[UserSettings sharedManager]userCash]floatValue]]];
    [pSv.totalStockValue setText:[self formatNumber:totalStockValue]];
    [pSv.todayChange setText:[self formatNumber:todayTotal]];
}
-(void)add{
    addItemView=[[AddTickerView alloc]initWithFrame:self.view.frame];
    addItemView.parent=self;
    if (![addItemView superview])
        [self.view addSubview:addItemView];
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[UserSettings sharedManager]stockTickers] count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TickerCell *selected=(TickerCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSMutableArray *stocks= [[[UserSettings sharedManager]stockTickers]mutableCopy];
        [stocks removeObjectAtIndex:indexPath.row];
        [[UserSettings sharedManager]setStockList:stocks];
        NSMutableDictionary *owned=[[[UserSettings sharedManager]sharesOwned]mutableCopy];
        [owned removeObjectForKey:selected.tickerTitle.text];
        [[UserSettings sharedManager]setSharesOwned:owned];
        [_table reloadData];
        [self refresh];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    NSString *r = [[[UserSettings sharedManager]stockTickers] objectAtIndex:fromIndexPath.row];
    [[[UserSettings sharedManager]stockTickers] removeObjectAtIndex:fromIndexPath.row];
    [[[UserSettings sharedManager]stockTickers] insertObject:r atIndex:toIndexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    TickerCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (!cell){
        cell = [[TickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.tickerTitle.text = [[UserSettings sharedManager]stockTickers][indexPath.row];
    NSString *name;
    NSString *price;
    NSString *changeSt;
    if([results valueForKey:@"Symbol"]!=(id)[NSNull null] && [results valueForKey:@"LastTradePriceOnly"]!=(id)[NSNull null] && [results valueForKey:@"Change"]!=(id)[NSNull null]){
        if([[[UserSettings sharedManager]stockTickers]count]>1){
            name=[results valueForKey:@"Symbol"][indexPath.row];
            price=[self formatNumber:[[results valueForKey:@"LastTradePriceOnly"][indexPath.row] floatValue]];
            changeSt=[self formatNumber:[[results valueForKey:@"Change"][indexPath.row] floatValue]];
        }
        else{
            name=[results valueForKey:@"Symbol"];
            price=[self formatNumber:[[results valueForKey:@"LastTradePriceOnly"]floatValue]];
            changeSt=[self formatNumber:[[results valueForKey:@"Change"]floatValue]];;
        }
        cell.numberOfShares.text=[NSString stringWithFormat:@"(%@)",[[[UserSettings sharedManager]sharesOwned]valueForKey:name]];
        cell.boughtAt.text=[self formatNumber:[[[[UserSettings sharedManager]priceBought]valueForKey:name]floatValue]];
        cell.currentPrice.text=price;
        
        if([changeSt floatValue]>=0){
            cell.change.textColor=[UIColor stockSimulatorGreen];
            cell.change.text=[NSString stringWithFormat:@"+%@",changeSt];
        }
        else{
            cell.change.textColor=[UIColor stockSimulatorRed];
            cell.change.text=[NSString stringWithFormat:@"%@",changeSt];
        }
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!selectedIndexPaths)
        selectedIndexPaths=[[NSMutableArray alloc]init];
    if ([selectedIndexPaths containsObject:indexPath]){
        [selectedIndexPaths removeObject:indexPath];
    }
    else{
        [selectedIndexPaths addObject:indexPath];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
//    editView=[[EditCurrentStocks alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
//    if(![editView superview]){
//        NSDictionary *check=[[StockDataManager sharedManager] fetchQuotesFor:@[selected.tickerTitle.text.uppercaseString]];
//        [self.view addSubview:editView];
//        editView.parent=self;
//        editView.tickerTitle.text=selected.tickerTitle.text;
//        [UIView animateWithDuration:0.5 animations:^{
//            editView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//            [editView.currentPrice setText:[NSString stringWithFormat:@"$%@",[self formatNumber:[[check valueForKey:@"LastTradePriceOnly"]floatValue]]]];
//            [editView.companyLabel setText:[check valueForKey:@"Name"]];
//        }];
//    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectedIndexPaths containsObject:indexPath]) {
        return 160;
    }
    return 70;
}
//-(void)removeEditView{
//    if([editView superview]){
//        [UIView animateWithDuration:0.5 animations:^{
//            editView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//        }completion:^(BOOL finished){
//            [editView removeFromSuperview];
//        }];
//    }
//}
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
