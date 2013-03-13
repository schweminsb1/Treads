//
//  TripViewVC.h
//  treads
//
//  Created by Anthony DeLeone on 3/8/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@class TripService;

@interface TripViewVC : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tripService: (TripService*) myTripService tripID: (int)myTripID;

- (void) populateData:(NSArray *)array;

@property IBOutlet UILabel* tripTitle;
@property IBOutlet UILabel* userName;
@property IBOutlet UILabel* tripDescription;
@property IBOutlet UITableView* tripTable;

@end
