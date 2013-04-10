//
//  LocationPickerVC.h
//  treads
//
//  Created by Sam Schwemin on 4/10/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationService.h"

@interface LocationPickerVC : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong,nonatomic) NSMutableArray *locationsFilteredArray;
@property IBOutlet UISearchBar *locationSearchBar;

- (id)initWithStyle:(UITableViewStyle)style withLocationService:(LocationService*)service;

@end
