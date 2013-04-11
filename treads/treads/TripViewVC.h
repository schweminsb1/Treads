//
//  TripViewVC.h
//  treads
//
//  Created by Anthony DeLeone on 3/8/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TripService;
@class LocationService;
@interface TripViewVC : UIViewController

@property (strong) IBOutlet UIView* viewerWindow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil backTitle:(NSString *)backTitle tripService:(TripService *)myTripService tripID:(int)myTripID LocationService:(LocationService *) myLocationService;


- (void)dataHasLoaded:(NSArray*)newData;

//@property IBOutlet UILabel* tripTitle;
//@property IBOutlet UILabel* userName;
//@property IBOutlet UILabel* tripDescription;
//@property IBOutlet UITableView* tripTable;

@end
