//
//  TripLocationItem.m
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripLocationItem.h"

#import "ImageScrollDisplayableItem.h"

@interface TripLocationItem()<ImageScrollDisplayableItem>

@end

@implementation TripLocationItem

- (UIImage*)displayImage {return self.image;}
- (NSObject*)displayItem {return self.description;}

@end
