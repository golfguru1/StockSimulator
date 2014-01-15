//
//  SearchViewController.h
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-19.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain)UITableView *table;
@property (nonatomic,strong)NSMutableArray *userStocks;
-(void)refresh;
-(void)query;
-(void)addObject;
@end
