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
    
    UIButton *submitButton;
    
    UIStepper *buyStepper;
    UIStepper *sellStepper;
}

@synthesize tickerTitle,numberOfShares,change,boughtAt,currentPrice,sellNum,buyNum;

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
        
        //sellNum=[[UILabel alloc]init];
        sellNum=[[UITextField alloc]init];
        [sellNum setPlaceholder:@"Sell Shares"];
        [sellNum setKeyboardType:UIKeyboardTypeNumberPad];
        [sellNum setBackgroundColor:[UIColor stockSimulatorRed]];
        [sellNum setTextColor:[UIColor whiteColor]];
        [sellNum.layer setCornerRadius:4];
        [sellNum setFont:[UIFont stockSimulatorFontWithSize:14]];
        [sellNum setTextAlignment:NSTextAlignmentCenter];
        //[sellNum setText:@"Sell Shares"];
        sellNum.tag=1;
        [extendBg addSubview:sellNum];
        
        //buyNum=[[UILabel alloc]init];
        buyNum=[[UITextField alloc]init];
        [buyNum setPlaceholder:@"Buy Shares"];
        [buyNum setKeyboardType:UIKeyboardTypeNumberPad];
        [buyNum setBackgroundColor:[UIColor stockSimulatorGreen]];
        [buyNum setTextColor:[UIColor whiteColor]];
        [buyNum.layer setCornerRadius:4];
        [buyNum setFont:[UIFont stockSimulatorFontWithSize:14]];
        [buyNum setTextAlignment:NSTextAlignmentCenter];
        //[buyNum setText:@"Buy Shares"];
        buyNum.tag=2;
        [extendBg addSubview:buyNum];
        
        submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [submitButton setBackgroundImage:[UIImage imageNamed:@"LightBlue_Button.png"] forState:UIControlStateNormal];
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitButton setTitleColor:[UIColor stockSimulatorBlue] forState:UIControlStateSelected];
        [submitButton.titleLabel setFont:[UIFont stockSimulatorFontWithSize:16]];
        [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchDown];
        [extendBg addSubview:submitButton];
        
        buyStepper=[[UIStepper alloc]init];
        [buyStepper setTintColor:[UIColor stockSimulatorGreen]];
        [buyStepper setMinimumValue:0.0];
        [buyStepper addTarget:self action:@selector(buyStepperPressed:) forControlEvents:UIControlEventValueChanged];
        //[extendBg addSubview:buyStepper];
        
        //add maximum value as the number of shares they own
        sellStepper=[[UIStepper alloc]init];
        [sellStepper setTintColor:[UIColor stockSimulatorRed]];
        [sellStepper setMinimumValue:0.0];
        [sellStepper addTarget:self action:@selector(sellStepperPressed:) forControlEvents:UIControlEventValueChanged];
        //[extendBg addSubview:sellStepper];
        
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

    [sellNum setFrame:CGRectMake(10, 7, 120, 30)];
    [sellNum setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [buyNum setFrame:CGRectMake(10, 45, 120, 30)];
    [buyNum setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [sellStepper setFrame:CGRectMake(10, 45, 80, 30)];
    [buyStepper setFrame:CGRectMake(120, 45, 80, 30)];
    [submitButton setFrame:CGRectMake(extendBg.frame.size.width-80-7, 7, 80, 68)];
    
    [extendBg setFrame:CGRectMake(0, 70, self.contentView.frame.size.width, 90)];
}
-(void)buyStepperPressed:(UIStepper*)stepper{
    if(stepper.value){
        [buyNum setText:[NSString stringWithFormat:@"%d",(int)stepper.value]];
    }
    else{
        [buyNum setText:[NSString stringWithFormat:@"Buy Shares"]];
    }
}
-(void)sellStepperPressed:(UIStepper*)stepper{
    if(stepper.value){
        [sellNum setText:[NSString stringWithFormat:@"%d",(int)stepper.value]];
    }
    else{
        [sellNum setText:[NSString stringWithFormat:@"Sell Shares"]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:NO];
}
-(void)submit{
    //Add clearing of textfields
    //Add re-minimizing of cell
    NSLog(@"here");
    
}
@end
