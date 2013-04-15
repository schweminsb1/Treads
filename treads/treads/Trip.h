//
//  Trip.h
//  treads
//
//  Created by keavneyrj1 on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TripLocation.h"
#import "TripLocationItem.h"

@interface Trip : NSObject

+ (int)UNDEFINED_TRIP_ID;

//header
@property int tripID; //id
@property (copy) NSString* name;
@property int userID;
@property int imageID;
@property (copy) NSString* description;

//location
@property (strong) NSArray* tripLocations;

//derived information
@property (copy) NSString* username;
@property int profileImageID;
@property (strong) UIImage* profileImage;
@property (strong) UIImage* image;
@property int published;

@end
