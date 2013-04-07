//
//  CommentEnterCell.m
//  treads
//
//  Created by Sam Schwemin on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "CommentEnterCell.h"

@implementation CommentEnterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    [super layoutSubviews];
    
    CGRect imageRect= CGRectMake(self.bounds.origin.x+5, self.bounds.origin.y+5, 50, self.bounds.size.height-10);
    _profilePicture =[[UIImageView alloc] initWithFrame: imageRect];
    _profilePicture.image = [UIImage imageNamed:@"mountains.jpeg"];
    
    CGRect buttonBounds= CGRectMake(self.bounds.origin.x+ self.bounds.size.width -80, self.bounds.origin.y+10, 40, self.bounds.size.height-20);
    _postButton = [[UIButton alloc] initWithFrame:buttonBounds];
    [_postButton setTitle: @"myTitle" forState: UIControlStateNormal];
    [_postButton setTitle: @"myTitle" forState: UIControlStateApplication];
    [_postButton setTitle: @"myTitle" forState: UIControlStateHighlighted];
    [_postButton setTitle: @"myTitle" forState: UIControlStateReserved];
    [_postButton setTitle: @"myTitle" forState: UIControlStateSelected];
    [_postButton setTitle: @"myTitle" forState: UIControlStateDisabled];
    
    
    CGRect textRect= CGRectMake(imageRect.origin.x + imageRect.size.width + 5, self.bounds.origin.y+5, 200, self.bounds.size.height-10);
    
    _enterField= [[UITextView alloc] initWithFrame:textRect];
    [_enterField setEditable: YES];
    
    [self addSubview:_profilePicture];
    [self addSubview:_postButton];
    [self addSubview:_enterField];
    

}

@end
