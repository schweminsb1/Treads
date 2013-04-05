//
//  UserService.m
//  treads
//
//  Created by Sam Schwemin on 4/4/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "UserService.h"
#import "User.h"
#include "DataRepository.h"

@implementation UserService

- (id)initWithRepository:(DataRepository*)repository
{
    if ((self = [super init])) {
        self.dataRepository = repository;
        self.dataTableIdentifier = @"UserTable";
    }
    return self;
    
}
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData
{
    NSMutableArray * results = [[NSMutableArray alloc]init];
    for ( int i=0; i< returnData.count; i++)
    {
        User * user         =       [[User alloc] init];
        user.fname          =       returnData[i][@"Fname"];
        user.emailaddress   =       returnData[i][@"emailAddress"];
        user.lname          =       returnData[i][@"Lname"];
        user.User_ID        =       (int)returnData[i][@"userID"];
        user.profilePictureID=      (int)returnData[i][@"profilePhotoID"];
        [results addObject: user];
    }
    return results;

    
}

- (void)getUserbyID:(int)UserID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"UserID = '%d'", UserID] usingService:self forRequestingObject:target withReturnAction:returnAction];
    
    
}

- (void)getUserbyEmail:(NSString *)emailAddress forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"emailAdress = '%@'", emailAddress] usingService:self forRequestingObject:target withReturnAction:returnAction];
    
    
}


@end
