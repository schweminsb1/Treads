//
//  CommentCell.h
//  treads
//
//  Created by Sam Schwemin on 4/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"
#import "Comment.h"

@class UserService;
@class LocationService;
@class ImageService;
@class CommentService;
@class TripService;
@class FollowService;


@interface CommentCell : UITableViewCell

@property User    * userModel;
@property Comment * commentModel;


@property UIImageView * profileImage;
@property UITextView * commentField;
@property UILabel * userName;
@property UIButton * userNameButton;

@property UserService * userService;
@property LocationService * locationService;
@property ImageService * imageService;
@property CommentService * commentService;
@property TripService * tripService;
@property FollowService * followService;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCommentModel:(Comment *) comment withTripService: (TripService*) tripService withUserService:(UserService*) userService imageService:imageService  withLocationService:locationService withCommentService:commentService withFollowService:followService;

@property CGRect imagerect;


@end
