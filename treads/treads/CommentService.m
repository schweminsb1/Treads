//
//  CommentService.m
//  treads
//
//  Created by Sam Schwemin on 4/4/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "CommentService.h"
#import "DataRepository.h"
#import "Comment.h"
#import "User.h"
#import "UserService.h"

@implementation CommentService


static CommentService* repo;
+(CommentService*) instance {
    @synchronized(self) {
        if (!repo)
            repo = [[CommentService alloc] initWithRepository:[DataRepository instance]];
        return repo;
    }
}

- (id)initWithRepository:(DataRepository*)repository
{

        if ((self = [super init])) {
            self.dataRepository = repository;
            self.dataTableIdentifier = @"CommentTable";
            _userService = [[UserService alloc] initWithRepository:_dataRepository];
            
        }
        return self;

}
- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData
{
    NSMutableArray * results = [[NSMutableArray alloc]init];
    for ( int i=0; i< returnData.count; i++)
    {
        Comment * comment  = [[Comment alloc] init];
        comment.comment    = returnData[i][@"comment"];
        comment.CommentID  = returnData[i][@"id"];
        comment.LocationID = returnData[i][@"LocationID"];
        comment.UserID     = returnData[i][@"userID"];
        
        //check to see if this user is saved on disk
        //if he is, then load from disk
        //if he is not, then send a request
        //here is the request part
        
        //save this user to disk
       // _userService getUserbyID:comment.UserID forTarget:self withAction:<#(SEL)#>
   //     NSArray * users;
    //    int idval= [comment.UserID intValue];
       // users=[_userService getUserbyID:idval withReturnItems:users];
       // comment.commentsUser=users[0];
        
        [results addObject: comment];
        
    }
    return results;
}

- (void)getCommentInLocation:(int)LocationID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"LocationID = '%d'", LocationID] usingService:self forRequestingObject:target withReturnAction:returnAction];

    
}

-(void)insertNewComment: (Comment*)commentModel fromTarget:(NSObject *) target withReturn:(SEL) returnAction
{
    NSMutableDictionary * commentDict = [[NSMutableDictionary alloc] init];

    [commentDict  setValue:[NSNumber numberWithInt:[commentModel.UserID intValue]]forKey:@"userID"];
     [commentDict  setValue:[NSNumber numberWithInt:[commentModel.LocationID intValue]] forKey:@"LocationID"];
     [commentDict  setValue:commentModel.comment forKey:@"comment"];
    [_dataRepository createDataItem:commentDict usingService:self forRequestingObject:target withReturnAction:returnAction];
 
    
    
}


@end
