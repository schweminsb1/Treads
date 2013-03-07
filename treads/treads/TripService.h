//
//  TripService.h
//  treads
//
//  Created by keavneyrj1 on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripService : NSObject

//dummy services
- (NSArray*)getAllTrips;
- (NSArray*)getFollowingTrips;
- (NSArray*)getFeedTrips;
- (NSArray*)getTripsFromProfile: (NSString*)profileName;

@end
