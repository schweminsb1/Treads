//
//  Comment.h
//  treads
//
//  Created by Sam Schwemin on 4/4/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Comment : NSObject

@property NSString * comment;
@property NSString * CommentID;
@property NSString * LocationID;
@property NSString * UserID;


//filled with UserService
@property User * commentsUser;

@end
