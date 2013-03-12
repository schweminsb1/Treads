//
//  DataRepository.m
//  treads
//
//  Created by keavneyrj1 on 3/12/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "DataRepository.h"

@implementation DataRepository

- (void)getTripsMeetingCondition: (NSString*) predicateBody forTarget:(NSObject*)newTarget withAction:(SEL) targetSelector{
    
    MSTable * MyTripsTable=  [   _client getTable:@"MyTripsTable"];
    
    MSReadQueryBlock queryBlock=^(NSArray *items, NSInteger totalCount, NSError *error) {
        
        [newTarget performSelector:targetSelector withObject:items];
        
    };
    
    __autoreleasing NSError * error= [[NSError alloc]init];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:predicateBody];
    
    MSQuery * query= [[MSQuery alloc]initWithTable:MyTripsTable withPredicate:predicate];
    [MyTripsTable readWithQueryString:[query queryStringOrError:&error] completion:queryBlock];

}

@end
