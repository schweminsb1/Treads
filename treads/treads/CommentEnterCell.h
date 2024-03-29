//
//  CommentEnterCell.h
//  treads
//
//  Created by Sam Schwemin on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataRepository.h"
@class LocationVC;
@interface CommentEnterCell : UITableViewCell

@property UIImageView * profilePicture;
@property UIButton * postButton;
@property UITextView * enterField;

@property LocationVC * cellOwner;
@property SEL buttonCallBack;
@property (copy,nonatomic)CompletionWithItems block;
@property UIImage * proPic;

@end
