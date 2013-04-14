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
#import "User.h"

#import "TripViewVC.h"
#import "LocationService.h"
#import "FollowService.h"
#import "TreadsSession.h"

@interface FollowVC () {
    NSArray* browserModeControlLabels;
    NSArray* browserModeControlActions;
    NSArray* browserCellStyles;
}

@property (strong) TripService* tripService;
@property (strong) TripBrowser* browser;
@property (strong) UISegmentedControl* browserModeControl;
@property LocationService * locationService;
@property CommentService * commentService;
@property UserService * userService;
@end

@implementation FollowVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTripService:(TripService*)tripServiceHandle withLocationService:(LocationService*)locationservice withCommentService:(CommentService*) commentService withUserService:(UserService*) userService
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //toolbar
        _userService=userService;
        self.title = NSLocalizedString(@"Follow", @"Follow");
        self.tabBarItem.image = [UIImage imageNamed:@"compass.png"];
        _locationService=locationservice;
        //set up services
        self.tripService = tripServiceHandle;//[[TripService alloc] init];
        _commentService = commentService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up segmented control
    browserModeControlLabels = @[
                                 @"Following",
                                 @"Feed",
                                 @"Favorites"
                                 ];
    browserModeControlActions = @[
                                  ^void(void) {[[FollowService instance] getPeopleIFollow:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(profileDataHasLoaded:)];},
                                   ^void(void) {[[TripService instance] getAllTripsForTarget:self withAction:@selector(tripDataHasLoaded:)];},
                                   ^void(void) {[[TripService instance] getAllTripsForTarget:self withAction:@selector(tripDataHasLoaded:)];}
                      ];
    browserCellStyles = @[
                          [NSNumber numberWithInt:ProfileBrowserCell5x1],
                          [NSNumber numberWithInt:TripBrowserCell3x4],
                          [NSNumber numberWithInt:TripBrowserCell6x2]
                         ];
    
    self.browserModeControl = [[UISegmentedControl alloc] initWithItems:browserModeControlLabels];
    [self.browserModeControl addTarget:self action:@selector(segmentControlChange:) forControlEvents:UIControlEventValueChanged];
    self.browserModeControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    //attach segmented control to navigation controller
    [self.navigationController.navigationBar.topItem setTitleView:self.browserModeControl];
    
    //set up
    self.browser = [[TripBrowser alloc] initWithFrame:self.browserWindow.bounds];
    [self.browser setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.browserWindow addSubview: self.browser];
    
    //initial display
    [self.browserModeControl setSelectedSegmentIndex:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self segmentControlChange:self.browserModeControl];
}

- (void)segmentControlChange:(UISegmentedControl*)sender
{
    [self.browser clearAndWait];
//    [self.browser setCellStyle:(TripBrowserCellStyle)[browserCellStyles[sender.selectedSegmentIndex] intValue]];
    void(^fcn)(void) = browserModeControlActions[sender.selectedSegmentIndex]; fcn();
}

- (void)profileDataHasLoaded:(NSArray*)newData
{
    newData = @[];
    [self.browser setBrowserData:newData withCellStyle:(TripBrowserCellStyle)[browserCellStyles[self.browserModeControl.selectedSegmentIndex] intValue] forTarget:self withAction:@selector(showTrip:)];
}

- (void)tripDataHasLoaded:(NSArray*)newData
{
    [self.browser setBrowserData:newData withCellStyle:(TripBrowserCellStyle)[browserCellStyles[self.browserModeControl.selectedSegmentIndex] intValue] forTarget:self withAction:@selector(showTrip:)];
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

- (void)showTrip:(Trip*)trip
{
    //NSLog(@"Showing Trip: %@", trip.name);
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:browserModeControlLabels[self.browserModeControl.selectedSegmentIndex] style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: newBackButton];
    
    TripViewVC* tripViewVC = [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil backTitle:self.title tripService:self.tripService tripID:trip.tripID LocationService:_locationService withCommentService:_commentService withUserService:_userService];
    [self.navigationController pushViewController:tripViewVC animated:YES];
}

- (void)showProfile:(User*)profile
{
    
}

@end
