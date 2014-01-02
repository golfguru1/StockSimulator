//
//  PortfolioSummaryView.h
//  StockSimulator
//
//  Created by Mark Hall on 12/7/2013.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortfolioSummaryView : UIView <UIScrollViewDelegate>

//@property (nonatomic, strong)UILabel *todayChange;
//@property (nonatomic, strong)UILabel *totalStockValue;
@property (nonatomic, strong)UILabel *totalCash;
@property (nonatomic, strong)UILabel *totalValue;
@property (nonatomic, strong)UILabel *cashTitle;
@property (nonatomic, strong)UILabel *valueTitle;

@end
