//
//  EditProfileVC.h
//  treads
//
//  Created by Zachary Kanoff on 4/12/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserService;
@class TripService;
@class LocationService;
@class CommentService;

@interface EditProfileVC : UIViewController

-(IBAction) changePassword :(id) sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userService:(UserService *)myUserService;
-(NSString *) getPasswordHash:(NSString *) user_input;
- (void)dataHasLoaded:(NSArray*)newData;
@end
