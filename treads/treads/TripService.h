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

//@class ImageService;

@interface TripService : NSObject <TreadsService>

//protocol
@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;

//services
- (void)getAllTripsForTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)getTripWithID:(int)tripID forTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)getTripsWithUserID:(int)userID forTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)getDraftsWithUserID:(int)userID forTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)getFeedItemsForUserID:(int)userID forTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void)getFavoriteItemsForUserID:(int)userID forTarget:(NSObject*)target withAction:(SEL)returnAction;

- (void)updateTrip:(Trip*)trip forTarget:(NSObject*)target withAction:(SEL)returnAction;

//images
//@property (strong) ImageService* imageService;

- (void)getHeaderImageForTrip:(Trip*)trip forTarget:(NSObject*)target withCompleteAction:(SEL)completeAction;

- (void)getImagesForTrip:(Trip*)trip forTarget:(NSObject*)target withRefreshAction:(SEL)refreshAction withCompleteAction:(SEL)completeAction;
- (void)updateNewImagesForTrip:(Trip*)trip forTarget:(NSObject*)target withCompleteAction:(SEL)completeAction;

+(TripService*) instance ;
@end
