//
//  LocationVC.h
//  treads
//
//  Created by Sam Schwemin on 4/3/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LocationService.h"
#import "CommentService.h"
#import "Location.h"
#import "CommentEnterBox.h"

@class UserService;
@class LocationService;
@class ImageService;
@class CommentService;
@class TripService;
@class FollowService;

@interface LocationVC : UIViewController 

@property UserService * userService;
@property LocationService * locationService;
@property ImageService * imageService;
@property CommentService * commentService;
@property TripService * tripService;
@property FollowService * followService;
@property IBOutlet UIView * tableContainerView;
@property IBOutlet UIImageView * imageView;
@property Location * model;

//UI
@property (strong, atomic) IBOutlet  UILabel * name;
//@property (strong, atomic) IBOutlet  UILabel * lat;
//@property (strong, atomic) IBOutlet  UILabel * lon;
@property (strong, atomic) IBOutlet  UITextView * description;
@property (strong)  UISegmentedControl * segmentControl;
@property IBOutlet UITableView * commentTable;
@property CommentEnterBox * commentEnterCell;
@property (strong) IBOutlet UIView* nameHighlightView;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withModel: (Location *) model withTripService: (TripService*) tripService withUserService:(UserService*) userService imageService:(ImageService*)imageService  withLocationService:(LocationService*)locationService withCommentService:(CommentService*)commentService withFollowService:(FollowService*)followService;


@end
