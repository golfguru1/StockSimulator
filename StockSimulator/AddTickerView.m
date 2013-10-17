//
//  AddTickerView.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-10-10.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "AddTickerView.h"
#import "StockDataManager.h"
#import "UserSettings.h"

@implementation AddTickerView{
        UISearchBar *bar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor blackColor];
        
        
        UIBarButtonItem *mySettingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
        UIBarButtonItem *mySpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIToolbar *myTopToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,65)];
        [myTopToolbar setItems:[NSArray arrayWithObjects:mySettingsButton,mySpacer, nil] animated:NO];
        myTopToolbar.backgroundColor=[UIColor grayColor];
        [self addSubview:myTopToolbar];
        bar=[[UISearchBar alloc]initWithFrame:CGRectMake(50, 20, self.frame.size.width-50, 50)];
        bar.delegate=self;
        [bar setBackgroundImage:[UIImage new]];
        [bar setTranslucent:YES];
        bar.showsCancelButton=YES;
        bar.placeholder=@"Search for a Ticker";
        [self addSubview:bar];
        
        UIButton *submit=[UIButton buttonWithType:UIButtonTypeCustom];
        submit.frame=CGRectMake(40, self.frame.size.height-50, 70, 20);
        [submit setTitle:@"Submit" forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        submit.tag=1;
        [self addSubview:submit];
        
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
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidPressed)];
        UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44.0f)];
        [toolbar setItems:[NSArray arrayWithObjects:flexableItem,doneItem, nil]];
        _numOfShares.inputAccessoryView = toolbar;
        
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
        
        for(UIView *subview in self.subviews)
            if(subview.tag==1)
                subview.hidden=YES;
        
    }
    return self;
}
-(void)doneButtonDidPressed{
    [_numOfShares resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    for(UIView *subview in self.subviews)
        if(subview.tag==1)
            subview.hidden=YES;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [bar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    for(UIView *subview in self.subviews)
        if(subview.tag==1)
            subview.hidden=NO;
    NSDictionary *check=[[StockDataManager sharedManager] fetchQuotesFor:@[searchBar.text.uppercaseString]];
    if([check valueForKey:@"ErrorIndicationreturnedforsymbolchangedinvalid"]==(id)[NSNull null]){
        [_tickerTitle setText:searchBar.text.uppercaseString];
        [_currentPrice setText:[NSString stringWithFormat:@"$%@",[check valueForKey:@"LastTradePriceOnly"]]];
        [_companyLabel setText:[check valueForKey:@"Name"]];
        
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Ticker not Found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    [bar resignFirstResponder];
    [_parent.table reloadData];
    searchBar.text=@"";
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [bar resignFirstResponder];
}
-(void)done{
    [self removeFromSuperview];
}
-(void)submit{
    NSString *priceString=[_currentPrice.text substringFromIndex:1];
    int numShares=_numOfShares.text.intValue;
    double currentCash=[[[UserSettings sharedManager]userCash]doubleValue];
    double newCash=currentCash-priceString.doubleValue*numShares;
    [[UserSettings sharedManager]setUserCash:[NSNumber numberWithDouble:newCash]];
    
    NSMutableArray *stocks=[[[UserSettings sharedManager]stockTickers]mutableCopy];
    if(![stocks containsObject:_tickerTitle.text.uppercaseString]){
        [stocks addObject:[NSString stringWithFormat:@"%@",_tickerTitle.text.uppercaseString]];
        [[UserSettings sharedManager]setStockList:stocks];
    }
    
    [self removeFromSuperview];
    [_parent.table reloadData];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:[[[UserSettings sharedManager]sharesOwned]copy]];
    [dict setObject:_numOfShares.text forKey:_tickerTitle.text];
    [[UserSettings sharedManager]setSharesOwned:dict];
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
