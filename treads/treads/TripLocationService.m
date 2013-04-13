//
//  TripLocationService.m
//  treads
//
//  Created by Zachary Kanoff on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripLocationService.h"

#import "DataRepository.h"
#import "TripLocation.h"

@implementation TripLocationService

- (id)initWithRepository:(DataRepository*)repository {
    if ((self = [super init])) {
        self.dataRepository = repository;
        self.dataTableIdentifier = @"TripsLocations";
    }
    return self;
}


- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData
{
    NSMutableArray* convertedData = [[NSMutableArray alloc] init];
    for (NSDictionary* returnTripLocation in returnData) {
        TripLocation* tripLocation = [[TripLocation alloc] init];
        @try {
            tripLocation.tripLocationID = [[returnTripLocation objectForKey:@"id"] intValue];
            tripLocation.tripID = [[returnTripLocation objectForKey:@"TripID"] intValue];
            tripLocation.locationID = [[returnTripLocation objectForKey:@"LocationID"] intValue];
            
            [convertedData addObject:tripLocation];
        }
        @catch (NSException* exception) {
            //tripLocation.name = @"Error - could not parse trip data";
            [convertedData addObject:tripLocation];
        }
    }
    return [NSArray arrayWithArray:convertedData];
}

- (void)getAllTripLocationsForTarget:(NSObject*)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:nil usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (void)getTripLocationWithID:(int)tripLocationID forTarget:(NSObject*)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"id = '%d'", tripLocationID] usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (void)updateTripLocation:(TripLocation*)tripLocation forTarget:(NSObject*)target withAction:(SEL)returnAction
{
    NSMutableDictionary* tripLocationDictionary = [[NSMutableDictionary alloc] init];
    [tripLocationDictionary setObject:[NSNumber numberWithInt:tripLocation.tripID] forKey:@"TripID"];
    [tripLocationDictionary setObject:[NSNumber numberWithInt:tripLocation.locationID] forKey:@"LocationID"];
    if (tripLocation.tripLocationID == [TripLocation UNDEFINED_TRIPLOCATION_ID]) {
        [self.dataRepository createDataItem:tripLocationDictionary usingService:self forRequestingObject:target withReturnAction:returnAction];
    }
    else {
        [tripLocationDictionary setObject:[NSNumber numberWithInt:tripLocation.tripLocationID] forKey:@"id"];
        [self.dataRepository updateDataItem:tripLocationDictionary usingService:self forRequestingObject:target withReturnAction:returnAction];
    }
}
- (void)getTripLocationWithLocation:(Location*)location withCompletion:(CompletionWithItemsandLocation)block1{
    
    CompletionWithItems block= ^(NSArray * items)
    {
        block1(items,location);
        
    };
    NSMutableArray * temp= [[NSMutableArray alloc] init];
    int num= rand()%5;
    for(int i=0; i< num; i++)
    {
        [temp addObject:@""];
        
    }
    
    block1(temp,location);
  //  [_dataRepository retrieveDataItemsMatching:[NSString stringWithFormat: @"locationID = %d",[location.idField intValue]] usingService:self withReturnBlock:block];
}

@end
