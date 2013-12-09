//
//  PortfolioSummaryView.m
//  StockSimulator
//
//  Created by Mark Hall on 12/7/2013.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "PortfolioSummaryView.h"
#import "StockSimulatorConstants.h"
#import "UserSettings.h"
#import "StockDataManager.h"

@implementation PortfolioSummaryView
@synthesize totalStockValue,todayChange,totalCash,totalValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor stockSimulatorLightGrey];
        self.layer.borderWidth=1;
        self.layer.borderColor=[[UIColor stockSimulatorDarkGrey]CGColor];
        
        todayChange=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height/2)];
        todayChange.textColor=[UIColor stockSimulatorDarkGrey];
        todayChange.textAlignment=NSTextAlignmentCenter;
        todayChange.font=[UIFont stockSimulatorFontWithSize:14];
        [self addSubview:todayChange];
        
        totalStockValue=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/2)];
        totalStockValue.textColor=[UIColor stockSimulatorDarkGrey];
        totalStockValue.backgroundColor=[UIColor stockSimulatorBlue];
        totalStockValue.alpha=0.5;
        totalStockValue.textAlignment=NSTextAlignmentCenter;
        totalStockValue.font=[UIFont stockSimulatorFontWithSize:14];
        [self addSubview:totalStockValue];
        
        totalCash=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/2)];
        totalCash.textColor=[UIColor stockSimulatorDarkGrey];
        totalCash.backgroundColor=[UIColor stockSimulatorBlue];
        totalCash.textAlignment=NSTextAlignmentCenter;
        totalCash.font=[UIFont stockSimulatorFontWithSize:14];
        [self addSubview:totalCash];
        
        totalValue=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/2)];
        totalValue.textColor=[UIColor stockSimulatorDarkGrey];
        totalValue.backgroundColor=[UIColor stockSimulatorOrange];
        totalValue.textAlignment=NSTextAlignmentCenter;
        totalValue.font=[UIFont stockSimulatorFontWithSize:14];
        [self addSubview:totalValue];
        
        

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
