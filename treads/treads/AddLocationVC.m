//
//  AddLocationViewController.m
//  treads
//
//  Created by Anthony DeLeone on 3/8/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "AddLocationVC.h"
#import "TreadsSession.h"
#import "AppDelegate.h"
#import "TripService.h"
#import "Trip.h"
#import <MapKit/MapKit.h>
#import "LocationService.h"
#import "LocationMapVC.h"
#import "AppColors.h"
#import "LocationPickerVC.h"

@interface AddLocationVC ()


@property double                 latitude;
@property double                 longitude;
@property CLGeocoder            *geocoder;
@property LocationService       *myLocationService;
@property LocationMapVC         *locationMapVC;

@end

@implementation AddLocationVC
CLLocationCoordinate2D placedLocation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil locationService:(LocationService *)myLocationService tripID:(int)myTripID {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _myLocationService=myLocationService;
        self.latitude = 0.0;
        self.longitude =0.0;
        
    }
    return self;
}
-(id)initWithCoordinates:(CLLocationCoordinate2D)locationCoord
{
        // Custom initialization
        self.latitude = locationCoord.latitude;
        self.longitude = locationCoord.longitude;
    
    return self;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Name New Location", @"Name New Location");
    float mylong = self.longitude;
    float mylat = self.latitude;
    [_latitudeText setText:[NSString stringWithFormat:@"%.2f", mylong]];
    [_longitudeText setText:[NSString stringWithFormat:@"%.2f", mylat]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)FinishClick:(id)sender
{
    // user clicks finish and pushes the new data to the database
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Woah!!"
                          message: @"We need the following fields to add the location."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    UIAlertView *nametooLong = [[UIAlertView alloc]
                                initWithTitle: @"Woah!!"
                                message: @"The location name is rescricted to 50 characters."
                                delegate: nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
       
    __block NSArray * returnedValues= nil;
    returnedValues= [[NSArray alloc] init];
    
    // check for empty fields
    if([_locationText.text isEqualToString:@""] || _latitude == 91 || _longitude == 181 )
    {
        [alert show];
    }
    // check for names that are too long
    else if(_locationText.text.length > 50)
    {
        [nametooLong show];
        
    }
    else
    {
            NSDictionary * newItem= @{
                                      @"name": [NSString stringWithString: _locationText.text],
                                      @"latitude": [NSNumber numberWithDouble: self.latitude],
                                      @"longitude": [NSNumber numberWithDouble: self.longitude]
                                      };
            //call to insert item
        [[LocationService instance] addLocation:newItem forTarget:self withAction:(@selector(goBack:success:))];

    }
    
}
-(void) goBack:(NSNumber *)idnum success:(NSNumber*)success
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
