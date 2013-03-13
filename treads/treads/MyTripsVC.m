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

@interface MyTripsVC ()

@property (strong) TripService* tripService;
@property (strong) TripBrowser* browser;
@property (strong) UIBarButtonItem* tripNewButton;

@end

@implementation MyTripsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTripService:(TripService *)tripServiceHandle
{
    if (self) {
        self.title = NSLocalizedString(@"My Trips", @"My Trips");
        self.tabBarItem.image = [UIImage imageNamed:@"backpack.png"];
        
        //set up services
        self.tripService = tripServiceHandle;//[[TripService alloc] init];
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
    [self.browserWindow addSubview: self.browser];
}

- (void)viewWillAppear:(BOOL)animated
{
    //load browser data
    [self.browser clearAndWait];
    [self.tripService getAllTripsForTarget:self withAction:@selector(dataHasLoaded:)];
    //[self.tripService getTripWithID:0 forTarget:self withAction:@selector(dataHasLoaded:)];
}

- (void)dataHasLoaded:(NSArray*)newData
{
    [self.browser setBrowserData:newData forTarget:self withAction:@selector(showTrip:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNewTrip
{
    //add a blank edit trip vc to the navigation controller stack
    NSLog(@"Create new trip");
}

- (void)showTrip:(Trip*)trip
{
    TripViewVC* tripViewVC = [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil tripService:self.tripService tripID:trip.tripID];
    [self.navigationController pushViewController:tripViewVC animated:YES];
}

@end
