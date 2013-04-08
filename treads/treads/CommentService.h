//
//  CommentService.h
//  treads
//
//  Created by Sam Schwemin on 4/4/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreadsService.h"
#import "UserService.h"


@class DataRepository;
@class Comment;
@interface CommentService : NSObject<TreadsService>


//protocol
@property UserService * userService;
@property (strong) DataRepository* dataRepository;
@property (copy) NSString* dataTableIdentifier;

- (id)initWithRepository:(DataRepository*)repository;
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData;


- (void)getCommentInLocation:(int)LocationID forTarget:(NSObject *)target withAction:(SEL)returnAction;
-(void)insertNewComment: (Comment*)commentModel fromTarget:(NSObject *) target withReturn:(SEL) returnAction;


@end
