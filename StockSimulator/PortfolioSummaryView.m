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

@implementation PortfolioSummaryView{
    UIPageControl *pageControl;
    UIScrollView *bottomView;
}
@synthesize /*totalStockValue,todayChange,*/totalCash,totalValue,cashTitle,valueTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor stockSimulatorLightGrey];
        self.layer.borderWidth=1;
        self.layer.borderColor=[[UIColor stockSimulatorDarkGrey]CGColor];
        
        bottomView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bottomView.contentSize=CGSizeMake(frame.size.width*2, frame.size.height);
        bottomView.pagingEnabled=YES;
        bottomView.showsHorizontalScrollIndicator=NO;
        bottomView.delegate=self;
//        
//        todayChange=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height/2)];
//        todayChange.textColor=[UIColor stockSimulatorDarkGrey];
//        todayChange.textAlignment=NSTextAlignmentCenter;
//        todayChange.font=[UIFont stockSimulatorFontWithSize:14];
//        [self addSubview:todayChange];
//        
//        totalStockValue=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/2)];
//        totalStockValue.textColor=[UIColor stockSimulatorDarkGrey];
//        totalStockValue.backgroundColor=[UIColor stockSimulatorBlue];
//        totalStockValue.alpha=0.5;
//        totalStockValue.textAlignment=NSTextAlignmentCenter;
//        totalStockValue.font=[UIFont stockSimulatorFontWithSize:14];
//        [self addSubview:totalStockValue];
        
        totalCash=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        totalCash.textColor=[UIColor stockSimulatorDarkGrey];
        totalCash.backgroundColor=[UIColor stockSimulatorBlue];
        totalCash.textAlignment=NSTextAlignmentCenter;
        totalCash.font=[UIFont stockSimulatorFontWithSize:30];
        [bottomView addSubview:totalCash];
        
        totalValue=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        totalValue.textColor=[UIColor stockSimulatorDarkGrey];
        totalValue.backgroundColor=[UIColor stockSimulatorOrange];
        totalValue.textAlignment=NSTextAlignmentCenter;
        totalValue.font=[UIFont stockSimulatorFontWithSize:30];
        [bottomView addSubview:totalValue];
        
        cashTitle=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width, 2, self.frame.size.width, 20)];
        cashTitle.textColor=[UIColor stockSimulatorDarkGrey];
        cashTitle.textAlignment=NSTextAlignmentCenter;
        cashTitle.font=[UIFont stockSimulatorFontWithSize:12];
        cashTitle.text=@"Total Cash";
        [bottomView addSubview:cashTitle];
        
        valueTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.frame.size.width, 20)];
        valueTitle.textColor=[UIColor stockSimulatorDarkGrey];
        valueTitle.textAlignment=NSTextAlignmentCenter;
        valueTitle.font=[UIFont stockSimulatorFontWithSize:12];
        [bottomView addSubview:valueTitle];
        
        [self addSubview:bottomView];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.size.width/2,frame.size.height-15,10,5)];
        [pageControl setNumberOfPages:2];
        [pageControl setCurrentPage:0];
        [pageControl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:pageControl];

    }
    return self;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int newOffset = scrollView.contentOffset.x;
    int newPage = (int)(newOffset/(scrollView.frame.size.width));
    [pageControl setCurrentPage:newPage];
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
