//
//  UserService.m
//  treads
//
//  Created by Sam Schwemin on 4/4/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "UserService.h"
//#import "User.h"
#import "DataRepository.h"

@implementation UserService

static UserService* repo;
+(UserService*) instance {
    @synchronized(self) {
        if (!repo)
            repo = [[UserService alloc] initWithRepository:[DataRepository instance]];
        return repo;
    }
}

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
    if (!returnData || returnData.count == 0) {return [NSArray array];}
    NSMutableArray * results = [[NSMutableArray alloc]init];
    for ( int i=0; i< returnData.count; i++)
    {
        User * user         =       [[User alloc] init];
        user.fname          =       returnData[i][@"Fname"];
        user.emailaddress   =       returnData[i][@"emailAddress"];
        user.lname          =       returnData[i][@"Lname"];
        user.User_ID        =       [((NSString*)returnData[i][@"id"]) intValue];
        user.profilePhotoID=      [((NSString*)returnData[i][@"profilePhotoID"]) intValue];
        user.password       =        returnData[i][@"password"];
        user.coverPhotoID   =  [((NSString*)returnData[i][@"coverPhotoID"]) intValue];
        if ([((NSDictionary*)returnData[i]) valueForKey:@"tripCount"]) {
            user.tripCount = [returnData[i][@"tripCount"] intValue];
        }
        [results addObject: user];
    }
    return results;
}

- (void)getUserbyID:(int)UserID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"id = '%d'", UserID] usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (void)getUsersContainingSubstring:(NSString *)substring forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"search = '%@'", substring] usingService:self usingDataTable:@"UserFilteredReader" forRequestingObject:target withReturnAction:returnAction];
}

-(NSArray *)getUserbyID:(int)UserID
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


-(void)updateUser:(User*)user forTarget:(NSObject*) target withAction: (SEL) returnAction {
    
    NSMutableDictionary* userDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                           @"id":@(user.User_ID),
                                           @"emailAddress":[NSString stringWithString: user.emailaddress],
                                           @"Password":[NSString stringWithString: user.password],
                                           @"fName":[NSString stringWithString: user.fname],
                                           @"lName":[NSString stringWithString: user.lname],
                                           @"profilePhotoID":@(user.profilePhotoID),
                                           @"coverPhotoID":@(user.coverPhotoID)
                                           }];

        [userDictionary setObject:@(user.User_ID) forKey:@"id"];
        [self.dataRepository updateDataItem:userDictionary usingService:self forRequestingObject:target withReturnAction:returnAction];
    
   // [self.dataRepository updateDataItem:userDictionary usingService:self forRequestingObject:target withReturnAction:returnAction];
}

@end
