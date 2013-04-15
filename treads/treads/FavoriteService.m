//
//  FavoriteService.m
//  treads
//
//  Created by Zachary Kanoff on 4/14/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "FavoriteService.h"
#import "DataRepository.h"
#import "ImageService.h"
#import "User.h"
#import "Trip.h"

@implementation FavoriteService


static FavoriteService* repo;
+(FavoriteService*) instance {
    @synchronized(self) {
        if (!repo)
            repo = [[FavoriteService alloc] initWithRepository:[DataRepository instance]];
        return repo;
    }
}
- (id)initWithRepository:(DataRepository*)repository {
    if ((self = [super init])) {
        self.dataRepository = repository;
        self.dataTableIdentifier = @"favoritestable";
    }
    return self;
}

- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData {
    if (!returnData || returnData.count == 0) {return [NSArray array];}
    NSMutableArray* returnArray = [[NSMutableArray alloc] init];
    for (int i=0; i<returnData.count; i++) {
        NSMutableDictionary* newDictionary = [NSMutableDictionary dictionaryWithDictionary:returnData[i]];
        NSDictionary* favoriteTrip = newDictionary[@"favoriteTrip"];
        Trip* trip = [[Trip alloc] init];
        trip.tripID = [favoriteTrip[@"id"] intValue];
        trip.description = favoriteTrip[@"description"];
        trip.name = favoriteTrip[@"name"];
        trip.imageID = [favoriteTrip[@"imageID"] intValue];
        newDictionary[@"favoriteTrip"] = trip;
        [returnArray addObject:newDictionary];
    }
    return returnArray;
}

- (void) getMyFavs:(int)myID forTarget:(NSObject*)target withAction:(SEL)returnAction {
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"UserID = '%i'", myID] usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (void) addFav:(int)myID withTripID:(int)tripID fromTarget:(NSObject *) target withReturn:(SEL) returnAction {
    NSMutableDictionary * favDict = [[NSMutableDictionary alloc] init];
    
    [favDict  setValue:[NSNumber numberWithInt:myID]forKey:@"UserID"];
    [favDict  setValue:[NSNumber numberWithInt:tripID] forKey:@"TripID"];
    [self.dataRepository createDataItem:favDict usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (void) deleteFav:(NSString*)fav fromTarget:(NSObject *) target withReturn:(SEL) returnAction {
    
    
    [self.dataRepository deleteDataItem:fav usingService:self forRequestingObject:target withReturnAction:returnAction];
    
}

@end
