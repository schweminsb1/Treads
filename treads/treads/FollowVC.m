//
//  FollowVC.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "FollowVC.h"
#import "TripBrowser.h"

#import "Trip.h"

@interface FollowVC () {
    NSArray* labelText;
}

@end

@implementation FollowVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Follow", @"Follow");
        self.tabBarItem.image = [UIImage imageNamed:@"earth-usa.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    labelText = @[@"Following Page", @"Feed Page", @"Favorites Page"];
    
    TripBrowser* browser = [[TripBrowser alloc] initWithFrame:self.browserWindow.frame];
    [self.browserWindow addSubview: browser];
    
    Trip* trip1 = [[Trip alloc] init];
    trip1.name = @"Test Trip 1";
    NSArray* tripData = [[NSArray alloc] initWithObjects: trip1, nil];
    [browser setBrowserData:tripData];
    
}

-(IBAction)segmentControlChange:(UISegmentedControl*)sender
{
    self.label.text = labelText[sender.selectedSegmentIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
