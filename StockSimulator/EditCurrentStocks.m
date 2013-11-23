//
//  EditCurrentStocks.m
//  StockSimulator
//
//  Created by Mark Hall on 10/28/2013.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "EditCurrentStocks.h"
#import "UserSettings.h"

@implementation EditCurrentStocks

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor blackColor];
        
        UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame=CGRectMake(0, self.frame.size.height-60,self.frame.size.width, 40);
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        doneButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        [doneButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneButton];
        
        _tickerTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 40)];
        _tickerTitle.backgroundColor=[UIColor clearColor];
        _tickerTitle.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        _tickerTitle.font=[UIFont fontWithName:@"Helvetica" size:32];
        _tickerTitle.tag=1;
        [self addSubview:_tickerTitle];
        
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, 90, 30)];
        priceLabel.backgroundColor=[UIColor clearColor];
        priceLabel.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        priceLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        priceLabel.text=@"Current Price";
        priceLabel.tag=1;
        [self addSubview:priceLabel];
        
        UILabel *buyLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 170, 40, 30)];
        buyLabel.backgroundColor=[UIColor clearColor];
        buyLabel.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        buyLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        buyLabel.text=@"Buy";
        buyLabel.tag=1;
        [self addSubview:buyLabel];
        
        UILabel *buyLabel2=[[UILabel alloc]initWithFrame:CGRectMake(100, 170, 90, 30)];
        buyLabel2.backgroundColor=[UIColor clearColor];
        buyLabel2.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        buyLabel2.font=[UIFont fontWithName:@"Helvetica" size:14];
        buyLabel2.text=@"shares";
        buyLabel2.tag=1;
        [self addSubview:buyLabel2];
        
        _currentPrice=[[UILabel alloc]initWithFrame:CGRectMake(100, 130, 80, 30)];
        _currentPrice.backgroundColor=[UIColor clearColor];
        _currentPrice.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        _currentPrice.font=[UIFont fontWithName:@"Helvetica" size:14];
        _currentPrice.tag=1;
        [self addSubview:_currentPrice];
        
        _numOfShares=[[UITextField alloc]initWithFrame:CGRectMake(43, 170, 50, 30)];
        _numOfShares.delegate=self;
        _numOfShares.keyboardAppearance=UIKeyboardAppearanceDark;
        _numOfShares.keyboardType=UIKeyboardTypeNumberPad;
        _numOfShares.backgroundColor=[UIColor whiteColor];
        _numOfShares.layer.cornerRadius=5;
        _numOfShares.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        _numOfShares.font=[UIFont fontWithName:@"Helvetica" size:14];
        _numOfShares.tag=1;
        [self addSubview:_numOfShares];
        
        _companyLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 100, 180, 20)];
        _companyLabel.backgroundColor=[UIColor clearColor];
        _companyLabel.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        _companyLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        _companyLabel.tag=1;
        [self addSubview:_companyLabel];

        
        UILabel *currentCash=[[UILabel alloc]initWithFrame:CGRectMake(160, 170, 85, 30)];
        currentCash.backgroundColor=[UIColor clearColor];
        currentCash.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        currentCash.font=[UIFont fontWithName:@"Helvetica" size:14];
        currentCash.text=@"Your Cash:";
        currentCash.tag=1;
        [self addSubview:currentCash];
        
        _cash=[[UILabel alloc]initWithFrame:CGRectMake(233, 170, 83, 30)];
        _cash.backgroundColor=[UIColor clearColor];
        _cash.adjustsFontSizeToFitWidth = YES;
        _cash.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMinimumFractionDigits:2];
        [formatter setMaximumFractionDigits:2];
        _cash.text=[NSString stringWithFormat:@"$%@",[formatter stringFromNumber:[[UserSettings sharedManager]userCash]]];
        _cash.font=[UIFont fontWithName:@"Helvetica" size:14];
        _cash.tag=1;
        [self addSubview:_cash];

        UILabel *bigTitle=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 5, 200, 80)];
        bigTitle.text=@"Buy/Sell Shares";
        bigTitle.backgroundColor=[UIColor clearColor];
        bigTitle.textColor=[UIColor colorWithRed:58.0/255.0f green:169.0/255.0f blue:234.0/255.0f alpha:1.0f];
        bigTitle.font=[UIFont fontWithName:@"Helvetica" size:25];
        [self addSubview:bigTitle];
        
        _numOfSharesSell=[[UITextField alloc]initWithFrame:CGRectMake(43, 220, 50, 30)];
        _numOfSharesSell.delegate=self;
        _numOfSharesSell.keyboardAppearance=UIKeyboardAppearanceDark;
        _numOfSharesSell.keyboardType=UIKeyboardTypeNumberPad;
        _numOfSharesSell.backgroundColor=[UIColor whiteColor];
        _numOfSharesSell.layer.cornerRadius=5;
        _numOfSharesSell.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        _numOfSharesSell.font=[UIFont fontWithName:@"Helvetica" size:14];
        _numOfSharesSell.tag=1;
        [self addSubview:_numOfSharesSell];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidPressed:)];
        UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44.0f)];
        [toolbar setItems:[NSArray arrayWithObjects:flexableItem,doneItem, nil]];
        _numOfShares.inputAccessoryView = toolbar;
        _numOfSharesSell.inputAccessoryView=toolbar;
        
        UILabel *sellLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 220, 40, 30)];
        sellLabel.backgroundColor=[UIColor clearColor];
        sellLabel.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        sellLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        sellLabel.text=@"Sell";
        sellLabel.tag=1;
        [self addSubview:sellLabel];
        
        UILabel *sellLabel2=[[UILabel alloc]initWithFrame:CGRectMake(100, 220, 90, 30)];
        sellLabel2.backgroundColor=[UIColor clearColor];
        sellLabel2.textColor=[UIColor colorWithRed:253.0/255.0f green:198.0/255.0f blue:0/255.0f alpha:1.0f];
        sellLabel2.font=[UIFont fontWithName:@"Helvetica" size:14];
        sellLabel2.text=@"shares";
        sellLabel2.tag=1;
        [self addSubview:sellLabel2];
    }
    return self;
}
-(void)done{
    if([self superview])
        [_parent removeEditView];
}
-(void)doneButtonDidPressed:(id)sender{
    [_numOfShares resignFirstResponder];
    [_numOfSharesSell resignFirstResponder];    
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
