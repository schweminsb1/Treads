//
//  EditTripViewController.m
//  treads
//
//  Created by Zachary Kanoff on 3/10/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "EditTripVC.h"
#import "AppDelegate.h"
#import "TreadsSession.h"
#import "Trip.h"
#import "TripService.h"
#import "DataRepository.h"

@interface EditTripVC ()

@property TripService* tripService;
@property (strong) UIBarButtonItem* tripSaveButton;

@property int tripID;
@property int userID;
@property         CGRect rectangle;
@end

@implementation EditTripVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tripService: (TripService*) myTripService tripID:(int)myTripID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tripService = myTripService;
        self.tripID = myTripID;
        self.userID = [Trip UNDEFINED_TRIP_ID];
        
        self.rectangle= self.view.bounds;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up save button and attach to navigation controller
    self.tripSaveButton = [[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStyleDone target:self action:@selector(saveChanges:)];
    self.navigationItem.rightBarButtonItem = self.tripSaveButton;
    
    //set up controller
    if (self.tripID != [Trip UNDEFINED_TRIP_ID]) {
        [self.tripService getTripWithID:self.tripID forTarget:self withAction:@selector(displayLoadedTripData:)];
    }
}

- (void)displayLoadedTripData:(NSArray *)array
{
    if(array.count > 0)
    {
        Trip * myTrip = (Trip*)array[0];
        // trip query retrieved data
        self.tripTitle.text = myTrip.name;
        self.tripDescription.text = myTrip.description;
        self.userID = myTrip.userID;
        
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


- (void)saveChanges:(id) sender {
    Trip* myTrip = [[Trip alloc] init];
    myTrip.name = self.tripTitle.text;
    myTrip.tripID = self.tripID;
    myTrip.userID = self.userID;
    myTrip.description = self.tripDescription.text;
    [self.tripService updateTrip:myTrip forTarget:self withAction:@selector(changesSavedTo:successfully:)];
}

- (void)changesSavedTo:(NSNumber*)savedTripID successfully:(NSNumber*)wasSuccessful {
    BOOL successful = [wasSuccessful boolValue];
    if (successful) {
        int tripID = [savedTripID intValue];
        
        UIAlertView *saved = [[UIAlertView alloc]
                              initWithTitle: self.tripTitle.text
                              message: @"Changes saved."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [saved show];
        
        if (self.tripID != tripID) {
            self.tripID = tripID;
        }
    }
    else {
        UIAlertView *saved = [[UIAlertView alloc]
                              initWithTitle: self.tripTitle.text
                              message: @"Error: Changes could not be saved."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [saved show];
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [UIView beginAnimations:nil context:NULL]; // animate the following:
    // move to new location
    
    if(orientation == 0)
    {
        [self.view setFrame:CGRectMake(0,-60,_rectangle.size.width,_rectangle.size.height)];
    }
    else if(orientation == UIInterfaceOrientationPortrait)
    {
        [self.view setFrame:CGRectMake(0,-60,_rectangle.size.width,_rectangle.size.height)];
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft)
    {
        [self.view setFrame:CGRectMake(0,-250,_rectangle.size.height,_rectangle.size.width)];
    }
    else if(orientation == UIInterfaceOrientationLandscapeRight)
    {
        [self.view setFrame:CGRectMake(0,-250,_rectangle.size.height,_rectangle.size.width)];
    }
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [UIView beginAnimations:nil context:NULL];
    if(orientation == 0)
    {
        [self.view setFrame:CGRectMake(0,0,_rectangle.size.width,_rectangle.size.height)];
    }
    else if(orientation == UIInterfaceOrientationPortrait)
    {
        [self.view setFrame:CGRectMake(0,0,_rectangle.size.width,_rectangle.size.height)];
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft)
    {
        [self.view setFrame:CGRectMake(0,0,_rectangle.size.height,_rectangle.size.width)];
    }
    else if(orientation == UIInterfaceOrientationLandscapeRight)
    {
        [self.view setFrame:CGRectMake(0,0,_rectangle.size.height,_rectangle.size.width)];
    }
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    
}

@end

