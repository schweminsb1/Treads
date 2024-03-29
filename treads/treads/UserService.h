//
//  UserService.h
//  treads
//
//  Created by Sam Schwemin on 4/4/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreadsService.h"
#import "User.h"

@class DataRepository;


@interface UserService : NSObject<TreadsService>

@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;

- (void)getUserbyID:(int)UserID forTarget:(NSObject *)target withAction:(SEL)returnAction;
- (void)getUserbyEmail:(NSString *)emailAddress forTarget:(NSObject *)target withAction:(SEL)returnAction;
- (void)getUsersContainingSubstring:(NSString *)substring forTarget:(NSObject *)target withAction:(SEL)returnAction;

-(NSArray *)getUserbyID:(int)UserID;

- (void)addUser:(NSDictionary*)newUser forTarget:(NSObject*) target withAction: (SEL) returnAction;

-(void)updateUser:(User*)user forTarget:(NSObject*) target withAction: (SEL) returnAction;

+(UserService*) instance ;
@end
