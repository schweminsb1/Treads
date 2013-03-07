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

@end

@implementation MyTripsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self) {
        self.title = NSLocalizedString(@"My Trips", @"My Trips");
        self.tabBarItem.image = [UIImage imageNamed:@"backpack.png"];
        
        //set up services
        self.tripService = [[TripService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up browser
    TripBrowser* browser = [[TripBrowser alloc] initWithFrame:self.browserWindow.bounds];
    [self.browserWindow addSubview: browser];
    
    //load browser data
    [browser setBrowserData:[self.tripService getTripsFromProfile:@"Active User"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
