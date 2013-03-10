//
//  MapsVC.h
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapsVC : UIViewController

@property (strong) IBOutlet UISearchBar* searchBar;

@property (strong) IBOutlet MKMapView* mapView;

@property (strong) CLLocationManager* locationManager;

@end
