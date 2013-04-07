//
//  TreadsSession.m
//  treads
//
//  Created by Sam Schwemin on 3/7/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TreadsSession.h"

@implementation TreadsSession

static TreadsSession* repo;
+(TreadsSession*) instance {
    @synchronized(self) {
        if (!repo)
            repo = [[TreadsSession alloc] init];
        return repo;
    }
}
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
     __autoreleasing NSError * error;
    @try
    {
       
        NSString * test = [Path subLibraryCachesDirectory:@"User"];
        [ _treadsUser writeToFile:test  atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    @catch (id exception)
    {
        NSLog(@"%@",error );
        return NO;
    }
    
    
    return YES;
}
-(BOOL) Logout
{
     __autoreleasing NSError * error;
    @try
    {
        
        NSString * test = [Path subLibraryCachesDirectory:@"User"];
        [ @"" writeToFile:test  atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    @catch (id exception)
    {
        NSLog(@"%@",error );
        return NO;
    }
    
    return YES;
}
-(NSString * ) valueOfFile
{
     NSString * filePath = [Path subLibraryCachesDirectory:@"User"];
     NSString * fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    
    return fileString;
}




+(BOOL) Login
{
    __autoreleasing NSError * error;
    @try
    {
        
        NSString * test = [Path subLibraryCachesDirectory:@"User"];
        [ repo.treadsUser writeToFile:test  atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    @catch (id exception)
    {
        NSLog(@"%@",error );
        return NO;
    }
    
    
    return YES;
}
+(BOOL) Logout
{
    __autoreleasing NSError * error;
    @try
    {
        
        NSString * test = [Path subLibraryCachesDirectory:@"User"];
        [ @"" writeToFile:test  atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    @catch (id exception)
    {
        NSLog(@"%@",error );
        return NO;
    }
    
    return YES;
}
+(NSString * ) valueOfFile
{
    NSString * filePath = [Path subLibraryCachesDirectory:@"User"];
    NSString * fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    
    return fileString;
}






@end
