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

+ (float)secondaryHue {return (85.0/360.0);}
+ (float)secondarySaturation {return 0.0;}
+ (float)secondaryValue {return 1.0;}

//implementation values
+ (UIColor*)toolbarColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.85 brightness:[AppColors primaryValue]*0.75 alpha:1];}

+ (UIColor*)mainBackgroundColor {return [UIColor whiteColor];}
+ (UIColor*)secondaryBackgroundColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.07 brightness:[AppColors primaryValue]*0.80 alpha:1];}
+ (UIColor*)tertiaryBackgroundColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.1 brightness:[AppColors primaryValue]*0.3 alpha:1];}

+ (UIColor*)blankItemBackgroundColor {return [UIColor colorWithHue:[AppColors secondaryHue] saturation:[AppColors secondarySaturation]*0.5 brightness:[AppColors primaryValue]*0.15 alpha:1];}

+ (UIColor*)mainTextColor {return [UIColor blackColor];}
+ (UIColor*)lightTextColor {return [UIColor whiteColor];}
+ (UIColor*)secondaryTextColor {return [UIColor colorWithHue:[AppColors secondaryHue] saturation:[AppColors secondarySaturation]*0.85 brightness:[AppColors secondaryValue]*0.54 alpha:1];}

+ (UIColor*)activityIndicatorColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.80 brightness:[AppColors primaryValue]*0.40 alpha:1];}

@end
