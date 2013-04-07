//
//  CommentCell.h
//  treads
//
//  Created by Sam Schwemin on 4/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserService.h"
#import "User.h"
#import "Comment.h"


@interface CommentCell : UITableViewCell

@property User    * userModel;
@property Comment * commentModel;

@property UIImageView * profileImage;
@property UITextView * commentField;
@property UILabel * userName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCommentModel:(Comment *) comment;




@end
