//
//  LocationViewController.m
//  treads
//
//  Created by Sam Schwemin on 4/3/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

-(id) initWithModel: (Location *) model withLocationService: (LocationService *) service
{
    self =  [super init];
    if(self)
    {
        _locationService = service;
        _model=model;
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
