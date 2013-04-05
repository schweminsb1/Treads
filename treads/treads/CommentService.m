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

@implementation CommentService


- (id)initWithRepository:(DataRepository*)repository
{

        if ((self = [super init])) {
            self.dataRepository = repository;
            self.dataTableIdentifier = @"CommentTable";
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
        
        [results addObject: comment];
    }
    return results;
}

- (void)getCommentInLocation:(int)LocationID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"LocationID = '%d'", LocationID] usingService:self forRequestingObject:target withReturnAction:returnAction];

    
}


@end
