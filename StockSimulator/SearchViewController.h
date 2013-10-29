//
//  SearchViewController.h
//  StockSimulator
//
//  Created by Mark Hall on 2013-09-19.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property MainViewController *parent;
@property (nonatomic, retain)UITableView *table;

-(void)removeEditView;

@end
