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
    
    //set up new trip button
    self.tripNewButton = [[UIBarButtonItem alloc] initWithTitle:@"New Trip" style:UIBarButtonItemStyleDone target:self action:@selector(createNewTrip)];
    
    //attach new trip button to navigation controller
    //UINavigationController* navigationController = [self navigationController];
    self.navigationItem.rightBarButtonItem = self.tripNewButton;
    
    //set up browser
    self.browser = [[TripBrowser alloc] initWithFrame:self.browserWindow.bounds];
    [self.browserWindow addSubview: self.browser];
    
    //load browser data
    //[browser setBrowserData:[self.tripService getTripsFromProfile:@"Active User"] forTarget:self withAction:@selector(showTrip:)];
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
    NSLog(@"Showing Trip: %@", trip.name);
}

@end
