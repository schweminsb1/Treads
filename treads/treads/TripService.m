//
//  TripService.m
//  treads
//
//  Created by keavneyrj1 on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripService.h"

#import "DataRepository.h"
#import "Trip.h"

@interface TripService()

@property DataRepository* dataRepository;

@end

@implementation TripService

- (id)initWithRepository:(DataRepository*)repository {
    if ((self = [super init])) {
        self.dataRepository = repository;
    }
    return self;
}

- (void)getAllTripsForTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository getTripsMeetingCondition:@"" forTarget:target withAction:returnAction];
}

- (void)getTripWithID:(int)tripID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository getTripsMeetingCondition:[NSString stringWithFormat:@"id = '%d'", tripID] forTarget:target withAction:returnAction];
}

- (void)updateTrip:(Trip*)trip forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    /*if (trip.tripID == [Trip UNDEFINED_TRIP_ID]) {
     //get a valid ID before continuing
     trip.tripID = [self.dataRepository getNewTripID];
     
     //abort if failed
     if (trip.tripID == [Trip UNDEFINED_TRIP_ID]) {
     #pragma clang diagnostic push
     #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
     [target performSelector:returnAction withObject:[NSNumber numberWithInt: trip.tripID] withObject:[NSNumber numberWithBool:NO]];
     #pragma clang diagnostic pop
     return;
     }
     }*/
    NSMutableDictionary* tripDictionary = [[NSMutableDictionary alloc] init];
    if (trip.tripID != [Trip UNDEFINED_TRIP_ID]) {
        //[tripDictionary setObject:[NSString stringWithFormat:@"%d", trip.tripID] forKey:@"id"];
        [tripDictionary setObject:[NSNumber numberWithInt:trip.tripID] forKey:@"id"];
    }
    else {
        [tripDictionary setObject:[NSNull null] forKey:@"id"];
    }
    //[tripDictionary setObject:[NSString stringWithFormat:@"%d", trip.userID] forKey:@"userID"];
    [tripDictionary setObject:[NSNumber numberWithInt:trip.userID] forKey:@"userID"];
    [tripDictionary setObject:trip.name forKey:@"name"];
    [tripDictionary setObject:trip.description forKey:@"description"];
    [self.dataRepository updateTrip:[NSDictionary dictionaryWithDictionary:tripDictionary] forTarget:target withAction:returnAction];
}

@end
