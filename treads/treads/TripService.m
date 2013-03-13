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
    [self.dataRepository getTripsMeetingCondition:[NSString stringWithFormat:@"id == %d", tripID] forTarget:target withAction:returnAction];
}

- (void)updateTrip:(Trip*)trip forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    NSMutableDictionary* tripDictionary = [[NSMutableDictionary alloc] init];
    [tripDictionary setObject:[NSNumber numberWithInt:trip.tripID] forKey:@"id"];
    [tripDictionary setObject:[NSNumber numberWithInt:trip.userID] forKey:@"userID"];
    [tripDictionary setObject:trip.name forKey:@"name"];
    [tripDictionary setObject:trip.description forKey:@"description"];
    [self.dataRepository updateTrip:[NSDictionary dictionaryWithDictionary:tripDictionary] forTarget:target withAction:returnAction];
}

#pragma mark - dummy services

//- (NSArray*)getAllTrips
//{
//    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
//    for (int i=0; i<100; i++) {
//        Trip* trip = [[Trip alloc] init];
//        trip.name = [NSString stringWithFormat:@"Global Test Trip %d", i];
//        [tempArray addObject:trip];
//    }
//    return [NSArray arrayWithArray:tempArray];
//}
//
//- (NSArray*)getFollowingTrips
//{
//    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
//    for (int i=0; i<100; i++) {
//        Trip* trip = [[Trip alloc] init];
//        trip.name = [NSString stringWithFormat:@"Following Test Trip %d", i];
//        [tempArray addObject:trip];
//    }
//    return [NSArray arrayWithArray:tempArray];
//}
//
//- (NSArray*)getFeedTrips
//{
//    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
//    for (int i=0; i<100; i++) {
//        Trip* trip = [[Trip alloc] init];
//        trip.name = [NSString stringWithFormat:@"Feed Test Trip %d", i];
//        [tempArray addObject:trip];
//    }
//    return [NSArray arrayWithArray:tempArray];
//}
//
//- (NSArray*)getTripsFromProfile:(NSString *)profileName
//{
//    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
//    for (int i=0; i<100; i++) {
//        Trip* trip = [[Trip alloc] init];
//        trip.name = [NSString stringWithFormat:@"%@'s Test Trip %d", profileName, i];
//        [tempArray addObject:trip];
//    }
//    return [NSArray arrayWithArray:tempArray];
//}

@end
