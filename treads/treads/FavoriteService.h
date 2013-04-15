//
//  FavoriteService.h
//  treads
//
//  Created by Zachary Kanoff on 4/14/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TreadsService.h"


@class DataRepository;

@interface FavoriteService : NSObject <TreadsService>

@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;

- (void) getMyFavs:(int)myID forTarget:(NSObject*)target withAction:(SEL)returnAction;
- (void) addFav:(int)myID withTripID:(int)tripID fromTarget:(NSObject *) target withReturn:(SEL) returnAction;
- (void) deleteFav:(NSString*)fav fromTarget:(NSObject *) target withReturn:(SEL) returnAction;

+(FavoriteService*) instance ;
@end
