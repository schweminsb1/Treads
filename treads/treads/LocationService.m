//
//  LocationService.m
//  treads
//
//  Created by Anthony DeLeone on 3/13/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "LocationService.h"
#import "DataRepository.h"
@implementation LocationService


- (id)initWithRepository:(DataRepository*)repository
{
    if(self = [super init])
    {
        _dataRepository = repository;
    }
    return self;
}
- (void)addLocation:(NSDictionary*)newLocation forTarget:(NSObject*) target withAction: (SEL) returnAction
{
    [_dataRepository addLocation:newLocation forTarget:target withAction:(returnAction)];
}

-(void) getLocationsOrdered: (MSReadQueryBlock) getAll
{
    [_dataRepository getLocationsOrdered:getAll];
}

@end
