//
//  FollowService.m
//  treads
//
//  Created by Zachary Kanoff on 4/13/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "FollowService.h"
#import "DataRepository.h"
#import "ImageService.h"

#import "User.h"

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
    if (!returnData || returnData.count == 0) {return [NSArray array];}
    NSMutableArray* returnArray = [[NSMutableArray alloc] init];
    for (int i=0; i<returnData.count; i++) {
        NSMutableDictionary* newDictionary = [NSMutableDictionary dictionaryWithDictionary:returnData[i]];
        NSDictionary* followProfile = newDictionary[@"followProfile"];
        User* user = [[User alloc] init];
        user.User_ID = [followProfile[@"id"] intValue];
        user.fname = followProfile[@"Fname"];
        user.lname = followProfile[@"Lname"];
        user.profilePhotoID = [followProfile[@"profilePhotoID"] intValue];
        user.coverPhotoID = [followProfile[@"coverPhotoID"] intValue];
        user.profileImage = [ImageService emptyImage];
        user.coverImage = [ImageService emptyImage];
        user.tripCount = [followProfile[@"tripCount"] intValue];
        newDictionary[@"followProfile"] = user;
        [returnArray addObject:newDictionary];
    }
    return returnArray;
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

- (void) deleteFollow:(NSString*)follow fromTarget:(NSObject *) target withReturn:(SEL) returnAction {
    
    
    [self.dataRepository deleteDataItem:follow usingService:self forRequestingObject:target withReturnAction:returnAction];
    
}

@end
