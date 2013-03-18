//
//  EditTripViewController.h
//  treads
//
//  Created by Zachary Kanoff on 3/10/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@class TripService;

@interface EditTripVC : UIViewController


@property IBOutlet UITextField * tripTitle;
@property IBOutlet UITextView  * tripDescription;
@property IBOutlet UITableView * tripTable;

- (void)changesSavedTo:(NSNumber*)savedTripID successfully:(NSNumber*)wasSuccessful;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tripService: (TripService*) myTripService tripID: (int)myTripID;

- (void)displayLoadedTripData:(NSArray*)array;

@end
