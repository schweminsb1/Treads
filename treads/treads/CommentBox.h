//
//  CommentBox.h
//  treads
//
//  Created by Sam Schwemin on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "CommentService.h"
#import "Location.h"

@interface CommentBox : UIView  <UITableViewDataSource>

@property Location * model;
@property CommentService * commentService;

@property UITableView * commentTable;
@property CommentEnterBox * commentEnterCell;

@property NSArray * commentModels;

- (id)initWithFrame:(CGRect)frame withModel: (Location *) model withCommentService: (CommentService *) service;
@end
