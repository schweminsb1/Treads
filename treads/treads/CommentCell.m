//
//  CommentCell.m
//  treads
//
//  Created by Sam Schwemin on 4/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "CommentCell.h"
#import "ProfileVC.h"
#import "CommentService.h"
#import "ImageService.h"
#import "FollowService.h"
#import "LocationService.h"
#import "UserService.h"
#import "LocationVC.h"
#import "TreadsSession.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCommentModel:(Comment *) comment withTripService: (TripService*) tripService withUserService:(UserService*) userService imageService:(ImageService*)imageService  withLocationService:(LocationService*)locationService withCommentService:(CommentService*)commentService withFollowService:(FollowService*)followService withLocationDelegate:(LocationVC*)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _delegate=delegate;
        _tripService=tripService;
        _userService=userService;
        _imageService=imageService;
        _locationService=locationService;
        _commentService=commentService;
        _followService=followService;
        
          _imagerect= CGRectMake(self.bounds.origin.x+5, self.bounds.origin.y+5, self.bounds.size.height-20, self.bounds.size.height-20);
        _userNameButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _userNameButton.frame=CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 90, self.bounds.size.height-12);
        _userNameButton.hidden=NO;
     
        [_userNameButton addTarget:self action:@selector(toProfilePage) forControlEvents:UIControlEventTouchUpInside];
        _userModel = [[User alloc]init];
        _userModel.fname=@"";
        _userModel.lname=@"";
        _userModel.User_ID=-1;
        // Initialization code 
        _commentModel=comment;
        self.selectionStyle= UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled= YES;
           _userNameButton.userInteractionEnabled=YES;
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
    
       _userNameButton.userInteractionEnabled=YES;
    
    _profileImage =[[UIImageView alloc] initWithFrame: _imagerect];
    _profileImage.image = _proImage;
    
    _commentField = [[UITextView alloc] initWithFrame:CGRectMake(_imagerect.origin.x+ _imagerect.size.width + 1, self.bounds.origin.y, 550, self.bounds.size.height-1)];
    _commentField.userInteractionEnabled=NO;
    _commentField.text = [NSString stringWithFormat:@"%@ %@ says: \n \n \t %@",_userModel.fname,_userModel.lname,  _commentModel.comment ];
    
    
    [self addSubview:_profileImage];
    [self addSubview:_commentField];
    [self addSubview:_userNameButton];
}
-(void)recieveUserModel:(NSArray*) items
{
    if(items.count>0)
    _userModel=items[0];
    _userNameButton.hidden=NO;
    
    CompletionWithItems block= ^(NSArray* items)
    {
        _proImage=items[0];
      [self layoutSubviews];
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    };
    [[ImageService instance] getImageWithPhotoID:_userModel.profilePhotoID withReturnBlock:block];
    
    
    
}
-(void)toProfilePage
{
    if([TreadsSession instance].treadsUserID == _userModel.User_ID)
    {
        ProfileVC * profilevc= [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil tripService:_tripService userService:_userService imageService:_imageService isUser:YES userID:_userModel.User_ID withLocationService:_locationService withCommentService:_commentService withFollowService:_followService];
        [self.delegate.navigationController pushViewController:profilevc animated:YES];
    }
    else
    {
    ProfileVC * profilevc= [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil tripService:_tripService userService:_userService imageService:_imageService isUser:NO userID:_userModel.User_ID withLocationService:_locationService withCommentService:_commentService withFollowService:_followService];
    [self.delegate.navigationController pushViewController:profilevc animated:YES];
    }
}

@end
