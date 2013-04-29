//
//  AddLocationViewController.h
//  treads
//
//  Created by Anthony DeLeone on 3/8/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "LocationPickerVC.h"
#import "TripViewVC.h"
@class LocationService;

@interface AddLocationVC : UIViewController

-(IBAction) FinishClick:(id) sender;

@property IBOutlet UITextField  * locationText;
@property Location * LocationModelnew;
@property IBOutlet UITextField  * latitudeText;
@property IBOutlet UITextField  * longitudeText;
@property (nonatomic, copy)void(^onSuccessLocation)(CLLocationCoordinate2D);
@property (nonatomic, copy) void (^returnLocationToTripView)(Location*);
@property TripViewVC * tripViewReturnDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil locationService:(LocationService *)myLocationService tripID:(int)myTripID;
-(void) goBack:(NSNumber *)idnum success:(NSNumber*)success;
-(id)initWithCoordinates:(CLLocationCoordinate2D) locationCoord;

@end
