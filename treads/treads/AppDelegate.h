//
//  AppDelegate.h
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MapsVC.h"
#import "CameraVC.h"
#import "MyTripsVC.h"
#import "FollowVC.h"
#import "ProfileVC.h"
#import "LoginVC.h"
#import "TripViewVC.h"
#import "AddLocationVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
