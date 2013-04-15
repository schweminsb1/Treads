//
//  ProfileVC.h
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripService.h"
#import "UserService.h"
#import "ImageService.h"
#import "LocationService.h"
#import "FollowService.h"
#import "User.h"
@class CommentService;


@interface ProfileVC : UIViewController

@property (strong) IBOutlet UIActivityIndicatorView* activityIndicatorView;
@property (strong) IBOutlet UIView* browserWindow;
@property (strong) IBOutlet UIView* nameHighlightView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tripService:(TripService *)myTripService userService:(UserService *)myUserService imageService:(ImageService*)myImageService isUser:(BOOL)isUser userID:(int)myUserID withLocationService:(LocationService*) locationService withCommentService:(CommentService*) commentService  withFollowService:(FollowService*)myFollowService;


- (void)dataHasLoaded:(NSArray*)newData;
- (void)tripsHaveLoaded:(NSArray*)newData;
- (void)updateUser:(int)myUserID;
- (void) followDataHasLoaded:(NSArray*)newData;
- (IBAction)followUser:(id)sender;

- (IBAction)editProfile:(id)sender;
- (void) followSuccess;
@property (copy) void (^sendNewImageRequest)(void(^onSuccess)(UIImage*));

@end
