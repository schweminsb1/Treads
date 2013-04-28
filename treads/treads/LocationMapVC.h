//
//  LocationMapVC.h
//  treads
//
//  Created by Anthony DeLeone on 4/13/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPinAnnotation.h"
#import "LocationSmallViewController.h"
#import "LocationService.h"
#import "TripViewVC.h"
@interface LocationMapVC : UIViewController <CLLocationManagerDelegate, UISearchBarDelegate, UINavigationControllerDelegate,MKMapViewDelegate>
@property (nonatomic, copy)void(^locationMapSuccess)(CLLocationCoordinate2D);
@property (nonatomic, copy) void (^returnLocationToTripView)(Location*);
@property TripViewVC * tripViewReturnDelegate;
@end
