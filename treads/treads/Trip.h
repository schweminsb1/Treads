//
//  Trip.h
//  treads
//
//  Created by keavneyrj1 on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TripLocation.h"
#import "TripLocationItem.h"

@interface Trip : NSObject

+ (int)UNDEFINED_TRIP_ID;

//header
@property int tripID; //id
@property int userID;
@property (copy) NSString* name;
@property (copy) NSString* description;
@property (strong) TripLocationItem* featuredLocationItem;

//location
@property (strong) NSArray* tripLocations;

@end
