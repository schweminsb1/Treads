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


static FollowService* repo;
+(FollowService*) instance {
    @synchronized(self) {
        if (!repo)
            repo = [[FollowService alloc] initWithRepository:[DataRepository instance]];
        return repo;
    }
}
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

@end
