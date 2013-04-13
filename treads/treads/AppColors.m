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
+ (float)primaryHue {return (195.0/360.0);} //blue
+ (float)primarySaturation {return 0.60;}
+ (float)primaryValue {return 0.86;}

+ (float)secondaryHue {return (0/360.0);} //white
+ (float)secondarySaturation {return 0;}
+ (float)secondaryValue {return 1;}

//other hue values: 275, 335, 70

//implementation values
+ (UIColor*)toolbarColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation] brightness:[AppColors primaryValue] alpha:1];}

+ (UIColor*)mainBackgroundColor {return [UIColor whiteColor];}
+ (UIColor*)secondaryBackgroundColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.05 brightness:[AppColors primaryValue] alpha:1];}
+ (UIColor*)tertiaryBackgroundColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.05 brightness:[AppColors primaryValue]*0.4 alpha:1];}

+ (UIColor*)blankItemBackgroundColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:0.30 brightness:0.10 alpha:1];}

+ (UIColor*)mainTextColor {return [UIColor blackColor];}
+ (UIColor*)lightTextColor {return [UIColor whiteColor];}
+ (UIColor*)secondaryTextColor {return [UIColor colorWithHue:[AppColors secondaryHue] saturation:[AppColors secondarySaturation] brightness:[AppColors secondaryValue]*0.5 alpha:1];}

+ (UIColor*)activityIndicatorColor {return [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation] brightness:[AppColors primaryValue]*0.50 alpha:1];}

@end
