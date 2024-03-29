//
//  TripLocation.h
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TripLocation : NSObject

+ (int)UNDEFINED_TRIPLOCATION_ID;

//identifiers
@property int tripLocationID; //id
@property int tripID;

@property int locationID;
@property (copy) NSString* locationName;

//data
@property (copy) NSString* description; //(summary)
@property (strong) NSArray* tripLocationItems;

//only used for importing
@property int index;

@end
