//
//  AddTickerView.h
//  StockSimulator
//
//  Created by Mark Hall on 2013-10-10.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface AddTickerView : UIView <UITextFieldDelegate, UISearchBarDelegate>
@property (nonatomic, retain)UILabel *tickerTitle;
@property (nonatomic, retain)UILabel *currentPrice;
@property (nonatomic, retain)UITextField *numOfShares;
@property (nonatomic, retain)UILabel *companyLabel;
@property (nonatomic, retain)SearchViewController *parent;
@property (nonatomic, retain)UILabel *cash;

@end
