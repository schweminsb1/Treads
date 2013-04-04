//
//  LocationViewController.h
//  treads
//
//  Created by Sam Schwemin on 4/3/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationService.h"
#import "Location.h"

@interface LocationViewController : UIViewController

@property LocationService * locationService;
@property Location * model;


-(id) initwithModel: (Location *) model withLocationService: (LocationService *) service;


@end
