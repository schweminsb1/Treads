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
@class LocationService;

@interface AddLocationVC : UIViewController

-(IBAction) FinishClick:(id) sender;
-(IBAction) chooseLocation:(id) sender;

@property IBOutlet UITextField  * locationText;

//@property IBOutlet UITextView   * descriptionText;
//@property IBOutlet UITextView   * attributeText;

@property IBOutlet UITextField  * latitudeText;
@property IBOutlet UITextField  * longitudeText;
@property (nonatomic, copy)void(^onSuccessLocation)(CLLocationCoordinate2D);
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil locationService:(LocationService *)myLocationService tripID:(int)myTripID;
-(void) goBack:(NSNumber *)idnum success:(NSNumber*)success;

@end
