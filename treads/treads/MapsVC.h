//
//  MapsVC.h
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPinAnnotation.h"
#import "LocationSmallViewController.h"
#import "LocationService.h"
#import "CommentService.h"
#import "UserService.h"

@class TripLocationService;
@class UserService;
@class LocationService;
@class ImageService;
@class CommentService;
@class TripService;
@class FollowService;

@interface MapsVC : UIViewController<CLLocationManagerDelegate, UISearchBarDelegate,UISearchDisplayDelegate, MKMapViewDelegate,UITableViewDelegate, UITableViewDataSource>

@property UserService * userService;
@property LocationService * locationService;
@property ImageService * imageService;
@property CommentService * commentService;
@property TripService * tripService;
@property FollowService * followService;
@property IBOutlet UISearchDisplayController * searchdisplaycontroller;
@property (strong) IBOutlet UISearchBar* searchBar;

@property (strong) IBOutlet MKMapView* mapView;

@property (strong) CLLocationManager* locationManager;

@property (strong) UIPopoverController * callout;

@property  int PINLIMIT;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withLocationService:(LocationService *) locationService withCommentService: (CommentService*) commentService withTripLocationService:(TripLocationService*) tripLocationService withUserService:(UserService*)userService;

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView;
-(void)pushLocation;
@end
