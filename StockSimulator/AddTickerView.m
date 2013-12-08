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
#import "StockSimulatorConstants.h"

@implementation AddTickerView{
    UISearchBar *bar;
    
    UIAlertView *alert1;
    UIAlertView *alert2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
#warning get rid of this stupid top tool bar and make your own!
        self.backgroundColor=[UIColor stockSimulatorLightGrey];
        UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame=CGRectMake(10, 32, 25, 25);
        [backButton setImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchDown];
        [self addSubview:backButton];
        
        bar=[[UISearchBar alloc]initWithFrame:CGRectMake(50, 30, self.frame.size.width-50, 30)];
        bar.delegate=self;
        [bar setBackgroundImage:[UIImage new]];
        [bar setTranslucent:YES];
        bar.showsCancelButton=YES;
        bar.placeholder=@"Search for a Ticker";
        [bar becomeFirstResponder];
        [self addSubview:bar];
        
        UIButton *submit=[UIButton buttonWithType:UIButtonTypeCustom];
        submit.backgroundColor=[UIColor stockSimulatorBlue];
        submit.frame=CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 40);
        [submit setTitle:@"Submit" forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor stockSimulatorLightGrey]forState:UIControlStateNormal];
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
        _cash.text=[NSString stringWithFormat:@"$%@",[self formatNumber:[[[UserSettings sharedManager]userCash]floatValue]]];
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
    NSMutableArray *stocks=[[[UserSettings sharedManager]stockTickers]mutableCopy];
    if([stocks containsObject:searchBar.text.uppercaseString]){
        alert2=[[UIAlertView alloc]initWithTitle:@"Error" message:@"You already own some of these stocks." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert2 show];
        alert2.tag=1;
    }
    else{
        NSDictionary *check=[[StockDataManager sharedManager] fetchQuotesFor:@[searchBar.text.uppercaseString]];
        if([check valueForKey:@"ErrorIndicationreturnedforsymbolchangedinvalid"]==(id)[NSNull null]){
            for(UIView *subview in self.subviews)
                if(subview.tag==1)
                    subview.hidden=NO;
            [_tickerTitle setText:searchBar.text.uppercaseString];
            [_currentPrice setText:[NSString stringWithFormat:@"$%@",[self formatNumber:[[check valueForKey:@"LastTradePriceOnly"]floatValue]]]];
            [_companyLabel setText:[check valueForKey:@"Name"]];
            
        }
        else{
            alert1=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Ticker not Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert1.tag=1;
            [alert1 show];
        }
    }
    [bar resignFirstResponder];
    [_parent.table reloadData];
    searchBar.text=@"";
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1)
        [bar becomeFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [bar resignFirstResponder];
}
-(void)done{
    [self removeFromSuperview];
}
-(void)submit{
    int numShares=_numOfShares.text.intValue;
    if (numShares>0){
        NSString *priceString=[_currentPrice.text substringFromIndex:1];
        
        double currentCash=[[[UserSettings sharedManager]userCash]doubleValue];
        double newCash=currentCash-priceString.doubleValue*numShares;
        [[UserSettings sharedManager]setUserCash:[NSNumber numberWithDouble:newCash]];
        
        NSMutableArray *stocks=[[[UserSettings sharedManager]stockTickers]mutableCopy];
        if(![stocks containsObject:_tickerTitle.text.uppercaseString]){
            [stocks addObject:[NSString stringWithFormat:@"%@",_tickerTitle.text.uppercaseString]];
            [[UserSettings sharedManager]setStockList:stocks];
        }
        
        [self removeFromSuperview];
        [_parent refresh];
        [_parent.table reloadData];
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:[[[UserSettings sharedManager]sharesOwned]copy]];
        [dict setObject:_numOfShares.text forKey:_tickerTitle.text];
        [[UserSettings sharedManager]setSharesOwned:dict];
        
        NSMutableDictionary *dict2=[[NSMutableDictionary alloc]initWithDictionary:[[[UserSettings sharedManager]priceBought]copy]];
        [dict2 setObject:[_currentPrice.text substringFromIndex:1] forKey:_tickerTitle.text];
        [[UserSettings sharedManager]setPriceBought:dict2];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter a valid number of stocks." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}
-(NSString*)formatNumber:(float)num{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setGroupingSize:3];
    [nf setGroupingSeparator:@","];
    [nf setUsesGroupingSeparator:YES];
    [nf setMaximumFractionDigits:2];
    [nf setMinimumFractionDigits:2];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // you should create a string from number
    NSNumber *n = [NSNumber numberWithFloat: num];
    NSString *str = [nf stringFromNumber:n];
    
    return str;
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
