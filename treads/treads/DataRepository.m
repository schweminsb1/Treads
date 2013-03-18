//
//  DataRepository.m
//  treads
//
//  Created by keavneyrj1 on 3/12/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "DataRepository.h"
#import "Trip.h"

@interface DataRepository() {
    NSString* TRIP_TABLE;
}

@end

@implementation DataRepository

- (id)init
{
    if ((self = [super init])) {
        self.client = [MSClient clientWithApplicationURLString:@"https://treads.azure-mobile.net/" withApplicationKey:@"uxbEolJjpIKEpNJSnsNEuGehMowvxj53"];
        TRIP_TABLE = @"TripTable";
    }
    return self;
}

- (void)getTripsMeetingCondition:(NSString*)predicateBody forTarget:(NSObject*)target withAction:(SEL)returnAction
{
    MSTable* MyTripsTable = [self.client getTable:TRIP_TABLE];
    MSReadQueryBlock queryBlock=^(NSArray* items, NSInteger totalCount, NSError *error) {
        if (error == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:returnAction withObject:[self convertDataToTripModel:items]];
#pragma clang diagnostic pop
        }
    };
    
    __autoreleasing NSError* error = [[NSError alloc] init];
    
    MSQuery* query;
    if ([predicateBody isEqual: @""]) {
        query = [[MSQuery alloc]initWithTable:MyTripsTable];
    }
    else {
        query= [[MSQuery alloc]initWithTable:MyTripsTable withPredicate:[NSPredicate predicateWithFormat:predicateBody]];
    }
    
    [MyTripsTable readWithQueryString:[query queryStringOrError:&error] completion:queryBlock];
}

- (NSArray*)convertDataToTripModel:(NSArray*)sourceData
{
    NSMutableArray* returnData = [[NSMutableArray alloc] init];
    for (NSDictionary* sourceTrip in sourceData) {
        Trip* trip = [[Trip alloc] init];
        @try {
            trip.tripID = [[sourceTrip objectForKey:@"id"] intValue];
            trip.userID = [[sourceTrip objectForKey:@"userID"] intValue];
            trip.name = [sourceTrip objectForKey:@"name"];
            trip.description = [sourceTrip objectForKey:@"description"];
            [returnData addObject:trip];
        }
        @catch (NSException* exception) {
            trip.name = @"Error - could not parse trip data";
            [returnData addObject:trip];
        }
    }
    return [NSArray arrayWithArray:returnData];
}

- (void)updateTrip:(NSDictionary*)tripDictionary forTarget:(NSObject*)target withAction:(SEL)returnAction
{
    MSTable* userTable = [self.client getTable:TRIP_TABLE];
    MSItemBlock updateBlock=^(NSDictionary* item, NSError* error) {
        if (error == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:returnAction withObject:[item objectForKey:@"id"] withObject:[NSNumber numberWithBool:YES]]; //withObject:[self convertDataToTripModel:items]];
#pragma clang diagnostic pop
        }
        else {
            //NSLog([error localizedDescription]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:returnAction withObject:[NSNull null] withObject:[NSNumber numberWithBool:NO]];
#pragma clang diagnostic pop
        }
    };
    //NSLog(tripDictionary.description);
    if ([tripDictionary objectForKey:@"id"] != [NSNull null]) {
        [userTable update:tripDictionary completion:updateBlock];
    }
    else {
        NSMutableDictionary* mutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:tripDictionary];
        [mutableDictionary removeObjectForKey:@"id"];
        [userTable insert:[NSDictionary dictionaryWithDictionary:mutableDictionary] completion:updateBlock];
    }
}

- (void)addLocation:(NSDictionary*)newLocation forTarget:(NSObject*) target withAction: (SEL) returnAction
{
     MSTable * LocationTable=  [self.client getTable:@"LocationTable"];
    MSItemBlock itemBlock=^(NSDictionary *item, NSError *error)
    {
        if(error)
        {
            NSLog( [error localizedDescription]);
            
        }
        else
        {
            
            [target performSelector:returnAction];
            // root view controller is the tabBar
            //_appDelegate.window.rootViewController= _appDelegate.tabBarController;
            
        }
    };
    [LocationTable insert:newLocation completion:itemBlock];
        
    
}

-(void) getLocationsOrdered: (MSReadQueryBlock) getAll
{
    
    
     MSTable * LocationTable=  [self.client getTable:@"LocationTable"];
    
    NSPredicate * predicategetALL = [NSPredicate predicateWithValue:YES];
    
    //sets the predicate to return an ordered set value based on the UserID
    [predicategetALL mutableOrderedSetValueForKey:@"id"];
    
    MSQuery * queryGetAll = [[MSQuery alloc]initWithTable:LocationTable withPredicate:predicategetALL];
    
    [LocationTable readWithQueryString:[queryGetAll queryStringOrError:nil] completion:getAll ];
    
}
@end
