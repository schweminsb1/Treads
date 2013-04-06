//
//  LocationService.h
//  treads
//
//  Created by Anthony DeLeone on 3/13/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DataRepository;

//typedef void (^MSReadQueryBlock)(NSArray *items,
//NSInteger totalCount,
//NSError *error);

@interface LocationService : NSObject

@property DataRepository* dataRepository;

- (id)initWithRepository:(DataRepository*)repository;

- (void)addLocation:(NSDictionary*)newLocation forTarget:(NSObject*) target withAction: (SEL) returnAction;

- (void) getLocationsOrdered: (MSReadQueryBlock) getAll;



@end
