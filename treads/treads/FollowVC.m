//
//  FollowVC.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "FollowVC.h"

#import "TripBrowser.h"

#import "TripService.h"
#import "Trip.h"

#import "TripViewVC.h"

@interface FollowVC () {
    NSArray* browserModeControlLabels;
    NSArray* browserModeControlActions;
}

@property (strong) TripService* tripService;
@property (strong) TripBrowser* browser;
@property (strong) UISegmentedControl* browserModeControl;

@end

@implementation FollowVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTripService:(TripService*)tripServiceHandle
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //toolbar
        self.title = NSLocalizedString(@"Follow", @"Follow");
        self.tabBarItem.image = [UIImage imageNamed:@"compass.png"];
        
        //set up services
        self.tripService = tripServiceHandle;//[[TripService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up segmented control
    browserModeControlLabels = @[@"Following", @"Feed", @"Favorites"];
    browserModeControlActions = @[
                       ^void(void) { [self.tripService getAllTripsForTarget:self withAction:@selector(dataHasLoaded:)]; },
                       ^void(void) { [self.tripService getAllTripsForTarget:self withAction:@selector(dataHasLoaded:)]; },
                        ^void(void) { [self.tripService getAllTripsForTarget:self withAction:@selector(dataHasLoaded:)]; }
                      ];
    //browserModeControlActions = @[
    //                              ^NSArray*(void) { return [self.tripService getFollowingTrips]; },
    //                               ^NSArray*(void) { return [self.tripService getFeedTrips]; },
    //                               ^NSArray*(void) { return [self.tripService getAllTrips]; }
    //                               ];
    self.browserModeControl = [[UISegmentedControl alloc] initWithItems:browserModeControlLabels];
    [self.browserModeControl addTarget:self action:@selector(segmentControlChange:) forControlEvents:UIControlEventValueChanged];
    [self.browserModeControl setSelectedSegmentIndex:1];
    self.browserModeControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    //attach segmented control to navigation controller
    UINavigationController* navigationController = [self navigationController];
    [navigationController.navigationBar.topItem setTitleView:self.browserModeControl];
    
    //set up
    self.browser = [[TripBrowser alloc] initWithFrame:self.browserWindow.bounds];
    [self.browserWindow addSubview: self.browser];
    
    //load browser data
    //NSArray*(^getNewData)(void) = browserModeControlActions[1];
    //[self.browser setBrowserData: getNewData() forTarget:self withAction:@selector(showTrip:)];
    void(^fcn)(void) = browserModeControlActions[1]; fcn();
}

- (void)segmentControlChange:(UISegmentedControl*)sender
{
    //self.label.text = labelText[sender.selectedSegmentIndex];
    
    //NSArray*(^getNewData)(void) = browserModeControlActions[sender.selectedSegmentIndex];
    //[self.browser setBrowserData: getNewData() withAction:^void(Trip* trip){[self showTrip:trip];}];
    //[self.browser setBrowserData: getNewData() forTarget: self withAction:@selector(showTrip:)];
    [self.browser setBrowserData:nil forTarget:nil withAction:nil];
    void(^fcn)(void) = browserModeControlActions[sender.selectedSegmentIndex]; fcn();
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

- (void)showTrip:(Trip*)trip
{
    //NSLog(@"Showing Trip: %@", trip.name);
    TripViewVC* tripViewVC = [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil tripService:self.tripService tripID:trip.tripID];
    [self.navigationController pushViewController:tripViewVC animated:YES];
}

@end
