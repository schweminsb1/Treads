//
//  FollowService.m
//  treads
//
//  Created by Zachary Kanoff on 4/13/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "FollowService.h"
#import "DataRepository.h"

@implementation FollowService

- (id)initWithRepository:(DataRepository*)repository {
    if ((self = [super init])) {
        self.dataRepository = repository;
        self.dataTableIdentifier = @"IFollowTable";
    }
    return self;
}

- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData {
    return returnData;
}

- (void) getPeopleIFollow:(int)myID forTarget:(NSObject*)target withAction:(SEL)returnAction {
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"MyID = '%i'", myID] usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (void) addFollow:(int)myID withTheirID:(int)theirID fromTarget:(NSObject *) target withReturn:(SEL) returnAction {
    NSMutableDictionary * followDict = [[NSMutableDictionary alloc] init];
    
    [followDict  setValue:[NSNumber numberWithInt:myID]forKey:@"MyID"];
    [followDict  setValue:[NSNumber numberWithInt:theirID] forKey:@"TheirID"];
    [self.dataRepository createDataItem:followDict usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (void) deleteFollow:(NSArray*)follow fromTarget:(NSObject *) target withReturn:(SEL) returnAction {

}

@end
