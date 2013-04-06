//
//  CommentBox.m
//  treads
//
//  Created by Sam Schwemin on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "CommentBox.h"
#import "CommentCell.h"

@implementation CommentBox

- (id)initWithFrame:(CGRect)frame withModel: (Location *) model withCommentService: (CommentService *) service
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _commentService=service;
        _model=model;
        
        CGRect tableRect=  CGRectMake(frame.origin.x,frame.origin.y + 100 , frame.size.width, frame.size.height-100);
        _commentTable = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        _commentTable.dataSource= self;
        
    [_commentService getCommentInLocation:[model.idField intValue] forTarget:self withAction:@selector(getModels:)];
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)getModels: (NSArray*) items
{
    _commentModels=(NSMutableArray *)items;
    //get users, and fill comentModel
    [_commentTable reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentModels.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    CommentCell * ccell= [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if (!ccell) {
        ccell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL" withCommentModel:((Comment *)_commentModels[indexPath.row])];
        
        //[cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        //[cell setAutoresizesSubviews:YES];
    }
    
    return ccell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}



@end
