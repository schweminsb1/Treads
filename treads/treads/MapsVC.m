//
//  MapsVC.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "MapsVC.h"

@interface MapsVC ()

@end

@implementation MapsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self) {
        self.title = NSLocalizedString(@"Maps", @"Maps");
        self.tabBarItem.image = [UIImage imageNamed:@"map-pin.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation* myLocation = locations[0];
    MKCoordinateSpan span;
    span.latitudeDelta = .005;
    span.longitudeDelta = .005;
    
    MKCoordinateRegion region;
    region.center = myLocation.coordinate;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    [self.locationManager stopUpdatingLocation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
