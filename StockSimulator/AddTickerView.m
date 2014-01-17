//
//  AddTickerView.m
//  StockSimulator
//
//  Created by Mark Hall on 2013-10-10.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "AddTickerView.h"
#import "StockDataManager.h"

@implementation AddTickerView{
    UIAlertView *alert1;
    UIAlertView *alert2;
    PFUser *currentUser;
    BOOL searchBarEditing;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        currentUser=[PFUser currentUser];
        self.backgroundColor=[UIColor stockSimulatorLightGrey];
        UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame=CGRectMake(10, 32, 25, 25);
        [backButton setImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchDown];
        [self addSubview:backButton];
        
        _bar=[[UISearchBar alloc]initWithFrame:CGRectMake(50, 30, self.frame.size.width-50, 30)];
        _bar.delegate=self;
        [_bar setBackgroundImage:[UIImage new]];
        [_bar setTranslucent:YES];
        _bar.showsCancelButton=YES;
        _bar.placeholder=@"Search for a Ticker";
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor stockSimulatorLightGrey]];
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont stockSimulatorFontWithSize:16]];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor stockSimulatorRed],UITextAttributeTextColor,nil,nil,nil,nil,nil] forState:UIControlStateNormal];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:0.5 alpha:0.3], UITextAttributeTextColor,nil,nil,nil,nil,nil] forState:UIControlStateDisabled];
        [self addSubview:_bar];
        
        UIButton *submit=[UIButton buttonWithType:UIButtonTypeCustom];
        submit.backgroundColor=[UIColor stockSimulatorBlue];
        submit.frame=CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 40);
        [submit setTitle:@"Submit" forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor stockSimulatorLightGrey]forState:UIControlStateNormal];
        [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        submit.tag=1;
        [self addSubview:submit];
        
        _tickerTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 95, self.frame.size.width, 100)];
        _tickerTitle.backgroundColor=[UIColor stockSimulatorDarkGrey];
        _tickerTitle.textColor=[UIColor stockSimulatorOrange];
        _tickerTitle.font=[UIFont stockSimulatorFontWithSize:65];
        _tickerTitle.textAlignment=NSTextAlignmentCenter;
        _tickerTitle.tag=1;
        [self addSubview:_tickerTitle];
        
        _currentPrice=[[UILabel alloc]initWithFrame:CGRectMake(0, 270, self.frame.size.width/2, 100)];
        _currentPrice.backgroundColor=[UIColor stockSimulatorDarkGrey];
        _currentPrice.textAlignment=NSTextAlignmentCenter;
        _currentPrice.textColor=[UIColor stockSimulatorGreen];
        _currentPrice.font=[UIFont stockSimulatorFontWithSize:30];
        _currentPrice.tag=1;
        
        UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, _currentPrice.frame.size.width, 20)];
        price.text=@"Price";
        price.textColor=[UIColor stockSimulatorGreen];
        price.font=[UIFont stockSimulatorFontWithSize:12];
        price.textAlignment=NSTextAlignmentCenter;
        [_currentPrice addSubview:price];
        [self addSubview:_currentPrice];
        
        
        _numOfShares=[[UITextField alloc]initWithFrame:CGRectMake(80, 400, self.frame.size.width-160, 40)];
        _numOfShares.delegate=self;
        _numOfShares.keyboardAppearance=UIKeyboardAppearanceDark;
        _numOfShares.keyboardType=UIKeyboardTypeNumberPad;
        _numOfShares.backgroundColor=[UIColor whiteColor];
        _numOfShares.layer.cornerRadius=5;
        _numOfShares.textColor=[UIColor stockSimulatorDarkGrey];
        _numOfShares.font=[UIFont stockSimulatorFontWithSize:25];
        _numOfShares.tag=1;
        _numOfShares.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_numOfShares];
        
        _companyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 170, self.frame.size.width, 100)];
        _companyLabel.backgroundColor=[UIColor stockSimulatorDarkGrey];
        _companyLabel.textColor=[UIColor stockSimulatorOrange];
        _companyLabel.font=[UIFont stockSimulatorFontWithSize:20];
        _companyLabel.textAlignment=NSTextAlignmentCenter;
        _companyLabel.tag=1;
        [self addSubview:_companyLabel];
        
        _cash=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 270, self.frame.size.width/2, 100)];
        _cash.backgroundColor=[UIColor stockSimulatorDarkGrey];
        _cash.textColor=[UIColor stockSimulatorBlue];
        _cash.text=[NSString stringWithFormat:@"$%@",[self formatNumber:[currentUser[@"cash"] doubleValue]]];
        _cash.font=[UIFont stockSimulatorFontWithSize:30];
        _cash.textAlignment=NSTextAlignmentLeft;
        _cash.tag=1;
        
        UILabel *cashL=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, _cash.frame.size.width, 20)];
        cashL.text=@"Cash";
        cashL.textColor=[UIColor stockSimulatorBlue];
        cashL.font=[UIFont stockSimulatorFontWithSize:12];
        cashL.textAlignment=NSTextAlignmentCenter;
        [_cash addSubview:cashL];
        [self addSubview:_cash];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(doneButtonDidPressed)];
        UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:NULL];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44.0f)];
        [toolbar setItems:[NSArray arrayWithObjects:flexableItem,doneItem, nil]];
        [toolbar setBackgroundColor:[UIColor blackColor]];
        _numOfShares.inputAccessoryView = toolbar;
        
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
    searchBarEditing=YES;
    for(UIView *subview in self.subviews)
        if(subview.tag==1)
            subview.hidden=YES;
    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    searchBarEditing=NO;
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    searchBar.text=searchBar.text.uppercaseString;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSMutableArray *stocks=[[self.parent userStocks]mutableCopy];
    BOOL found=NO;
    for(id stock in stocks){
        if([[stock valueForKey:@"ticker"] isEqualToString:_bar.text.uppercaseString]){
            found=YES;
        }
    }
    if(!found){
        NSDictionary *check=[[StockDataManager sharedManager] fetchQuotesFor:@[searchBar.text.uppercaseString]];
        if([check valueForKey:@"ErrorIndicationreturnedforsymbolchangedinvalid"]==(id)[NSNull null]){
            if([check valueForKey:@"Symbol"]!=(id)[NSNull null] && [check valueForKey:@"LastTradePriceOnly"]!=(id)[NSNull null] && [check valueForKey:@"Change"]!=(id)[NSNull null]){
                for(UIView *subview in self.subviews){
                    if(subview.tag==1){
                        subview.hidden=NO;
                    }
                }
                [_tickerTitle setText:searchBar.text.uppercaseString];
                [_currentPrice setText:[NSString stringWithFormat:@"$%@",[self formatNumber:[[check valueForKey:@"LastTradePriceOnly"]floatValue]]]];
                [_companyLabel setText:[check valueForKey:@"Name"]];
            }
            else{
                NSLog(@"you dun goofed");
            }
        }
        else{
            alert1=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Ticker not Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert1.tag=1;
            [alert1 show];
        }
        
    }
    else{
        alert2=[[UIAlertView alloc]initWithTitle:@"Error" message:@"You already own some of these stocks." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert2 show];
        alert2.tag=1;
    }
    [_bar resignFirstResponder];
    [_parent.table reloadData];
    searchBar.text=@"";
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1)
        [_bar becomeFirstResponder];
    else if (alertView.tag==2){
        [_numOfShares becomeFirstResponder];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
-(void)done{
    [self removeFromSuperview];
    
}
-(void)submit{
    int numShares=_numOfShares.text.intValue;
    if (numShares>0){
        [self endEditing:YES];
        NSString *priceString=[_currentPrice.text substringFromIndex:1];
        
        double currentCash=[currentUser[@"cash"] doubleValue];
        double newCash=currentCash-priceString.doubleValue*numShares;
        currentUser[@"cash"]=[NSNumber numberWithDouble:newCash];
        [currentUser save];
        
        PFObject *stock=[PFObject objectWithClassName:@"Stock"];
        stock[@"ticker"]=_tickerTitle.text.uppercaseString;
        stock[@"priceBoughtAt"]=[NSNumber numberWithFloat:[priceString floatValue]];
        stock[@"shares"]=[NSNumber numberWithInt:numShares];
        stock[@"user"]=currentUser.username;
        [stock save];
        
        [_parent.userStocks addObject:stock];
        [_parent refresh];
        [self removeFromSuperview];
        [_parent addObject];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error"
                                                     message:@"Please enter a valid number of stocks."
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        alert.tag=2;
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
    NSNumber *n = [NSNumber numberWithFloat: num];
    NSString *str = [nf stringFromNumber:n];
    return str;
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    if(!searchBarEditing){
        NSDictionary* keyboardInfo = [notification userInfo];
        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        NSTimeInterval time=[[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
        [UIView animateWithDuration:time
                              delay:0.0f
                            options:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                         animations:^{
                             [self setFrame:CGRectMake(0,-keyboardFrameBeginRect.size.height,self.frame.size.width, self.frame.size.height)];
                         }
                         completion:nil];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    if(!searchBarEditing){
        NSDictionary* keyboardInfo = [notification userInfo];
        NSTimeInterval time=[[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
        [UIView animateWithDuration:time animations:^{
            [self setFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
        }];
    }
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        // Will be removed from window, similar to -viewDidUnload.
        // Unsubscribe from any notifications here.
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:Nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:Nil];
    }
}

- (void)didMoveToWindow {
    if (self.window) {
        // Added to a window, similar to -viewDidLoad.
        // Subscribe to notifications here.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }
}
@end
