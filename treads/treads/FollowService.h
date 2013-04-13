//
//  FollowService.h
//  treads
//
//  Created by Zachary Kanoff on 4/13/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TreadsService.h"


@class DataRepository;

@interface FollowService : NSObject <TreadsService>

@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;

- (void) getPeopleIFollow:(int)myID forTarget:(NSObject*)target withAction:(SEL)returnAction;

@end
