//
//  EditCurrentStocks.m
//  StockSimulator
//
//  Created by Mark Hall on 10/28/2013.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "EditCurrentStocks.h"

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
    }
    return self;
}
-(void)done{
    if([self superview])
        [_parent removeEditView];
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
