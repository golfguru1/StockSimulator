//
//  AddTickerView.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-10-10.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "AddTickerView.h"

@implementation AddTickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor blackColor];
        
        UIButton *submit=[UIButton buttonWithType:UIButtonTypeCustom];
        submit.frame=CGRectMake(40, self.frame.size.height-50, 70, 20);
        [submit setTitle:@"Submit" forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:submit];
        
        _tickerTitle.frame=CGRectMake(0, 60, 50, 20);
        _tickerTitle.backgroundColor=[UIColor redColor];
        _tickerTitle.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        _tickerTitle.font=[UIFont fontWithName:@"Helvetica" size:14];
        [self addSubview:_tickerTitle];
        
    }
    return self;
}
-(void)submit{
    [self removeFromSuperview];
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
