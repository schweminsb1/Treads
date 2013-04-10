//
//  LocationService.h
//  treads
//
//  Created by Anthony DeLeone on 3/13/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TreadsService.h"

@class DataRepository;


@interface LocationService : NSObject<TreadsService>


@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;



- (void)addLocation:(NSDictionary*)newLocation forTarget:(NSObject*) target withAction: (SEL) returnAction;

- (void) getLocationsOrdered: (MSReadQueryBlock) getAll;

- (void)getLocationByID:(int)LocationID forTarget:(NSObject *)target withAction:(SEL)returnAction;

- (void)getLocationsforTarget:(NSObject *)target withAction:(SEL)returnAction;

@end
