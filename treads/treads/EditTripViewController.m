//
//  EditTripViewController.m
//  treads
//
//  Created by Zachary Kanoff on 3/10/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "EditTripViewController.h"
#import "AppDelegate.h"
#import "TreadsSession.h"
#import "Trip.h"
#import "TripService.h"
#import "DataRepository.h"

@interface EditTripViewController ()

@property TripService* tripService;
@property int tripID;
@property int myID;

@end

@implementation EditTripViewController

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
    
    [self.tripService getTripWithID:self.tripID forTarget:self withAction:@selector(populateData:)];


}

-(void) populateData:(NSArray *)array
{
    if(array.count > 0)
    {
        Trip * myTrip = (Trip*)array[0];
        // trip query retrieved data
        self.tripTitle.text = myTrip.name;
        self.tripDescription.text = myTrip.description;
        self.myID = myTrip.myID;
        
        //TripLocation[] = select * from locationTripTable where tripID == x
        
        //Location[] = select * from locations
        
        //MyLocations[] = 0;
        
        
        //for each TripLocation[] {
        //for each Location[] {
        //if TripLocation[].LocationID == Location[].LocationID
        //append Location to myLocations
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) saveChanges:(id) sender {
    //NSDictionary * newItem= @{@"myID":[NSNumber numberWithInt:self.myID] ,
    //                          @"tripID": [NSNumber numberWithInt: self.tripID],
    //                          @"description": [NSString stringWithString: self.tripDescription.text],
    //                          @"name": [NSString stringWithString: self.tripTitle.text]
    //                          };
    Trip* myTrip = [[Trip alloc] init];
    myTrip.name = self.tripTitle.text;
    myTrip.tripID = self.tripID;
    myTrip.myID = self.myID;
    myTrip.description = self.tripDescription.text;
    [self.tripService updateTrip:myTrip forTarget:self withAction:@selector(changesSaved)];
}

-(void) changesSaved {
    UIAlertView *saved = [[UIAlertView alloc]
                                initWithTitle: @"Woah!!"
                                message: @"Changes saved!"
                                delegate: nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
    [saved show];
    
    UIViewController * TripVC;
    
    TripVC = [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil tripService:self.tripService tripID:self.tripID];
    [self.navigationController pushViewController:TripVC animated:YES];
    
    
}

@end

