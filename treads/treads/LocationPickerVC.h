//
//  LocationPickerVC.h
//  treads
//
//  Created by Sam Schwemin on 4/10/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationService.h"
#import "Location.h"
#import <MapKit/MapKit.h>
#import "TripViewVC.h"
@interface LocationPickerVC : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
typedef void (^CompletionBlockWithCoord) (CLLocationCoordinate2D);
@property (strong,nonatomic) NSMutableArray *locationsFilteredArray;
@property IBOutlet UISearchBar *locationSearchBar;
@property (nonatomic, copy) void (^returnLocationToTripView)(Location*);
@property TripViewVC * tripViewerReturnDelegate;


- (id)initWithStyle:(UITableViewStyle)style withLocationService:(LocationService*)service;

@end
