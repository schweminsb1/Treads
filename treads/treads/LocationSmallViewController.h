//
//  LocationSmallViewController.h
//  treads
//
//  Created by Sam Schwemin on 4/2/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "LocationVC.h"
#import "MapsVC.h"
#import "MapPinAnnotation.h"

@class LocationService;
@class MapsVC;

@interface LocationSmallViewController : UIViewController

@property Location * location;
@property IBOutlet UILabel * name;
@property IBOutlet UIView * scrollView;
@property IBOutlet UILabel * IncludedInTripsLabel;
@property IBOutlet UILabel * CommentsInLocationsLabel;
@property LocationService * service;
@property NSString * IncludedInTrips;
@property NSString * CommentsInLocations;

@property IBOutlet UILabel * latLabel;
@property IBOutlet UILabel * lonLabel;

//contains the page from which called this popup controller, this will be used to push a page onto the navigation controller of this instance
@property MapsVC * homepage;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil location: (MapPinAnnotation *) location homeController: (MapsVC *) root Service: (LocationService *) service;

-(IBAction)goToLocationPage:(id)sender;


@end
