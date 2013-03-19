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
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.85 brightness:[AppColors primaryValue]*0.75 alpha:1]];
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
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: newBackButton];
    
    //calls edit trips page
    EditTripVC* editTripVC = [[EditTripVC alloc] initWithNibName:@"EditTripVC" bundle:nil tripService:self.tripService tripID:[Trip UNDEFINED_TRIP_ID]];
    [self.navigationController pushViewController:editTripVC animated:YES];
}

- (void)showTrip:(Trip*)trip
{
    TripViewVC* tripViewVC = [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil tripService:self.tripService tripID:trip.tripID];
    [self.navigationController pushViewController:tripViewVC animated:YES];
}

@end
