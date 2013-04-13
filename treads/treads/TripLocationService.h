//
//  TripLocationService.h
//  treads
//
//  Created by Zachary Kanoff on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TreadsService.h"
#import "DataRepository.h"
@class DataRepository;
@class TripLocation;

@interface TripLocationService : NSObject <TreadsService>

//protocol
@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;

//services
- (void)getAllTripLocationsForTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)getTripLocationWithID:(int)tripLocationID forTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)updateTripLocation:(TripLocation*)tripLocation forTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)getTripLocationWithLocation:(Location*)location withCompletion:(CompletionWithItemsandLocation)block;

@end
