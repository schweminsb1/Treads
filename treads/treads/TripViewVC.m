//
//  TripViewVC.m
//  treads
//
//  Created by Anthony DeLeone on 3/8/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewVC.h"
#import "AppDelegate.h"
#import "EditTripViewController.h"
#import "DataRepository.h"
#import "Trip.h"
#import "TripService.h"

@interface TripViewVC ()

@property TripService  * tripService;
@property int tripID;

@end

@implementation TripViewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tripService: (TripService*) myTripService tripID: (int)myTripID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tripService = myTripService;
        self.tripID = myTripID;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tripService getTripWithID:self.tripID forTarget:self withAction:@selector(populateData:)];
    
}
-(void) populateData:(NSArray *)array
{
    if(array.count > 0)
    {
        Trip * myTrip = (Trip*)array[0];
        // trip query retrieved data
        _tripTitle.text = myTrip.name;
        _userName.text = [NSString stringWithFormat:@"%d", myTrip.myID];
        _tripDescription.text = myTrip.description;
        
        //TripLocation[] = select * from locationTripTable where tripID == x
        
        //Location[] = select * from locations
        
        //MyLocations[] = 0;
        
        
        //for each TripLocation[] {
            //for each Location[] {
                //if TripLocation[].LocationID == Location[].LocationID
                    //append Location to myLocations
    }
}
- (IBAction)EditClick:(id)sender
{
    // calls edit trips page
  //  EditTripViewController *EditTripVC = [[EditTripViewController alloc]initWithNibName:@"EditTripViewController" bundle:nil client: _client AppDelegate: _appDelegate];
  //  [self.navigationController pushViewController:EditTripVC animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
