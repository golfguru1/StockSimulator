//
//  StockSimulatorConstants.m
//  StockSimulator
//
//  Created by Mark Hall on 12/6/2013.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import "StockSimulatorConstants.h"

@implementation UIColor (StockSimulator)
+ (UIColor *)stockSimulatorDarkGrey{
    return [UIColor colorWithRed:22.0/255.0f
                           green:25.0/255.0f
                            blue:41.0/255.0f
                           alpha:1.0f];
}
+ (UIColor *)stockSimulatorLightGrey{
    return [UIColor colorWithRed:43.0/255.0f
                           green:50.0/255.0f
                            blue:81.0/255.0f
                           alpha:1.0f];
}
+ (UIColor *)stockSimulatorBlue{
    return [UIColor colorWithRed:66.0/255.0f
                           green:184.0/255.0f
                            blue:245.0/255.0f
                           alpha:1.0f];
}
+ (UIColor *)stockSimulatorOrange{
    return [UIColor colorWithRed:249.0/255.0f
                           green:162.0/255.0f
                            blue:63.0/255.0f
                           alpha:1.0f];
}
+ (UIColor *)stockSimulatorRed{
    return [UIColor colorWithRed:223.0/255.0f
                           green:52.0/255.0f
                            blue:83.0/255.0f
                           alpha:1.0f];
}
+ (UIColor *)stockSimulatorGreen{
    return [UIColor colorWithRed:26.0/255.0f
                           green:154.0/255.0f
                            blue:156.0/255.0f
                           alpha:1.0f];
}
+ (UIColor *)stockSimulatorDarkRed{
    return [UIColor colorWithRed:190.0/255.0f
                           green:28.0/255.0f
                            blue:59.0/255.0f
                           alpha:1.0f];
}
+ (UIColor *)stockSimulatorDarkBlue{
    return [UIColor colorWithRed:22.0/255.0f
                           green:58.0/255.0f
                            blue:131.0/255.0f
                           alpha:1.0f];
}
@end

@implementation UIFont (StockSimulator)

+ (UIFont *)stockSimulatorFontWithSize:(int)size{
    return [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:size];
}

@end
