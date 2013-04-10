//
//  LocationService.m
//  treads
//
//  Created by Anthony DeLeone on 3/13/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//


#import "LocationService.h"
#import "DataRepository.h"
#import "Comment.h"
#import "Location.h"
@implementation LocationService


- (id)initWithRepository:(DataRepository*)repository
{
    if(self = [super init])
    {
        _dataTableIdentifier=@"LocationTable";
        _dataRepository = repository;
    }
    return self;
}
- (void)addLocation:(NSDictionary*)newLocation forTarget:(NSObject*) target withAction: (SEL) returnAction
{
    [_dataRepository addLocation:newLocation forTarget:target withAction:(returnAction)];
}

-(void) getLocationsOrdered: (MSReadQueryBlock) getAll
{
    [_dataRepository getLocationsOrdered:getAll];
}

- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData
{
    NSMutableArray * results = [[NSMutableArray alloc]init];
    for ( int i=0; i< returnData.count; i++)
    {
        Location * location  = [[Location alloc] init];
        location.title  = returnData[i][@"name"];
        location.idField  = returnData[i][@"LocationID"];
        location.description = returnData[i][@"description"];
        location.latitude     = [returnData[i][@"latitude"] floatValue];
        location.longitude     = [returnData[i][@"longitude"] floatValue];
        
        //check to see if this user is saved on disk
        //if he is, then load from disk
        //if he is not, then send a request
        //here is the request part
        
        //save this user to disk
        // _userService getUserbyID:comment.UserID forTarget:self withAction:
        //     NSArray * users;
        //    int idval= [comment.UserID intValue];
        // users=[_userService getUserbyID:idval withReturnItems:users];
        // comment.commentsUser=users[0];
        
        [results addObject: location];
        
    }
    return results;
}

- (void)getLocationByID:(int)LocationID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"LocationID = '%d'", LocationID] usingService:self forRequestingObject:target withReturnAction:returnAction];
    
    
}
- (void)getLocationsforTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"LocationID > %d", -1] usingService:self forRequestingObject:target withReturnAction:returnAction];
    
    
}

@end
