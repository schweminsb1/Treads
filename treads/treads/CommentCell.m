//
//  CommentCell.m
//  treads
//
//  Created by Sam Schwemin on 4/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "CommentCell.h"





@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCommentModel:(Comment *) comment withUserService:(UserService*) userService
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userModel = [[User alloc]init];
        _userModel.fname=@"";
        _userModel.lname=@"";
        _userModel.User_ID=-1;
        // Initialization code
        _commentModel=comment;
        _userService=userService;
        self.userInteractionEnabled= NO;
        [_userService getUserbyID:[_commentModel.UserID intValue] forTarget:self withAction:@selector(recieveUserModel:)];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews
{
    
    [super layoutSubviews];
    
    CGRect imageRect= CGRectMake(self.bounds.origin.x+5, self.bounds.origin.y+5, self.bounds.size.height-20, self.bounds.size.height-20);
    
    _profileImage =[[UIImageView alloc] initWithFrame: imageRect];
    _profileImage.image = [UIImage imageNamed:@"mountains.jpeg"];
    
    _commentField = [[UITextView alloc] initWithFrame:CGRectMake(imageRect.origin.x+ imageRect.size.width + 1, self.bounds.origin.y, 550, self.bounds.size.height-1)];
    _commentField.text = [NSString stringWithFormat:@"%@ %@ says: \n \n \t %@",_userModel.fname,_userModel.lname,  _commentModel.comment ];
    
    
    [self addSubview:_profileImage];
    [self addSubview:_commentField];
    
}
-(void)recieveUserModel:(NSArray*) items
{
    _userModel=items[0];
    
}

@end
