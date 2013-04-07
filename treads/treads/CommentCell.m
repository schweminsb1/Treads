//
//  CommentCell.m
//  treads
//
//  Created by Sam Schwemin on 4/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "CommentCell.h"





@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCommentModel:(Comment *) comment
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _commentModel=comment;
        self.userInteractionEnabled= NO;
        
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
    _commentField.text = [NSString stringWithFormat:@"Sam Schwemin says: \n \n \t %@",  _commentModel.comment ];
    
    
    [self addSubview:_profileImage];
    [self addSubview:_commentField];
    
}

@end
