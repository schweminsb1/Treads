//
//  MyTripsVC.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "MyTripsVC.h"

#import "TripBrowser.h"

#import "TripService.h"
#import "Trip.h"

#import "TripViewVC.h"

#import "EditTripVC.h"

#import "AppColors.h"

#import "LocationService.h"
#import "CommentService.h"
#import "UserService.h"

#import "TreadsSession.h"

@interface MyTripsVC()

@property (strong) TripService* tripService;
@property (strong) TripBrowser* browser;
@property (strong) UIBarButtonItem* tripNewButton;
@property LocationService* locationService;
@property CommentService * commentService;
@property UserService * userService;
@end

@implementation MyTripsVC {
    NSArray* drafts;
    NSArray* trips;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTripService:(TripService *)tripServiceHandle withLocationService:(LocationService*)locationservice withCommentService:(CommentService*)commentService withUserService:(UserService*) userService
{
    if (self) {
        self.title = NSLocalizedString(@"My Trips", @"My Trips");
        self.tabBarItem.image = [UIImage imageNamed:@"backpack.png"];
        _locationService=locationservice;
        //set up services
        self.tripService = tripServiceHandle;//[[TripService alloc] init];
        _commentService=commentService;
        _userService=userService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up new trip button and attach to navigation controller
    self.tripNewButton = [[UIBarButtonItem alloc] initWithTitle:@"New Trip" style:UIBarButtonItemStyleDone target:self action:@selector(createNewTrip)];
    self.navigationItem.rightBarButtonItem = self.tripNewButton;
    
    //set up browser
    self.browser = [[TripBrowser alloc] initWithFrame:self.browserWindow.bounds];
    [self.browser setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.browserWindow addSubview: self.browser];
}

- (void)viewWillAppear:(BOOL)animated
{
    //load browser data
    [self.browser clearAndWait];
    self.navigationItem.rightBarButtonItem = self.tripNewButton;
    //    [self.browser setCellStyle:TripBrowserCell4x1];
    drafts = nil;
    trips = nil;
    [self.tripService getDraftsWithUserID:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(draftsHaveLoaded:)];
    [self.tripService getTripsWithUserID:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(tripsHaveLoaded:)];
    //[self.tripService getTripWithID:0 forTarget:self withAction:@selector(dataHasLoaded:)];
}

- (void)draftsHaveLoaded:(NSArray*)newDrafts
{
    drafts = newDrafts;
    if (drafts && trips) {[self dataHasLoaded];}
}

- (void)tripsHaveLoaded:(NSArray*)newTrips
{
    trips = newTrips;
    if (drafts && trips) {[self dataHasLoaded];}
}

- (void)dataHasLoaded//:(NSArray*)newData
{
    NSArray* newData = [[NSArray arrayWithArray:drafts] arrayByAddingObjectsFromArray:trips];
    [self.browser setBrowserData:newData withCellStyle:TripBrowserCell4x1 forTarget:self withAction:@selector(showTrip:)];
    for (Trip* trip in newData) {
        [self.tripService getHeaderImageForTrip:trip forTarget:self withCompleteAction:@selector(refreshWithNewHeader)];
    }
}

- (void)refreshWithNewHeader
{
    [self.browser refreshWithNewImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNewTrip
{
    Trip* trip = [[Trip alloc] init];
    trip.tripID = [Trip UNDEFINED_TRIP_ID];
    [self showTrip:trip];
}

- (void)showTrip:(Trip*)trip
{
    TripViewVC* tripViewVC = [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil backTitle:self.title tripService:self.tripService tripID:trip.tripID LocationService:_locationService withCommentService:_commentService withUserService:_userService];
    [self.navigationController pushViewController:tripViewVC animated:YES];
}

@end
