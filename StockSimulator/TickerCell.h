//
//  TickerCell.h
//  StockSimulator
//
//  Created by Mark Hall on 12/6/2013.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TickerCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, strong)UILabel *tickerTitle;
@property (nonatomic, strong)UILabel *numberOfShares;
@property (nonatomic, strong)UILabel *change;
@property (nonatomic, strong)UILabel *boughtAt;
@property (nonatomic, strong)UILabel *currentPrice;
@property (nonatomic, strong)UILabel *buyNum;
@property (nonatomic, strong)UILabel *sellNum;
//@property (nonatomic, strong)UITextField *buyNum;
//@property (nonatomic, strong)UITextField *sellNum;
@end
