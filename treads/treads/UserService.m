//
//  UserService.m
//  treads
//
//  Created by Sam Schwemin on 4/4/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "UserService.h"
#import "User.h"
#import "DataRepository.h"

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
        user.User_ID        =       [((NSString*)returnData[i][@"id"]) intValue];
        user.profilePictureID=      [((NSString*)returnData[i][@"profilePhotoID"]) intValue];
        user.password       =        returnData[i][@"password"];
        [results addObject: user];
    }
    return results;

    
}

- (void)getUserbyID:(int)UserID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"id = '%d'", UserID] usingService:self forRequestingObject:target withReturnAction:returnAction];
    
    
}
-(NSArray *)getUserbyID:(int)UserID withReturnItems: (NSArray *)itm
{
    __block NSArray * objects;
    __block BOOL completed=false;
    CompletionWithItems completion= ^(NSArray * items){
        completed=true;
        objects=items;
        
    };
    
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"id = '%d'", UserID] usingService:self withReturnBlock:completion];
    while(!completed)
    {}
    
    
    
    return objects;
    
}

- (void)getUserbyEmail:(NSString *)emailAddress forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"emailAddress = '%@' ", emailAddress] usingService:self forRequestingObject:target withReturnAction:returnAction];
    
    
}

- (void)addUser:(NSDictionary*)newUser forTarget:(NSObject*) target withAction: (SEL) returnAction
{
    
    [_dataRepository createDataItem:newUser usingService:self forRequestingObject:target withReturnAction:returnAction];
}


@end
