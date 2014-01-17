//
//  SearchViewController.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-19.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "SearchViewController.h"
#import "StockDataManager.h"
#import "AddTickerView.h"
#import "TickerCell.h"
#import "PortfolioSummaryView.h"
#import "AppDelegate.h"

@interface SearchViewController (){
    AddTickerView *addItemView;
    PortfolioSummaryView *pSv;
    
    UILabel *indexLabel;
    
    UIActivityIndicatorView  *av;
    
    NSMutableArray* selectedIndexPaths;
    
    NSDictionary* results;
}

@end

@implementation SearchViewController
- (id)init{
    self = [super init];
    if (self) {
        self.view.backgroundColor=[UIColor stockSimulatorLightGrey];
        _table=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-170) style:UITableViewStyleGrouped];
        [_table setDataSource:self];
        [_table setDelegate:self];
        _table.backgroundColor=[UIColor clearColor];
        [_table registerClass:[TickerCell class] forCellReuseIdentifier:@"MyIdentifier"];
        [_table setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:_table];
        
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
        [refresh setTintColor:[UIColor stockSimulatorGreen]];
        [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
        [_table addSubview:refresh];
        
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
        
        UIButton *logoutButton=[UIButton buttonWithType:UIButtonTypeCustom];
        logoutButton.frame=CGRectMake(10, 25, 70, 25);
        [logoutButton setTitleColor:[UIColor stockSimulatorRed] forState:UIControlStateNormal];
        [logoutButton.titleLabel setFont:[UIFont stockSimulatorFontWithSize:16]];
        [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
        [logoutButton addTarget:self  action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:logoutButton];
        
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
    }
    return self;
}
-(void)logout{
    [PFUser logOut];
    [AppDelegate launchLoginScreen];
}
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
        NSMutableArray *stocks=[[NSMutableArray alloc]init];;
        for (id obj in self.userStocks){
            [stocks addObject:[obj valueForKey:@"ticker"]];
        }
        results=[[StockDataManager sharedManager] fetchQuotesFor:[stocks copy]];
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
    }
}
-(void)populateSummary{
    PFUser *currentUser=[PFUser currentUser];
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
    NSString* currentCashString;
    if([currentUser[@"cash"] floatValue])
        currentCashString=[self formatNumber:[currentUser[@"cash"] floatValue]];
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
    [self query];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userStocks count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *stockDeleted=self.userStocks[indexPath.row];
        [self.userStocks removeObject:stockDeleted];
        [stockDeleted deleteInBackground];
        [_table reloadData];
        [self refresh];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    TickerCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (!cell){
        cell = [[TickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    cell.submitButton.tag=indexPath.row;
    id stock=self.userStocks[indexPath.row];
    cell.tickerTitle.text =[stock valueForKey:@"ticker"];
    cell.boughtAt.text=[NSString stringWithFormat:@"%@",[stock valueForKey:@"priceBoughtAt"]];
    cell.numberOfShares.text=[NSString stringWithFormat:@"(%@)",[stock valueForKey:@"shares"]];
    NSString* changeSt;
    if([results valueForKey:@"Symbol"]!=(id)[NSNull null] && [results valueForKey:@"LastTradePriceOnly"]!=(id)[NSNull null] && [results valueForKey:@"Change"]!=(id)[NSNull null]){
        if([self.userStocks count]>1){
            cell.currentPrice.text=[self formatNumber:[[results valueForKey:@"LastTradePriceOnly"][indexPath.row] floatValue]];
            changeSt=[self formatNumber:[[results valueForKey:@"Change"][indexPath.row] floatValue]];
        }
        else{
            cell.currentPrice.text=[self formatNumber:[[results valueForKey:@"LastTradePriceOnly"]floatValue]];
            changeSt=[self formatNumber:[[results valueForKey:@"Change"]floatValue]];
        }
    }
    if([changeSt floatValue]>=0){
        cell.change.textColor=[UIColor stockSimulatorGreen];
        cell.change.text=[NSString stringWithFormat:@"+%@",changeSt];
    }
    else{
        cell.change.textColor=[UIColor stockSimulatorRed];
        cell.change.text=[NSString stringWithFormat:@"%@",changeSt];
    }
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
-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
    [self refresh];
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
-(void)query{
    PFUser *currentUser=[PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Stock"];
    [query whereKey:@"user" equalTo:currentUser.username];
    self.userStocks = [[query findObjects]mutableCopy];
}
-(void)submit:(UIButton*)sender{
    TickerCell *cell=(TickerCell*)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    if ([selectedIndexPaths containsObject:[NSIndexPath indexPathForRow:sender.tag inSection:0]]){
        [cell.sellNum resignFirstResponder];
        [cell.buyNum resignFirstResponder];
        [selectedIndexPaths removeObject:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    }
    [self.table beginUpdates];
    [self.table endUpdates];
    
}
-(void)addObject{
    CGPoint bottomOffset = CGPointMake(0, self.table.contentSize.height - self.table.bounds.size.height+75);
    if ( bottomOffset.y > 0 ) {
        [self.table setContentOffset:bottomOffset animated:YES];
    }
    [self performSelector:@selector(wait) withObject:nil afterDelay:0.5];
}
-(void)wait{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.userStocks indexOfObject:[self.userStocks lastObject]] inSection:0];
    [self.table beginUpdates];
    [self.table insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];
    [self.table endUpdates];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
