//
//  LocationSmallViewController.m
//  treads
//
//  Created by Sam Schwemin on 4/2/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "LocationSmallViewController.h"

@interface LocationSmallViewController ()

@end

@implementation LocationSmallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil location: (Location *) location
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.location=location;
        
       
        
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.name.text = _location.title;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goToLocationPage:(id)sender
{
    
    
}
@end
