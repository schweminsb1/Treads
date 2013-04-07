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
        
        self.tablesTable = [_client getTable:@"Tables"];
        self.tableRowsTable = [_client getTable:@"TableRows"];
        
        self.containersTable = [_client getTable:@"BlobContainers"];
        self.blobsTable = [_client getTable:@"BlobBlobs"];
        
        self.tables = [[NSMutableArray alloc] init];
        
        self.busyCount = 0;
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

- (void)retrieveDataItemsMatching:(NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService  withReturnBlock:(CompletionWithItems)completion
{
    MSTable* queryTable = [self.client getTable:callingService.dataTableIdentifier];
    MSQuery* query = [[MSQuery alloc] initWithTable:queryTable];
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
            
            [self logErrorIfNotNil:error];
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

-(void) getCommentsFromLocationID: (NSString *) locationID withBlock: (MSReadQueryBlock) getComments
{

  //__autoreleasing  NSError * error= [[NSError alloc]init];
    
    MSTable * commentsTable= [self.client getTable:@"CommentTable"];
    long  inte= [locationID intValue];
    NSPredicate * predicate = [NSPredicate predicateWithValue:YES];   /*[NSPredicate predicateWithFormat:@"id == %@", [NSNumber numberWithInt:  inte]  ];*/
    MSQuery * query= [[MSQuery alloc]initWithTable:commentsTable withPredicate:predicate];
    
    [commentsTable readWithQueryString:[query queryStringOrError:nil] completion:getComments];
  
    
    
    
}


- (void) busy:(BOOL) busy
{
    // assumes always executes on UI thread
    if (busy) {
        if (self.busyCount == 0 && self.busyUpdate != nil) {
            self.busyUpdate(YES);
        }
        self.busyCount ++;
    }
    else
    {
        if (self.busyCount == 1 && self.busyUpdate != nil) {
            self.busyUpdate(FALSE);
        }
        self.busyCount--;
    }
}

- (void) logErrorIfNotNil:(NSError *) error
{
    if (error) {
        NSLog(@"ERROR %@", error);
    }
}
////blob storage functions

- (void) refreshTablesOnSuccess:(CompletionBlock) completion{
    [self.tablesTable readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        self.tables = [results mutableCopy];
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) refreshTableRowsOnSuccess:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    
    
    NSString *queryString = [NSString stringWithFormat:@"table=%@", tableName];
    
    [self.tableRowsTable readWithQueryString:queryString completion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        self.tableRows = [results mutableCopy];
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) updateTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    NSLog(@"Update Table Row %@", item);
    
    NSDictionary *params = @{ @"table" : tableName };
    
    [self.tableRowsTable update:item parameters:params completion:^(NSDictionary *result, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", result);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) insertTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    NSLog(@"Insert Table Row %@", item);
    
    NSDictionary *params = @{ @"table" : tableName };
    
    [self.tableRowsTable insert:item parameters:params completion:^(NSDictionary *result, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", result);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) createTable:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    NSDictionary *item = @{ @"tableName" : tableName };
    
    [self.tablesTable insert:item completion:^(NSDictionary *result, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", result);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) deleteTable:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    NSDictionary *idItem = @{ @"id" :@0 };
    NSDictionary *params = @{ @"tableName" : tableName };
    
    [self.tablesTable delete:idItem parameters:params completion:^(NSNumber *itemId, NSError *error) {
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", itemId);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) deleteTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    NSLog(@"Delete Table Row %@", item);
    
    //Have to send over all three as params since Mobile Services
    //will strip everything but the ID from the item dictionary
    NSDictionary *params = @{ @"tableName" : tableName ,
                              @"partitionKey" : [item objectForKey:@"PartitionKey"] ,
                              @"rowKey" : [item objectForKey:@"RowKey"]};
    
    [self.tableRowsTable delete:item parameters:params completion:^(NSNumber *itemId, NSError *error) {
        
        
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", itemId);
        
        // Let the caller know that we finished
        completion();
    }];
}





#pragma mark * MSFilter methods


- (void) handleRequest:(NSURLRequest *)request
                onNext:(MSFilterNextBlock)onNext
            onResponse:(MSFilterResponseBlock)onResponse
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
        [self busy:NO];
        onResponse(response, data, error);
    };
    
    // Increment the busy counter before sending the request
    [self busy:YES];
    onNext(request, wrappedResponse);
}




#pragma blobs

- (void) refreshContainersOnSuccess:(CompletionBlock) completion{
    [self.containersTable readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        self.containers = [results mutableCopy];
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) createContainer:(NSString *)containerName withPublicSetting:(BOOL)isPublic withCompletion:(CompletionBlock) completion {
    NSDictionary *item = @{ @"containerName" : containerName };
    
    NSDictionary *params = @{ @"isPublic" : [NSNumber numberWithBool:isPublic] };
    
    [self.containersTable insert:item parameters:params completion:^(NSDictionary *result, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", result);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) deleteContainer:(NSString *)containerName withCompletion:(CompletionBlock) completion {
    NSDictionary *idItem = @{ @"id" :@0 };
    NSDictionary *params = @{ @"containerName" : containerName };
    
    [self.containersTable delete:idItem parameters:params completion:^(NSNumber *itemId, NSError *error) {
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", itemId);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) refreshBlobsOnSuccess:(NSString *)containerName withCompletion:(CompletionBlock) completion {
    
    
    NSString *queryString = [NSString stringWithFormat:@"container=%@", containerName];
    
    [self.blobsTable readWithQueryString:queryString completion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        self.blobs = [results mutableCopy];
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) deleteBlob:(NSString *)blobName fromContainer:(NSString *)containerName withCompletion:(CompletionBlock) completion {
    NSDictionary *idItem = @{ @"id" :@0 };
    NSDictionary *params = @{ @"containerName" : containerName, @"blobName" : blobName };
    
    [self.blobsTable delete:idItem parameters:params completion:^(NSNumber *itemId, NSError *error) {
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", itemId);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) getSasUrlForNewBlob:(NSString *)blobName forContainer:(NSString *)containerName withCompletion:(CompletionWithSasBlock) completion {
    NSDictionary *item = @{  };
    NSDictionary *params = @{ @"containerName" : containerName, @"blobName" : blobName };
    
    [self.blobsTable insert:item parameters:params completion:^(NSDictionary *item, NSError *error) {
        NSLog(@"Item: %@", item);
        
        completion([item objectForKey:@"sasUrl"]);
    }];
}

@end
