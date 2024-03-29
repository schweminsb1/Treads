//
//  AppColors.h
//  treads
//
//  Created by keavneyrj1 on 3/18/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppColors : NSObject

//raw values
+ (float)primaryHue;
+ (float)primarySaturation;
+ (float)primaryValue;

+ (float)secondaryHue;
+ (float)secondarySaturation;
+ (float)secondaryValue;

//implementation values
+ (UIColor*)toolbarColor;

+ (UIColor*)mainBackgroundColor;
+ (UIColor*)secondaryBackgroundColor;
+ (UIColor*)tertiaryBackgroundColor;

+ (UIColor*)blankItemBackgroundColor;

+ (UIColor*)mainTextColor;
+ (UIColor*)lightTextColor;
+ (UIColor*)secondaryTextColor;

+ (UIColor*)activityIndicatorColor;

@end
