//
//  TripService.h
//  treads
//
//  Created by keavneyrj1 on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataRepository;

@interface TripService : NSObject

- (id)initWithRepository:(DataRepository*)repository;

- (void)getAllTripsForTarget:(NSObject*)target withAction:(SEL) returnAction;
- (void)getTripWithID:(int)tripID forTarget:(NSObject *)target withAction:(SEL)returnAction;
- (void)updateTripWithID:(int)tripID forTarget:(NSDictionary *)target withAction:(SEL)returnAction;

//dummy services
//- (NSArray*)getAllTrips;
//- (NSArray*)getFollowingTrips;
//- (NSArray*)getFeedTrips;
//- (NSArray*)getTripsFromProfile: (NSString*)profileName;

@end
