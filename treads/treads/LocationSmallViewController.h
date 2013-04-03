//
//  LocationSmallViewController.h
//  treads
//
//  Created by Sam Schwemin on 4/2/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface LocationSmallViewController : UIViewController

@property Location * location;
@property IBOutlet UILabel * name;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil location: (Location *) location;

-(IBAction)goToLocationPage:(id)sender;


@end
