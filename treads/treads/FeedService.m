//
//  FeedService.m
//  treads
//
//  Created by keavneyrj1 on 4/14/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "FeedService.h"

#import "DataRepository.h"
#import "TripService.h"

@implementation FeedService

static FeedService* repo;
+ (FeedService*) instance {
    @synchronized(self) {
        if (!repo)
            repo = [[FeedService alloc] initWithRepository:[DataRepository instance]];
        return repo;
    }
}

- (id)initWithRepository:(DataRepository*)repository {
    if ((self = [super init])) {
        self.dataRepository = repository;
        self.dataTableIdentifier = @"FeedTable";
    }
    return self;
}

- (void)getFeedItemsForUserID:(int)userID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"id = '%d'", userID] usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (NSArray*)convertReturnDataToServiceModel:(NSArray *)returnData
{
    NSArray* array = returnData;
    int i = 0;
    i++;
    
    return array;
}

@end
