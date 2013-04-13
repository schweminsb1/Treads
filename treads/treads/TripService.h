//
//  TripService.h
//  treads
//
//  Created by keavneyrj1 on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreadsService.h"

@class DataRepository;
@class Trip;

@class ImageService;

@interface TripService : NSObject <TreadsService>

//protocol
@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;

//services
- (void)getAllTripsForTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)getTripWithID:(int)tripID forTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)updateTrip:(Trip*)trip forTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)getTripsWithUserID:(int)userID forTarget:(NSObject*)target withAction:(SEL)returnAction;

//images
@property (strong) ImageService* imageService;

@end
