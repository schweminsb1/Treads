//
//  TreadsSession.h
//  treads
//
//  Created by Sam Schwemin on 3/7/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreadsSession : NSObject


@property NSString * treadsUser;
@property int treadsUserID;
@property NSString * fName;
@property NString * lName;

-(id) initWithAuthenticatedUser: (NSString *)user;
-(BOOL) Login;
-(BOOL) Logout;
-(NSString * ) valueOfFile;

+(TreadsSession*) instance ;
+(BOOL) Login;
+(BOOL) Logout;
+(NSString * ) valueOfFile;


@end
