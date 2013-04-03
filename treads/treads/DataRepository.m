//
//  DataRepository.m
//  treads
//
//  Created by keavneyrj1 on 3/12/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "DataRepository.h"
#import "Trip.h"

@implementation DataRepository

- (id)init
{
    if ((self = [super init])) {
        self.client = [MSClient clientWithApplicationURLString:@"https://treads.azure-mobile.net/" withApplicationKey:@"uxbEolJjpIKEpNJSnsNEuGehMowvxj53"];
    }
    return self;
}

//retrieval

- (void)retrieveDataItemsMatching:(NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction
{
    MSTable* queryTable = [self.client getTable:callingService.dataTableIdentifier];
    MSQuery* query = [[MSQuery alloc] initWithTable:queryTable];
    if (predicateStringOrNil != nil) {
        [query setPredicate:[NSPredicate predicateWithFormat:predicateStringOrNil]];
    }
    
    MSReadQueryBlock queryCompletionBlock = ^(NSArray* items, NSInteger totalCount, NSError *error) {
        if (error == nil) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:[callingService convertReturnDataToServiceModel:items]];
            #pragma clang diagnostic pop
        }
    };
    
    __autoreleasing NSError* error = [[NSError alloc] init];
    
    [queryTable readWithQueryString:[query queryStringOrError:&error] completion:queryCompletionBlock];
}

//updating

- (void)createDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction
{
    MSTable* userTable = [self.client getTable:callingService.dataTableIdentifier];
    MSItemBlock updateBlock=^(NSDictionary* item, NSError* error) {
        if (error == nil) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:[item objectForKey:@"id"] withObject:[NSNumber numberWithBool:YES]];
            #pragma clang diagnostic pop
        }
        else {
            //NSLog([error localizedDescription]);
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:[NSNull null] withObject:[NSNumber numberWithBool:NO]];
            #pragma clang diagnostic pop
        }
    };
    //NSLog(tripDictionary.description);
    [userTable insert:updateItem completion:updateBlock];
}

- (void)updateDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction
{
    MSTable* userTable = [self.client getTable:callingService.dataTableIdentifier];
    MSItemBlock updateBlock=^(NSDictionary* item, NSError* error) {
        if (error == nil) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:[item objectForKey:@"id"] withObject:[NSNumber numberWithBool:YES]];
            #pragma clang diagnostic pop
        }
        else {
            //NSLog([error localizedDescription]);
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:[NSNull null] withObject:[NSNumber numberWithBool:NO]];
            #pragma clang diagnostic pop
        }
    };
    [userTable update:updateItem completion:updateBlock];
}






- (void)addLocation:(NSDictionary*)newLocation forTarget:(NSObject*) target withAction: (SEL) returnAction
{
     MSTable * LocationTable=  [self.client getTable:@"LocationTable"];
    MSItemBlock itemBlock=^(NSDictionary *item, NSError *error)
    {
        if(error)
        {
            NSLog([error localizedDescription]);
            
        }
        else
        {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:returnAction];
            #pragma clang diagnostic pop
            // root view controller is the tabBar
            //_appDelegate.window.rootViewController= _appDelegate.tabBarController;
            
        }
    };
    [LocationTable insert:newLocation completion:itemBlock];
        
    
}

-(void) getLocationsOrdered: (MSReadQueryBlock) getAll
{
    
     MSTable * LocationTable=  [self.client getTable:@"LocationTable"];
    
    NSPredicate * predicategetALL = [NSPredicate predicateWithValue:YES];
    
    //sets the predicate to return an ordered set value based on the UserID
    [predicategetALL mutableOrderedSetValueForKey:@"id"];
    
    MSQuery * queryGetAll = [[MSQuery alloc]initWithTable:LocationTable withPredicate:predicategetALL];
    
    [LocationTable readWithQueryString:[queryGetAll queryStringOrError:nil] completion:getAll ];
    
}
@end
