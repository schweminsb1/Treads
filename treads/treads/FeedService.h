//
//  FeedService.h
//  treads
//
//  Created by keavneyrj1 on 4/14/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TreadsService.h"

@interface FeedService : NSObject<TreadsService>

//protocol
@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;

//services
- (void)getFeedItemsForUserID:(int)userID forTarget:(NSObject*)target withAction:(SEL)returnAction;;

+ (FeedService*)instance;

@end
