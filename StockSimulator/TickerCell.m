//
//  TickerCell.m
//  StockSimulator
//
//  Created by Mark Hall on 12/6/2013.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "TickerCell.h"
#import "StockSimulatorConstants.h"

@implementation TickerCell{
    UIView *extendBg;
}

@synthesize tickerTitle,numberOfShares,change,boughtAt,currentPrice;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView setBackgroundColor:[UIColor stockSimulatorDarkGrey]];
        [self.contentView setFrame:CGRectMake(0, 0, 320, 170)];
        
        tickerTitle=[[UILabel alloc]init];
        [tickerTitle setBackgroundColor:[UIColor clearColor]];
        [tickerTitle setFont:[UIFont stockSimulatorFontWithSize:25]];
        [tickerTitle setTextColor:[UIColor stockSimulatorOrange]];
        [tickerTitle setTextAlignment:NSTextAlignmentLeft];
        [tickerTitle sizeToFit];
        [self.contentView addSubview:tickerTitle];
        
        numberOfShares=[[UILabel alloc]init];
        [numberOfShares setBackgroundColor:[UIColor clearColor]];
        [numberOfShares setFont:[UIFont stockSimulatorFontWithSize:20]];
        [numberOfShares setTextAlignment:NSTextAlignmentLeft];
        [numberOfShares setTextColor:[UIColor stockSimulatorDarkBlue]];
        [numberOfShares sizeToFit];
        [self.contentView addSubview:numberOfShares];
        
        change=[[UILabel alloc]init];
        [change setBackgroundColor:[UIColor clearColor]];
        [change setFont:[UIFont stockSimulatorFontWithSize:18]];
        [change setTextAlignment:NSTextAlignmentRight];
        [change sizeToFit];
        [self.contentView addSubview:change];
        
        boughtAt=[[UILabel alloc]init];
        [boughtAt setBackgroundColor:[UIColor clearColor]];
        [boughtAt setFont:[UIFont stockSimulatorFontWithSize:18]];
        [boughtAt setTextAlignment:NSTextAlignmentLeft];
        [boughtAt setTextColor:[UIColor stockSimulatorLightGrey]];
        [boughtAt sizeToFit];
        [self.contentView addSubview:boughtAt];
        
        currentPrice=[[UILabel alloc]init];
        [currentPrice setBackgroundColor:[UIColor clearColor]];
        [currentPrice setFont:[UIFont stockSimulatorFontWithSize:18]];
        [currentPrice setTextAlignment:NSTextAlignmentRight];
        [currentPrice setTextColor:[UIColor stockSimulatorBlue]];
        [currentPrice setAlpha:0.5];
        [currentPrice sizeToFit];
        [self.contentView addSubview:currentPrice];
        
        extendBg=[[UIView alloc]init];
        [extendBg setBackgroundColor:[UIColor stockSimulatorLightGrey]];
        [self.contentView addSubview:extendBg];
        
    }
    return self;
}
-(void)layoutSubviews{
    [tickerTitle setFrame:CGRectMake(10, 2, 80, 35)];
    [numberOfShares setFrame:CGRectMake(tickerTitle.frame.size.width+10, 5, self.contentView.frame.size.width/2, 20)];
    [change setFrame:CGRectMake(self.contentView.frame.size.width/2, 2, self.contentView.frame.size.width/2-5, 35)];
    [boughtAt setFrame:CGRectMake(15, 35, self.contentView.frame.size.width/2, 35)];
    [currentPrice setFrame:CGRectMake(self.contentView.frame.size.width/2, 35, self.contentView.frame.size.width/2-5, 35)];
    [extendBg setFrame:CGRectMake(0, 70, self.contentView.frame.size.width, 100)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:NO];
}
@end
