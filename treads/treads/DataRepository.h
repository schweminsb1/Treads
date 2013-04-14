//
//  DataRepository.h
//  treads
//
//  Created by keavneyrj1 on 3/12/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//


//http://chrisrisner.com/iOS-and-Mobile-Services-and-Windows-Azure-Storage

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "TreadsService.h"
#import "Location.h"

@interface DataRepository : NSObject

typedef void (^CompletionBlock) ();
typedef void (^CompletionWithIndexBlock) (NSUInteger index);
typedef void (^CompletionWithMessagesBlock) (id messages);
typedef void (^CompletionWithSasBlock) (NSString *sasUrl);
typedef void (^CompletionWithItems)(NSArray * items);
typedef void (^BusyUpdateBlock) (BOOL busy);
typedef void (^CompletionWithItemsandLocation)(NSArray * items, Location* location);
@property MSClient* client;
@property MSTable * tablesTable;
@property MSTable * tableRowsTable;
@property MSTable * containersTable;
@property MSTable * blobsTable;

@property (nonatomic, strong)   NSArray *tables;
@property (nonatomic, strong)   NSArray *tableRows;
@property (nonatomic, strong)   NSArray *containers;
@property (nonatomic, strong)   NSArray *blobs;


@property (nonatomic)           NSInteger busyCount;
@property (nonatomic, copy)     BusyUpdateBlock busyUpdate;


@property NSURL * SasURL;
//will be used to make requests to the server via this URL so do NSMutableURLREquest to get information hopefully from the Blob

+(DataRepository*) instance ;
//retrieval
- (void)retrieveDataItemsMatching:(NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;

- (void)retrieveDataItemsMatching:(NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService  withReturnBlock:(CompletionWithItems)completion;
//creating, updating
- (void)createDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;
- (void)createDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService withReturnBlock:(MSItemBlock)block;

- (void)updateDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;

//Locations
- (void)addLocation:(NSDictionary*)newLocation forTarget:(NSObject*) target withAction: (SEL) returnAction;

- (void) getLocationsOrdered: (MSReadQueryBlock) getAll;

-(void) getCommentsFromLocationID: (NSString *) locationID withBlock: (MSReadQueryBlock) getComments;


//Blob storage helper functions
- (void) handleRequest:(NSURLRequest *)request
                onNext:(MSFilterNextBlock)onNext
            onResponse:(MSFilterResponseBlock)onResponse;

- (void) refreshTablesOnSuccess:(CompletionBlock) completion;
- (void) refreshTableRowsOnSuccess:(NSString *)tableName withCompletion:(CompletionBlock) completion;
- (void) updateTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion;
- (void) insertTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion;
- (void) createTable:(NSString *)tableName withCompletion:(CompletionBlock) completion;
- (void) deleteTable:(NSString *)tableName withCompletion:(CompletionBlock) completion;
- (void) deleteTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion;
- (void) deleteDataItem: (NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;

- (void) refreshContainersOnSuccess:(CompletionBlock) completion;
- (void) createContainer:(NSString *)containerName withPublicSetting:(BOOL)isPublic withCompletion:(CompletionBlock) completion;
- (void) deleteContainer:(NSString *)containerName withCompletion:(CompletionBlock) completion;
- (void) refreshBlobsOnSuccess:(NSString *)containerName withCompletion:(CompletionBlock) completion;
- (void) deleteBlob:(NSString *)blobName fromContainer:(NSString *)containerName withCompletion:(CompletionBlock) completion;
- (void) getSasUrlForNewBlob:(NSString *)blobName forContainer:(NSString *)containerName withCompletion:(CompletionWithSasBlock) completion;




@end
