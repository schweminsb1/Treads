//
//  CommentEnterCell.m
//  treads
//
//  Created by Sam Schwemin on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "CommentEnterCell.h"
#import "AppColors.h"
#import <QuartzCore/QuartzCore.h>
#import "LocationVC.h"

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
    

    // Configure the view for the selected state
}

-(void) layoutSubviews
{
    [self setBackgroundColor: [AppColors mainBackgroundColor]];
    [super layoutSubviews];
    [super layoutSubviews];
    UIImage * img=[UIImage imageNamed:@"mountains.jpeg"];
    CGRect imageRect= CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.height, self.bounds.size.height);
    _profilePicture =[[UIImageView alloc] initWithFrame: imageRect];
    _profilePicture.image = img;
    
    CGRect textRect= CGRectMake(imageRect.origin.x + imageRect.size.width + 1, self.bounds.origin.y, 550, self.bounds.size.height-1);
    
    CGRect buttonBounds= CGRectMake(textRect.origin.x + textRect.size.width + 1, self.bounds.origin.y, 90, self.bounds.size.height);
    _postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _postButton.frame=buttonBounds;
    
    [_postButton addTarget:self action:@selector(fillButton) forControlEvents: UIControlEventTouchUpInside];
 
    [_postButton setTitle: @"Post" forState: UIControlStateNormal];
    [_postButton setTitle: @"Post" forState: UIControlStateApplication];
    [_postButton setTitle: @"Post" forState: UIControlStateHighlighted];
    [_postButton setTitle: @"Post" forState: UIControlStateReserved];
    [_postButton setTitle: @"Post" forState: UIControlStateSelected];
    [_postButton setTitle: @"Post" forState: UIControlStateDisabled];
    
    
    [_postButton setHidden:NO];
    [_postButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
        [_postButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] forState:UIControlStateApplication];
        [_postButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] forState:UIControlStateHighlighted];
        [_postButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] forState:UIControlStateReserved];
        [_postButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] forState:UIControlStateSelected];
        [_postButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] forState:UIControlStateDisabled];
     
    
    _enterField= [[UITextView alloc] initWithFrame:textRect];
    [_enterField setEditable: YES];
    
    _enterField.layer.borderColor = [[UIColor grayColor] CGColor];
    _enterField.layer.borderWidth = 1;
    
    [self addSubview:_profilePicture];
 
    [self addSubview:_enterField];
    
       [self addSubview:_postButton];
    
    [_profilePicture setNeedsDisplay];
    [_enterField setNeedsDisplay];
    [_postButton setNeedsDisplay];
    
    

}

-(void)fillButton
{
    [_cellOwner performSelector:_buttonCallBack withObject:_enterField.text];
    
}

@end
