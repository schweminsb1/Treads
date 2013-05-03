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

static DataRepository* repo;
+(DataRepository*) instance {
    @synchronized(self)
    {
        if (!repo)
            repo = [[DataRepository alloc]init];
            return repo;
    }
}

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
    query.fetchLimit = 250;
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
        else {
//            NSLog([error localizedDescription]);
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:[callingService convertReturnDataToServiceModel:@[]]];
            #pragma clang diagnostic pop
        }
    };
    
    __autoreleasing NSError* error = [[NSError alloc] init];
    [queryTable readWithQueryString:[query queryStringOrError:&error] completion:queryCompletionBlock];
}

- (void)retrieveDataItemsMatching:(NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService usingDataTable:(NSString*)nonDefaultTable forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction
{
    MSTable* queryTable = [self.client getTable:nonDefaultTable];
    MSQuery* query = [[MSQuery alloc] initWithTable:queryTable];
    query.fetchLimit = 250;
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
        else {
            //NSLog([error localizedDescription]);
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:[callingService convertReturnDataToServiceModel:@[]]];
            #pragma clang diagnostic pop
        }
    };
    
    __autoreleasing NSError* error = [[NSError alloc] init];
    
    [queryTable readWithQueryString:[query queryStringOrError:&error] completion:queryCompletionBlock];
}

- (void)retrieveDataItemsMatching:(NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService  withReturnBlock:(CompletionWithItems)completion
{
    MSTable* queryTable = [self.client getTable:callingService.dataTableIdentifier];
    MSQuery* query = [[MSQuery alloc] initWithTable:queryTable];
    query.fetchLimit = 250;
    if (predicateStringOrNil != nil) {
        [query setPredicate:[NSPredicate predicateWithFormat:predicateStringOrNil]];
    }
     __block  NSError* error = [[NSError alloc] init];
    MSReadQueryBlock queryCompletionBlock = ^(NSArray* items, NSInteger totalCount, NSError *error) {
        if (error == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            completion(   [callingService convertReturnDataToServiceModel:items]);
#pragma clang diagnostic pop
        }
        else
        {
            
//            [self logErrorIfNotNil:error];
        }
    };
    
    
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
//            NSLog([error localizedDescription]);
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:[NSNull null] withObject:[NSNumber numberWithBool:NO]];
            #pragma clang diagnostic pop
        }
    };
    //NSLog(tripDictionary.description);
    [userTable insert:updateItem completion:updateBlock];
}

- (void)createDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService withReturnBlock:(MSItemBlock)block
{
    MSTable* userTable = [self.client getTable:callingService.dataTableIdentifier];
    MSItemBlock updateBlock=^(NSDictionary* item, NSError* error) {
        if (error == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            block(item,error);
#pragma clang diagnostic pop
        }
        else {
//            NSLog([error localizedDescription]);
//            NSLog([error localizedFailureReason]);
//            NSLog([error description]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            block(item,error);
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
//            NSLog([error localizedDescription]);
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:[NSNull null] withObject:[NSNumber numberWithBool:NO]];
            #pragma clang diagnostic pop
        }
    };
    [userTable update:updateItem completion:updateBlock];
}

- (void)deleteDataItemsWithID:(int)index usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction
{
    MSTable* queryTable = [self.client getTable:callingService.dataTableIdentifier];
    
    MSDeleteBlock deleteBlock = ^(NSNumber* itemID, NSError* error) {
        if (error == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:itemID];
#pragma clang diagnostic pop
        }
        else {
            //            NSLog([error localizedDescription]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction withObject:itemID];
#pragma clang diagnostic pop
        }
    };
    
    [queryTable deleteWithId:@(index) completion:deleteBlock];
}


- (void) deleteDataItem: (NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction
{
    MSTable* queryTable = [self.client getTable:callingService.dataTableIdentifier];
    MSQuery* query = [[MSQuery alloc] initWithTable:queryTable];
    if (predicateStringOrNil != nil) {
        [query setPredicate:[NSPredicate predicateWithFormat:predicateStringOrNil]];
    }
    
    MSReadQueryBlock queryCompletionBlock = ^(NSArray* items, NSInteger totalCount, NSError *error) {
        CompletionBlock completion = ^(NSNumber * itemId, NSError* error) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [requestingObject performSelector:returnAction];
#pragma clang diagnostic pop
        };
//        NSLog(error.localizedDescription);
        if (error == nil) {
//            id y = items[0][@"id"];
            //  NSLog(y);
            [queryTable deleteWithId:items[0][@"id"] completion:completion];
            //[queryTable delete:y];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            //   [requestingObject performSelector:returnAction withObject:[callingService convertReturnDataToServiceModel:items]];
            
#pragma clang diagnostic pop
        }
    };
    
    __autoreleasing NSError* error = [[NSError alloc] init];
    [queryTable readWithQueryString:[query queryStringOrError:&error] completion:queryCompletionBlock];
}

- (void)addLocation:(NSDictionary*)newLocation forTarget:(NSObject*) target withAction: (SEL) returnAction
{
    
     MSTable * LocationTable=  [self.client getTable:@"LocationTable"];
    MSItemBlock itemBlock=^(NSDictionary *item, NSError *error)
    {
        if(error)
        {
        //    NSLog([error localizedDescription]);
            
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
    queryGetAll.fetchLimit = 250;
    
    [LocationTable readWithQueryString:[queryGetAll queryStringOrError:nil] completion:getAll ];
    
}

-(void) getCommentsFromLocationID: (NSString *) locationID withBlock: (MSReadQueryBlock) getComments
{

  //__autoreleasing  NSError * error= [[NSError alloc]init];
    
    MSTable * commentsTable= [self.client getTable:@"CommentTable"];
 //   long  inte= [locationID intValue];
    NSPredicate * predicate = [NSPredicate predicateWithValue:YES];   /*[NSPredicate predicateWithFormat:@"id == %@", [NSNumber numberWithInt:  inte]  ];*/
    MSQuery * query= [[MSQuery alloc]initWithTable:commentsTable withPredicate:predicate];
    query.fetchLimit = 250;
    
    [commentsTable readWithQueryString:[query queryStringOrError:nil] completion:getComments];
  
    
    
    
}


//- (void) busy:(BOOL) busy
//{
//    // assumes always executes on UI thread
//    if (busy) {
//        if (self.busyCount == 0 && self.busyUpdate != nil) {
//            self.busyUpdate(YES);
//        }
//        self.busyCount ++;
//    }
//    else
//    {
//        if (self.busyCount == 1 && self.busyUpdate != nil) {
//            self.busyUpdate(FALSE);
//        }
//        self.busyCount--;
//    }
//}
//
//- (void) logErrorIfNotNil:(NSError *) error
//{
//    if (error) {
//        NSLog(@"ERROR %@", error);
//    }
//}

@end
