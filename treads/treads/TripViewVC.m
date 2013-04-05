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
@property (strong) UIBarButtonItem* backButton;

@end

@implementation TripViewVC {
    NSString* baseTitle;
}

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
    
    //set up browser
    self.viewer = [[TripViewer alloc] initWithFrame:self.viewerWindow.bounds];
    [self.viewer setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.viewerWindow addSubview: self.viewer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.viewer clearAndWait];
    if (self.tripID == [Trip UNDEFINED_TRIP_ID]) {
        //create a new trip and place user into editing mode
        Trip* trip = [[Trip alloc] init];
        trip.tripID = [Trip UNDEFINED_TRIP_ID];
        trip.userID = -1;
        [self dataHasLoaded:@[trip]];
    }
    else {
        //load the trip from the database
        [self.tripService getTripWithID:self.tripID forTarget:self withAction:@selector(dataHasLoaded:)];
    }
}

- (void)dataHasLoaded:(NSArray*)newData
{
    if (newData.count == 1) {
        Trip* returnedTrip = (Trip*)newData[0];
        
        //only put the user in editing mode right away if the trip is new
        [self.viewer setViewerTrip:(returnedTrip) enableEditing:(returnedTrip.tripID == [Trip UNDEFINED_TRIP_ID]?YES:NO)];
        
        [self setBaseTitle:returnedTrip];
        [self setTitleBar:nil];
        
        //if the user has editing rights, add the nav bar item
        if (YES) { //can edit
            //set up new trip button and attach to navigation controller
            self.tripEditButton = [[UIBarButtonItem alloc] initWithTitle:(returnedTrip.tripID == [Trip UNDEFINED_TRIP_ID]?@"Preview":@"Edit") style:UIBarButtonItemStyleDone target:self action:@selector(tapEditButton:)];
            self.navigationItem.rightBarButtonItem = self.tripEditButton;
            
            //set up back button to save changes
            //self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"TEST" style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
            //self.navigationItem.backBarButtonItem = self.backButton;
            //[self.navigationItem.backBarButtonItem ]
            //self.navigationItem.leftBarButtonItem.target = self;
            //self.navigationItem.leftBarButtonItem.action = @selector(goBack:);
        }
        else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    else {
        [self.viewer displayTripLoadFailure];
    }
}

- (void)setBaseTitle:(Trip*)trip
{
    baseTitle = [NSString stringWithFormat:@"%@: %@", @"Trip Owner", trip.name];
}

- (void)setTitleBar:(NSString*)appendedTitle
{
    if (appendedTitle) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@", baseTitle, appendedTitle];
    }
    else {
        self.navigationItem.title = baseTitle;
    }
}

- (void)tapEditButton:(id)sender
{
    if ([self.viewer editingEnabled]) {
        //disable editing, change button to give Edit option
        self.tripEditButton.title = @"Edit";
        [self.viewer setEditingEnabled:NO];
        [self setTitleBar:nil];
    }
    else {
        //enable editing, change button to give Preview option
        self.tripEditButton.title = @"Preview";
        [self.viewer setEditingEnabled:YES];
        [self setTitleBar:@"Editing"];
    }
    
//    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style: UIBarButtonItemStyleBordered target: nil action: nil];
//    [self.navigationItem setBackBarButtonItem: newBackButton];
//    
//    //calls edit trips page
//    EditTripVC* editTripVC = [[EditTripVC alloc] initWithNibName:@"EditTripVC" bundle:nil tripService:self.tripService tripID:self.tripID];
//    [self.navigationController pushViewController:editTripVC animated:YES];
    
}

- (void)goBack:(id) sender {
    if ([self.viewer changesWereMade]) {
        //save trip changes if any were made
    [self.tripService updateTrip:[self.viewer viewerTrip] forTarget:self withAction:@selector(changesSavedTo:successfully:)];
    }
    else {
        //if no changes were made, simply pop the trip viewer
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)changesSavedTo:(NSNumber*)savedTripID successfully:(NSNumber*)wasSuccessful {
    BOOL successful = [wasSuccessful boolValue];
    if (successful) {
        int tripID = [savedTripID intValue];
        
        UIAlertView *saved = [[UIAlertView alloc]
                              initWithTitle: [self.viewer viewerTrip].name
                              message: @"Changes saved."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [saved show];
        
        if (self.tripID != tripID) {
            [self.viewer viewerTrip].tripID = tripID;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *saved = [[UIAlertView alloc]
                              initWithTitle: [self.viewer viewerTrip].name
                              message: @"Error: Changes could not be saved."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [saved show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
