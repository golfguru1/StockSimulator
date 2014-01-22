//
//  StockSimulatorConstants.h
//  StockSimulator
//
//  Created by Mark Hall on 12/6/2013.
//  Copyright (c) 2013 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (StockSimulator)

+ (UIColor *)stockSimulatorDarkGrey;
+ (UIColor *)stockSimulatorLightGrey;
+ (UIColor *)stockSimulatorBlue;
+ (UIColor *)stockSimulatorOrange;
+ (UIColor *)stockSimulatorRed;
+ (UIColor *)stockSimulatorGreen;
+ (UIColor *)stockSimulatorDarkRed;
+ (UIColor *)stockSimulatorDarkBlue;

@end

@interface UIFont (StockSimulator)  

+ (UIFont *)stockSimulatorFontWithSize:(int)size;

@end