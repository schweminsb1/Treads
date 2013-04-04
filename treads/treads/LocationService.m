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
@implementation LocationService


- (id)initWithRepository:(DataRepository*)repository
{
    if(self = [super init])
    {
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

-(NSMutableArray *) getCommentsFromLocationID: (NSString*)locationID
{
    
    __block NSMutableArray * results= [[NSMutableArray alloc] init];
    MSReadQueryBlock completionBlock=^(NSArray * items, NSInteger totalCount, NSError * error){
        //items should return a array of CommentDictionaries
        
        //parse items into a nsmutableArray of Comment model objects
        
        for ( int i=0; i< items.count; i++)
        {
            Comment * comment  = [[Comment alloc] init];
            comment.comment    = items[i][@"comment"];
            comment.CommentID  = items[i][@"commentID"];
            comment.LocationID = items[i][@"LocationID"];
            comment.UserID     = items[i][@"userID"];
            
            [results addObject: comment];
        }
      
    };
    
    [_dataRepository getCommentsFromLocationID:locationID withBlock:completionBlock];
    
    
}

@end
