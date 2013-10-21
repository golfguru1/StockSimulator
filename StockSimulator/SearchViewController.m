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

@interface SearchViewController (){    
    AddTickerView *addItemView;
}

@end

@implementation SearchViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _table=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60) style:UITableViewStyleGrouped];
        [_table setDataSource:self];
        [_table setDelegate:self];
        [_table setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
        _table.backgroundColor=[UIColor blackColor];
        [_table setEditing:YES animated:YES];
        [self.view addSubview:_table];
        
        UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        topView.backgroundColor=[UIColor grayColor];
        
        UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame=CGRectMake(5, 20, 60, 40);
        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        backButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        [backButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:backButton];
        
        UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame=CGRectMake(self.view.frame.size.width-40, 17, 40, 40);
        [addButton setTitle:@"+" forState:UIControlStateNormal];
        addButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:27];
        [addButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:addButton];
        
        [self.view addSubview:topView];
    }
    return self;
}
-(void)add{
    addItemView=[[AddTickerView alloc]initWithFrame:self.view.frame];
    addItemView.parent=self;
    [self.view addSubview:addItemView];
    
}
-(void)back{
    [_parent hideSearch];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[UserSettings sharedManager]stockTickers] count];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *selected=[tableView cellForRowAtIndexPath:indexPath];
        NSMutableArray *stocks= [[[UserSettings sharedManager]stockTickers]mutableCopy];
        [stocks removeObjectAtIndex:indexPath.row];
        [[UserSettings sharedManager]setStockList:stocks];
        NSMutableDictionary *owned=[[[UserSettings sharedManager]sharesOwned]mutableCopy];
        [owned removeObjectForKey:selected.textLabel.text];
        [[UserSettings sharedManager]setSharesOwned:owned];
        [_table reloadData];
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    NSString *r = [[[UserSettings sharedManager]stockTickers] objectAtIndex:fromIndexPath.row];
    [[[UserSettings sharedManager]stockTickers] removeObjectAtIndex:fromIndexPath.row];
    [[[UserSettings sharedManager]stockTickers] insertObject:r atIndex:toIndexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = [[UserSettings sharedManager]stockTickers][indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor blackColor];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selected=[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",selected.textLabel.text);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
