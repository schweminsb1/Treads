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
#import "User.h"


@interface ProfileVC : UIViewController

@property (strong) IBOutlet UIView* browserWindow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tripService:(TripService *)myTripService userService:(UserService *)myUserService imageService:(ImageService*)myImageService isUser:(BOOL)isUser userID:(int)myUserID withLocationService:(LocationService*) locationService ;

- (void)dataHasLoaded:(NSArray*)newData;
- (void)tripsHaveLoaded:(NSArray*)newData;
- (void)updateUser:(int)myUserID;

- (IBAction)editProfile:(id)sender;


@end
