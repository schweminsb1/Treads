//
//  AppDelegate.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Set up MSClient
    MSClient *client = [MSClient clientWithApplicationURLString:@"https://treads.azure-mobile.net/"
                                             withApplicationKey:@"uxbEolJjpIKEpNJSnsNEuGehMowvxj53"];
    
    //Initialize ViewControllers
    UIViewController *mapsVC, *cameraVC, *myTripsVC, *followVC, *profileVC;
    
    mapsVC = [[MapsVC alloc] initWithNibName:@"MapsVC" bundle:nil];
    cameraVC = [[CameraVC alloc] initWithNibName:@"CameraVC" bundle:nil];
    myTripsVC = [[MyTripsVC alloc] initWithNibName:@"MyTripsVC" bundle:nil];
    followVC = [[FollowVC alloc] initWithNibName:@"FollowVC" bundle:nil];
    profileVC = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
    
    LoginViewController * login;
    
    //Set the login controller to default
    login= [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil client:client AppDelegate:self];
    login.title = @"Login";
    UINavigationController * LoginNavigation = [[UINavigationController alloc] initWithRootViewController:login];
    
    //self.window.rootViewController=LoginNavigation;
    
    //Initialize and assign to Tab Bar
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[
        [[UINavigationController alloc] initWithRootViewController:followVC],
        [[UINavigationController alloc] initWithRootViewController:mapsVC],
        cameraVC,
        [[UINavigationController alloc] initWithRootViewController:myTripsVC],
        //followVC,
        profileVC
        ];
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
