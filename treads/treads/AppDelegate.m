//
//  AppDelegate.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "AppDelegate.h"

#import "DataRepository.h"
#import "TripService.h"
#import "ProfileService.h"
#import "EditTripVC.h"
#import "LocationService.h"
#import "AppColors.h"
#import "CommentService.h"
#import "ImageService.h"
#import "UserService.h"
#import "TripLocationService.h"
#import "LocationPickerVC.h"
#import "TreadsSession.h"
#import "FollowService.h"

@interface AppDelegate()

//repositories
@property (strong) DataRepository* dataRepository;

//services
@property (strong) TripService* tripService;
@property (strong) ProfileService* profileService;
@property (strong) LocationService* locationService;
@property (strong) CommentService* commentService;
@property (strong) ImageService* imageService;
@property (strong) UserService* userService;
@property (strong) FollowService* followService;
@property (strong) NSString * SASURL;
@property (strong) TripLocationService * tripLocationService;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Initialize repositories
    self.dataRepository = [[DataRepository alloc] init];
    //[_dataRepository createContainer:@"TreadsContainer" withPublicSetting:YES withCompletion:comp];
   
    //Initialize services
    self.tripService = [[TripService alloc] initWithRepository:self.dataRepository];
    self.locationService = [[LocationService alloc]initWithRepository:self.dataRepository];
    self.commentService = [[CommentService alloc] initWithRepository:self.dataRepository];
    self.userService = [[UserService alloc] initWithRepository:self.dataRepository];
    self.tripLocationService=  [[TripLocationService alloc] initWithRepository:self.dataRepository];
    self.imageService = [[ImageService alloc] initWithRepository:self.dataRepository];
    self.followService = [[FollowService alloc] initWithRepository:self.dataRepository];
    
    //connect services
    self.tripService.imageService = self.imageService;
    
//    [self.imageService insertImage:[UIImage imageNamed:@"mountains.jpeg"] withCompletion:^(NSDictionary *item, NSError *error) {
//        NSLog(error.localizedDescription);
//    }];
    
    //Set global display options
    [[UINavigationBar appearance] setTintColor:[AppColors toolbarColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[AppColors toolbarColor]];
    
    //Initialize ViewControllers
    UIViewController *mapsVC, *cameraVC, *myTripsVC, *followVC, *profileVC;
    
    mapsVC = [[MapsVC alloc] initWithNibName:@"MapsVC" bundle:nil withLocationService: self.locationService withCommentService: self.commentService withTripLocationService: _tripLocationService withUserService:_userService];
    cameraVC = [[CameraVC alloc] initWithNibName:@"CameraVC" bundle:nil];
    myTripsVC = [[MyTripsVC alloc] initWithNibName:@"MyTripsVC" bundle:nil withTripService:self.tripService withLocationService:_locationService withCommentService: _commentService withUserService:_userService];
    followVC = [[FollowVC alloc] initWithNibName:@"FollowVC" bundle:nil withTripService:self.tripService withLocationService:_locationService withCommentService:_commentService withUserService:_userService];
    profileVC = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil tripService:self.tripService userService:self.userService imageService:self.imageService isUser:YES userID:[TreadsSession instance].treadsUserID withLocationService:_locationService withCommentService:_commentService withFollowService:self.followService];


    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[
                                              [[UINavigationController alloc] initWithRootViewController:mapsVC],
                                              cameraVC,
                                              [[UINavigationController alloc] initWithRootViewController:myTripsVC],
                                              [[UINavigationController alloc] initWithRootViewController:followVC],
                                              [[UINavigationController alloc] initWithRootViewController:profileVC]
                                              ];
    
    LoginVC* login;
    
    //Set the login controller to default
    login = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil client:_dataRepository.client AppDelegate:self withUserService:_userService];
    login.title = @"Login";
    UINavigationController* LoginNavigation = [[UINavigationController alloc] initWithRootViewController:login];
    
    //self.window.rootViewController=LoginNavigation;
    self.window.rootViewController=LoginNavigation;
    //Initialize and assign to Tab Bar

    
   // self.window.rootViewController = self.tabBarController;
    //[self.tabBarController setSelectedIndex:2];
    
 //   AddLocationVC * addLocationController = [[AddLocationVC new]initWithNibName:@"AddLocationVC" bundle:(nil ) locationService:_locationService tripID:0];
    
    //self.window.rootViewController = addLocationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
