//
//  FollowVC.h
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TripService;
@class LocationService;
@interface FollowVC : UIViewController

@property (strong) IBOutlet UIView* browserWindow;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTripService:(TripService*)tripServiceHandle withLocationService:(LocationService*)locationservice;

@end
