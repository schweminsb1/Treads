//
//  DataRepository.h
//  treads
//
//  Created by keavneyrj1 on 3/12/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "TreadsService.h"

@interface DataRepository : NSObject

typedef void (^ CompletionWithSasBlock)(NSURL*);

@property MSClient* client;
@property MSTable * tablesTable;
@property MSTable * tableRowsTable;
@property MSTable * containersTable;
@property MSTable * blobsTable;

@property NSURL * SasURL;
//will be used to make requests to the server via this URL so do NSMutableURLREquest to get information hopefully from the Blob


//retrieval
- (void)retrieveDataItemsMatching:(NSString*)predicateStringOrNil usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;

//creating, updating
- (void)createDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;

- (void)updateDataItem:(NSDictionary*)updateItem usingService:(id<TreadsService>)callingService forRequestingObject:(NSObject*)requestingObject withReturnAction:(SEL)returnAction;

//Locations
- (void)addLocation:(NSDictionary*)newLocation forTarget:(NSObject*) target withAction: (SEL) returnAction;

- (void) getLocationsOrdered: (MSReadQueryBlock) getAll;

-(void) getCommentsFromLocationID: (NSString *) locationID withBlock: (MSReadQueryBlock) getComments;


@end
