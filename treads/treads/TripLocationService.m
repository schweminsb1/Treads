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


static TripLocationService* repo;
+(TripLocationService*) instance {
    @synchronized(self) {
        if (!repo)
            repo = [[TripLocationService alloc] initWithRepository:[DataRepository instance]];
        return repo;
    }
}

- (id)initWithRepository:(DataRepository*)repository {
    if ((self = [super init])) {
        self.dataRepository = repository;
        self.dataTableIdentifier = @"TripLocationReader";
    }
    return self;
}


- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData
{
    if (!returnData || returnData.count == 0) {return [NSArray array];}
    NSMutableArray* convertedData = [[NSMutableArray alloc] init];
    for (NSDictionary* returnTripLocation in returnData) {
        TripLocation* tripLocation = [[TripLocation alloc] init];
        @try {
            tripLocation.tripLocationID = [[returnTripLocation objectForKey:@"id"] intValue];
            tripLocation.tripID = [[returnTripLocation objectForKey:@"tripID"] intValue];
            tripLocation.locationID = [[returnTripLocation objectForKey:@"LocationID"] intValue];
            
            BOOL uniqueTrip = YES;
            for (TripLocation* oldTripLocation in convertedData) {
                if (oldTripLocation.tripID == tripLocation.tripID) {
                    uniqueTrip = NO;
                    break;
                }
            }
            if (uniqueTrip) {[convertedData addObject:tripLocation];}
        }
        @catch (NSException* exception) {
            //tripLocation.name = @"Error - could not parse trip data";
//            [convertedData addObject:tripLocation];
            continue;
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
- (void)getTripLocationWithLocation:(Location*)location withCompletion:(CompletionWithItemsandLocation)block1
{
    CompletionWithItems block = ^(NSArray * items)
    {
        block1(items,location);
    };
  
    [_dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"locationID = %@" , location.idField] usingService:self withReturnBlock:block];
}

@end
