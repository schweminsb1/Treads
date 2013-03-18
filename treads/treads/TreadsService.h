//
//  TreadsService.h
//  treads
//
//  Created by keavneyrj1 on 3/17/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataRepository;

@protocol TreadsService <NSObject>

@required

@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;

@end
