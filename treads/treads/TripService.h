//
//  TripService.h
//  treads
//
//  Created by keavneyrj1 on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataRepository;
@class Trip;

@interface TripService : NSObject

- (id)initWithRepository:(DataRepository*)repository;

- (void)getAllTripsForTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)getTripWithID:(int)tripID forTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)updateTrip:(Trip*)trip forTarget:(NSObject*)target withAction:(SEL)returnAction;

@end
