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

//@property DataRepository* dataRepository;

@end

@implementation TripService

- (id)initWithRepository:(DataRepository*)repository {
    if ((self = [super init])) {
        self.dataRepository = repository;
        self.dataTableIdentifier = @"TripTable";
    }
    return self;
}

- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData
{
    NSMutableArray* convertedData = [[NSMutableArray alloc] init];
    for (NSDictionary* returnTrip in returnData) {
        Trip* trip = [[Trip alloc] init];
        @try {
            trip.tripID = [[returnTrip objectForKey:@"id"] intValue];
            trip.userID = [[returnTrip objectForKey:@"userID"] intValue];
            trip.name = [returnTrip objectForKey:@"name"];
            trip.description = [returnTrip objectForKey:@"description"];
            trip.tripLocations = [[NSArray alloc] init];
            
            [self addDebugItemsToTrip:trip];
            
            [convertedData addObject:trip];
        }
        @catch (NSException* exception) {
            trip.name = @"Error - could not parse trip data";
            [convertedData addObject:trip];
        }
    }
    return [NSArray arrayWithArray:convertedData];
}

- (void)addDebugItemsToTrip:(Trip*)trip
{
    //debug items - test models for items currently not implemented server-side
    
    //featured item
    TripLocationItem* dummyLocationItem = [[TripLocationItem alloc] init];
    dummyLocationItem.image = [UIImage imageNamed:@"mountains.jpeg"];
    trip.featuredLocationItem = dummyLocationItem;
    
    //locations
    NSMutableArray* dummyLocationArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 6; i++) {
        TripLocation* dummyLocation = [[TripLocation alloc] init];
        dummyLocation.tripLocationID = i;
        dummyLocation.tripID = trip.tripID;
        dummyLocation.locationID = i;
        dummyLocation.description = [NSString stringWithFormat:@"Description for Trip Location %d", i];
        if (i % 2 == 0) {dummyLocation.tripLocationItems = [[NSArray alloc] initWithObjects:dummyLocationItem, nil];}
        [dummyLocationArray addObject:dummyLocation];
    }
    
    trip.tripLocations = [NSArray arrayWithArray:dummyLocationArray];
}

- (void)getAllTripsForTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:nil usingService:self forRequestingObject:target withReturnAction:returnAction];
    //[self.dataRepository getTripsMeetingCondition:@"" forTarget:target withAction:returnAction];
}

- (void)getTripWithID:(int)tripID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"id = '%d'", tripID] usingService:self forRequestingObject:target withReturnAction:returnAction];
    //[self.dataRepository getTripsMeetingCondition:[NSString stringWithFormat:@"id = '%d'", tripID] forTarget:target withAction:returnAction];
}

- (void)updateTrip:(Trip*)trip forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    NSMutableDictionary* tripDictionary = [[NSMutableDictionary alloc] init];
    [tripDictionary setObject:[NSNumber numberWithInt:trip.userID] forKey:@"userID"];
    [tripDictionary setObject:trip.name forKey:@"name"];
    [tripDictionary setObject:trip.description forKey:@"description"];
    if (trip.tripID == [Trip UNDEFINED_TRIP_ID]) {
        [self.dataRepository createDataItem:tripDictionary usingService:self forRequestingObject:target withReturnAction:returnAction];
    }
    else {
        [tripDictionary setObject:[NSNumber numberWithInt:trip.tripID] forKey:@"id"];
        [self.dataRepository updateDataItem:tripDictionary usingService:self forRequestingObject:target withReturnAction:returnAction];
    }
    //[self.dataRepository updateTrip:[NSDictionary dictionaryWithDictionary:tripDictionary] forTarget:target withAction:returnAction];
}

@end
