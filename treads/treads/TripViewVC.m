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
#import "CameraService.h"
#import "LocationPickerVC.h"

#import "TripViewer.h"

@interface TripViewVC()<UINavigationBarDelegate>

@property TripService* tripService;
@property int tripID;
@property (strong) TripViewer* viewer;
@property (strong) UIBarButtonItem* tripEditButton;
@property (strong) UIBarButtonItem* backButton;
@property LocationService * locationService;

@end

@implementation TripViewVC {
    NSString* baseTitle;
    NSString* previousViewTitle;
    CameraService* cameraService;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil backTitle:(NSString *)backTitle tripService:(TripService *)myTripService tripID:(int)myTripID LocationService:(LocationService *) myLocationService
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tripService = myTripService;
        self.tripID = myTripID;
        previousViewTitle = backTitle;
        _locationService=myLocationService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cameraService = [[CameraService alloc] init];
    
    //set up browser
    self.viewer = [[TripViewer alloc] initWithFrame:self.viewerWindow.bounds];
    self.viewer.sendNewLocationRequest = ^(void(^onSuccess)(TripLocation*)) {
        if (YES) {
            //Create Location Picker
            //make it a popover
            //on cell selection call the dismiss popover
            //in the dismiss popover call block
            //pass the location here,
            //fill the new TripLocation here
            LocationPickerVC * picker= [[LocationPickerVC alloc]initWithStyle:UITableViewStylePlain withLocationService:_locationService];
            
            
            TripLocation* location;
            onSuccess(location);
        }
    };
    TripViewVC* __weak _self = self;
    CameraService* __weak _cameraService = cameraService;
    self.viewer.sendNewImageRequest = ^(void(^onSuccess)(UIImage*)) {
        [_cameraService showImagePickerFromViewController:_self onSuccess:^(UIImage* image) {
            onSuccess(image);
        }];
    };
    [self.viewer setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.viewerWindow addSubview: self.viewer];
    
    //set up back button
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:previousViewTitle style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.viewer clearAndWait];
    if (self.tripID == [Trip UNDEFINED_TRIP_ID]) {
        //create a new trip and place user into editing mode
        Trip* trip = [[Trip alloc] init];
        trip.tripID = [Trip UNDEFINED_TRIP_ID];
        trip.userID = -1;
        trip.name = @"New Trip";
        trip.description = @"Trip Description";
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
            self.tripEditButton = [[UIBarButtonItem alloc] initWithTitle:(returnedTrip.tripID == [Trip UNDEFINED_TRIP_ID]?@"Preview":@"Edit") style:UIBarButtonItemStyleBordered target:self action:@selector(tapEditButton:)];
            self.navigationItem.rightBarButtonItem = self.tripEditButton;
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
}

- (void)goBack:(id)sender
{
    [self.viewer prepareForExit];
    if ([self.viewer getViewerTrip] != nil && [self.viewer changesWereMade]) {
        //save trip changes if any were made
        [self.tripService updateTrip:[self.viewer viewerTrip] forTarget:self withAction:@selector(changesSavedTo:successfully:)];
    }
    else {
        //if no changes were made or a trip is not loaded, simply pop the trip viewer
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)changesSavedTo:(NSNumber*)savedTripID successfully:(NSNumber*)wasSuccessful {
    BOOL successful = [wasSuccessful boolValue];
    if (successful) {
        int tripID = [savedTripID intValue];
        if (self.tripID != tripID) {
            [self.viewer viewerTrip].tripID = tripID;
        }
        [self.viewer clearChangesFlag];
        
        UIAlertView *saved = [[UIAlertView alloc]
                              initWithTitle: [self.viewer viewerTrip].name
                              message: @"Changes saved."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [saved show];
    }
    else {
        UIAlertView *saved = [[UIAlertView alloc]
                              initWithTitle: [self.viewer viewerTrip].name
                              message: @"Error: Changes could not be saved."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [saved show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
