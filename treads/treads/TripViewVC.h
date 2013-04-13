//
//  TripViewVC.h
//  treads
//
//  Created by Anthony DeLeone on 3/8/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
@class TripService;
@class LocationService;
@class TripLocation;
@class CommentService;

@interface TripViewVC : UIViewController

typedef void (^GoToLocationBlock) (TripLocation*);

@property (strong) IBOutlet UIView* viewerWindow;

@property Location* returnedLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil backTitle:(NSString *)backTitle tripService:(TripService *)myTripService tripID:(int)myTripID LocationService:(LocationService *) myLocationService withCommentService: (CommentService*) commentService;


- (void)dataHasLoaded:(NSArray*)newData;

//@property IBOutlet UILabel* tripTitle;
//@property IBOutlet UILabel* userName;
//@property IBOutlet UILabel* tripDescription;
//@property IBOutlet UITableView* tripTable;

@end
