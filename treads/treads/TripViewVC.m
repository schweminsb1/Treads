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

@interface TripViewVC()

@property TripService* tripService;
@property int tripID;
@property (strong) UIBarButtonItem* tripEditButton;

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
    
    //set up new trip button and attach to navigation controller
    self.tripEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(tapEditButton:)];
    self.navigationItem.rightBarButtonItem = self.tripEditButton;
    
    //grab trip info from the database
    [self.tripService getTripWithID:self.tripID forTarget:self withAction:@selector(populateData:)];
}
-(void) populateData:(NSArray *)array
{
    if(array.count > 0)
    {
        Trip * myTrip = (Trip*)array[0];
        
        //populate view fields
        self.tripTitle.text = myTrip.name;
        self.userName.text = [NSString stringWithFormat:@"%d", myTrip.myID];
        self.tripDescription.text = myTrip.description;
        
        //TripLocation[] = select * from locationTripTable where tripID == x
        
        //Location[] = select * from locations
        
        //MyLocations[] = 0;
        
        
        //for each TripLocation[] {
            //for each Location[] {
                //if TripLocation[].LocationID == Location[].LocationID
                    //append Location to myLocations
        
        //update navigation item title
        self.navigationItem.title = myTrip.name;
        
        //navigation
        //UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
        //                               initWithTitle: @"Back"
        //                               style: UIBarButtonItemStyleBordered
        //                               target: nil action: nil];
        //[self.navigationItem setBackBarButtonItem: backButton];
    }
}
- (void)tapEditButton:(id)sender
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
