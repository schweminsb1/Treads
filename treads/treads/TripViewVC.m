//
//  TripViewVC.m
//  treads
//
//  Created by Anthony DeLeone on 3/8/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewVC.h"
#import "AppDelegate.h"
#import "EditTripVC.h"
#import "DataRepository.h"
#import "Trip.h"
#import "TripService.h"
#import "EditTripVC.h"

#import "TripViewer.h"

@interface TripViewVC()

@property TripService* tripService;
@property int tripID;
@property (strong) TripViewer* viewer;
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
    
    //set up browser
    self.viewer = [[TripViewer alloc] initWithFrame:self.viewerWindow.bounds];
    [self.viewer setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.viewerWindow addSubview: self.viewer];
}

- (void)viewWillAppear:(BOOL)animated
{
    //grab trip info from the database
    [self.viewer clearAndWait];
    [self.tripService getTripWithID:self.tripID forTarget:self withAction:@selector(dataHasLoaded:)];
}

- (void)dataHasLoaded:(NSArray*)newData
{
    if (newData.count == 1) {
        Trip* returnedTrip = (Trip*)newData[0];
        [self.viewer setViewerTrip:(returnedTrip) enableEditing:NO];
        [self setTitleBar:returnedTrip];
    }
    else {
        [self.viewer displayTripLoadFailure];
    }
}

- (void)setTitleBar:(Trip*)trip
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@", @"Trip Owner", trip.name];
}

/*- (void)populateData:(NSArray*)tripReturnArray
{
    if(tripReturnArray.count > 0)
    {
        Trip * myTrip = (Trip*)tripReturnArray[0];
        
        //populate view fields
        //self.tripTitle.text = myTrip.name;
        //self.userName.text = [NSString stringWithFormat:@"%d", myTrip.userID];
        //self.tripDescription.text = myTrip.description;
        
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
}*/

- (void)tapEditButton:(id)sender
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: newBackButton];
    
    //calls edit trips page
    EditTripVC* editTripVC = [[EditTripVC alloc] initWithNibName:@"EditTripVC" bundle:nil tripService:self.tripService tripID:self.tripID];
    [self.navigationController pushViewController:editTripVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
