//
//  DataRepository.m
//  treads
//
//  Created by keavneyrj1 on 3/12/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "DataRepository.h"
#import "Trip.h"

@implementation DataRepository

- (id)init
{
    if ((self = [super init])) {
        self.client = [MSClient clientWithApplicationURLString:@"https://treads.azure-mobile.net/" withApplicationKey:@"uxbEolJjpIKEpNJSnsNEuGehMowvxj53"];
    }
    return self;
}

- (void)getTripsMeetingCondition:(NSString*)predicateBody forTarget:(NSObject*)newTarget withAction:(SEL)targetSelector
{
    MSTable* MyTripsTable=  [self.client getTable:@"MyTripsTable"];
    MSReadQueryBlock queryBlock=^(NSArray* items, NSInteger totalCount, NSError *error) {
        if (error == nil) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"        
            [newTarget performSelector:targetSelector withObject:[self convertDataToTripModel:items]];
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
            trip.name = [sourceTrip objectForKey:@"name"];
            trip.myID = [[sourceTrip objectForKey:@"myID"] integerValue];
            trip.tripID = [[sourceTrip objectForKey:@"tripID"] integerValue];
            trip.description = [sourceTrip objectForKey:@"description"];
            [returnData addObject:trip];
        }
        @catch (NSException* exception) {
            trip.name = @"ERROR";
            [returnData addObject:trip];
        }
    }
    return [NSArray arrayWithArray:returnData];
}

@end
