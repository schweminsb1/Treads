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

@interface FollowVC () {
    NSArray* labelText;
    NSArray* labelSelector;
}

@property (strong) TripService* tripService;
@property (strong) TripBrowser* browser;

@end

@implementation FollowVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //toolbar
        self.title = NSLocalizedString(@"Follow", @"Follow");
        self.tabBarItem.image = [UIImage imageNamed:@"earth-usa.png"];
        
        //set up services
        self.tripService = [[TripService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    labelText = @[@"Following Page", @"Feed Page", @"Favorites Page"];
    labelSelector = @[
                       ^NSArray*(void) { return [self.tripService getFollowingTrips]; },
                       ^NSArray*(void) { return [self.tripService getFeedTrips]; },
                       ^NSArray*(void) { return [self.tripService getAllTrips]; }
                      ];
    
    //set up browser
    self.browser = [[TripBrowser alloc] initWithFrame:self.browserWindow.bounds];
    [self.browserWindow addSubview: self.browser];
    
    //load browser data
    NSArray*(^getNewData)(void) = labelSelector[1];
    [self.browser setBrowserData: getNewData()];
}

- (IBAction)segmentControlChange:(UISegmentedControl*)sender
{
    self.label.text = labelText[sender.selectedSegmentIndex];
    
    NSArray*(^getNewData)(void) = labelSelector[sender.selectedSegmentIndex];
    [self.browser setBrowserData: getNewData()];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
