//
//  TripLocationItem.m
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripLocationItem.h"

@interface TripLocationItem()

@end

@implementation TripLocationItem

+ (int)UNDEFINED_IMAGE_ID {return -1;}

- (UIImage*)displayImage {return self.image;}
- (NSObject*)displayItem {return self.description;}

@end
