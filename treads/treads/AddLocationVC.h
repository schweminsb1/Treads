//
//  AddLocationViewController.h
//  treads
//
//  Created by Anthony DeLeone on 3/8/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@class LocationService;

@interface AddLocationVC : UIViewController

-(IBAction) finishClick:(id) sender;
-(IBAction) addCoordinates:(id) sender;

@property IBOutlet UITextField  * locationText;
@property IBOutlet UITextView   * descriptionText;
@property IBOutlet UITextView   * attributeText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil locationService:(LocationService *)myLocationService tripID:(int)myTripID;
-(void) goBack;

@end
