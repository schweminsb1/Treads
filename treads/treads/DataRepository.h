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

typedef void (^CompletionWithItems)(NSArray * items);
typedef void (^CompletionBlock) ();
typedef void (^CompletionWithIndexBlock) (NSUInteger index);
typedef void (^CompletionWithMessagesBlock) (id messages);
typedef void (^CompletionWithSasBlock) (NSString *sasUrl);
typedef void (^BusyUpdateBlock) (BOOL busy);
typedef void (^CompletionWithItemsandLocation)(NSArray * items, Location* location);

@property MSClient* client;

+ (DataRepository*)instance;

//retrieval
- (void)retrieveDataItemsMatching:(NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;

- (void)retrieveDataItemsMatching:(NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService usingDataTable:(NSString*)nonDefaultTable forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;

- (void)retrieveDataItemsMatching:(NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService  withReturnBlock:(CompletionWithItems)completion;

//creating, updating
- (void)createDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;
- (void)createDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService withReturnBlock:(MSItemBlock)block;

- (void)updateDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;

//deleting
- (void)deleteDataItem: (NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;
- (void)deleteDataItemsWithID:(int)index usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;

//Locations
- (void)addLocation:(NSDictionary*)newLocation forTarget:(NSObject*) target withAction: (SEL) returnAction;

- (void)getLocationsOrdered:(MSReadQueryBlock)getAll;

- (void)getCommentsFromLocationID:(NSString *)locationID withBlock:(MSReadQueryBlock)getComments;

@end
