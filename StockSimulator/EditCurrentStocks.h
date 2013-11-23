//
//  EditCurrentStocks.h
//  StockSimulator
//
//  Created by Mark Hall on 10/28/2013.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface EditCurrentStocks : UIView <UITextFieldDelegate>
@property (nonatomic, strong)SearchViewController *parent;
@property (nonatomic, retain)UILabel *tickerTitle;
@property (nonatomic, retain)UILabel *currentPrice;
@property (nonatomic, retain)UITextField *numOfShares;
@property (nonatomic, retain)UITextField *numOfSharesSell;
@property (nonatomic, retain)UILabel *companyLabel;
@property (nonatomic, retain)UILabel *cash;
@end
