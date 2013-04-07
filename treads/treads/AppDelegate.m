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

@interface AppDelegate()

//repositories
@property (strong) DataRepository* dataRepository;

//services
@property (strong) TripService* tripService;
@property (strong) ProfileService* profileService;
@property (strong) LocationService* locationService;
@property (strong) CommentService* commentService;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Initialize repositories
    self.dataRepository = [[DataRepository alloc] init];
    CompletionBlock comp= ^(){
        
        self.tripService = [[TripService alloc] initWithRepository:self.dataRepository];
        
    };
    //[_dataRepository createContainer:@"TreadsContainer" withPublicSetting:YES withCompletion:comp];
    //Initialize services
    self.tripService = [[TripService alloc] initWithRepository:self.dataRepository];
    
    self.locationService = [[LocationService alloc]initWithRepository:_dataRepository];
    _commentService= [[CommentService alloc] initWithRepository:_dataRepository];
    //Set global display options
    [[UINavigationBar appearance] setTintColor:[AppColors toolbarColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[AppColors toolbarColor]];
    
    //Initialize ViewControllers
    UIViewController *mapsVC, *cameraVC, *myTripsVC, *followVC, *profileVC;
    
    mapsVC = [[MapsVC alloc] initWithNibName:@"MapsVC" bundle:nil withLocationService: self.locationService withCommentService: self.commentService];
    cameraVC = [[CameraVC alloc] initWithNibName:@"CameraVC" bundle:nil];
    myTripsVC = [[MyTripsVC alloc] initWithNibName:@"MyTripsVC" bundle:nil withTripService:self.tripService];
    followVC = [[FollowVC alloc] initWithNibName:@"FollowVC" bundle:nil withTripService:self.tripService];
    profileVC = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[
                                              [[UINavigationController alloc] initWithRootViewController:mapsVC],
                                              cameraVC,
                                              [[UINavigationController alloc] initWithRootViewController:myTripsVC],
                                              [[UINavigationController alloc] initWithRootViewController:followVC],
                                              profileVC
                                              ];
    
    LoginVC* login;
    
    //Set the login controller to default
    login = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil client:self.dataRepository.client AppDelegate:self];
    login.title = @"Login";
    UINavigationController* LoginNavigation = [[UINavigationController alloc] initWithRootViewController:login];
    
    self.window.rootViewController=LoginNavigation;
    
    //Initialize and assign to Tab Bar

    
   // self.window.rootViewController = self.tabBarController;
    //[self.tabBarController setSelectedIndex:2];
    
    AddLocationVC * addLocationController = [[AddLocationVC new]initWithNibName:@"AddLocationVC" bundle:(nil ) locationService:_locationService tripID:0];
    
    //self.window.rootViewController = addLocationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
