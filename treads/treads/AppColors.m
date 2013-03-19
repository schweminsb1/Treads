//
//  AppColors.m
//  treads
//
//  Created by keavneyrj1 on 3/18/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "AppColors.h"

@implementation AppColors

//raw values
+ (float)primaryHue {return (85.0/360.0);}
+ (float)primarySaturation {return 1.0;}
+ (float)primaryValue {return 1.0;}

//implementation values
+ (UIColor*)toolbarColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.85 brightness:[AppColors primaryValue]*0.75 alpha:1];}

+ (UIColor*)mainBackgroundColor {return [UIColor whiteColor];}
+ (UIColor*)secondaryBackgroundColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.07 brightness:[AppColors primaryValue]*0.80 alpha:1];}

+ (UIColor*)mainTextColor {return [UIColor blackColor];}
+ (UIColor*)secondaryTextColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.85 brightness:[AppColors primaryValue]*0.54 alpha:1];}

+ (UIColor*)activityIndicatorColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.80 brightness:[AppColors primaryValue]*0.40 alpha:1];}

@end
