//
//  TreadsSession.m
//  treads
//
//  Created by Sam Schwemin on 3/7/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TreadsSession.h"

@implementation TreadsSession

-(id) initWithAuthenticatedUser: (NSString *)user
{
    if(self= [super init])
    {
        _treadsUser=user;
        
    }
    return self;
}
-(BOOL) Login
{
    
    @try
    {
        __autoreleasing NSError * error;
        NSString * test = [Path subLibraryCachesDirectory:@"User"];
        [ _treadsUser writeToFile:test  atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    @catch (id exception)
    {
        return NO;
    }
    
    
    return YES;
}
-(BOOL) Logout
{
    
    return NO;
}




@end
