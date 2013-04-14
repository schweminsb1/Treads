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
#import "TripLocation.h"
#import "TripViewer.h"
#import "CommentService.h"

@interface TripViewVC()<UINavigationBarDelegate>

@property TripService* tripService;
@property  int tripID;
@property (strong) TripViewer* viewer;
@property (strong) UIBarButtonItem* tripEditButton;
@property (strong) UIBarButtonItem* backButton;
@property LocationService * locationService;
@property LocationPickerVC * picker;
@property UINavigationController * navcontroller;
@property CommentService * commentService;
@property UserService * userService;
@end

@implementation TripViewVC {
    BOOL needsTripLoad;
    NSString* baseTitle;
    NSString* previousViewTitle;
    CameraService* cameraService;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil backTitle:(NSString *)backTitle tripService:(TripService *)myTripService tripID:(int)myTripID LocationService:(LocationService *) myLocationService withCommentService: (CommentService*) commentService withUserService:(UserService*)userService
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tripService = myTripService;
        self.tripID = myTripID;
        previousViewTitle = backTitle;
        _locationService=myLocationService;
        _commentService = commentService;
        _userService=userService;
        needsTripLoad = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cameraService = [[CameraService alloc] init];
    
    //set up browser
    self.viewer = [[TripViewer alloc] initWithFrame:self.viewerWindow.bounds];
    int tripid=_tripID;
     TripViewVC * myself= self;
    self.viewer.sendNewLocationRequest = ^(void(^onSuccess)(TripLocation*)) {
        //Create Location Picker
        //make it a popover
        //on cell selection call the dismiss popover
        //in the dismiss popover call block
        //pass the location here,
        //fill the new TripLocation here
        
        void  (^myBlock)(Location*);
        myBlock=^(Location *location)
        {
            TripLocation* locationNew= [[TripLocation alloc]init];
            locationNew.tripID= tripid;
            locationNew.locationID=[location.idField intValue];
            locationNew.locationName = location.title;
            //add new trip location to database
            onSuccess(locationNew);
        };
        
        myself.picker= [[LocationPickerVC alloc]initWithStyle:UITableViewStylePlain withLocationService:myself.locationService];
        myself.picker.returnLocationToTripView=myBlock;
        //myself.navcontroller= [[UINavigationController alloc] initWithRootViewController:myself.picker];
        
        [myself.navigationController pushViewController:myself.picker animated:YES];
    };
    TripViewVC* __weak _self = self;
    CameraService* __weak _cameraService = cameraService;
    self.viewer.sendNewImageRequest = ^(void(^onSuccess)(UIImage*)) {
        [_cameraService showImagePickerFromViewController:_self onSuccess:^(UIImage* image) {
            onSuccess(image);
        }];
    };
    self.viewer.gotolocationpage= ^(TripLocation * loc)
    {
         //
        //get location model
        CompletionWithItemsandLocation complete= ^(NSArray * items, Location * location)
        {
            Location * location1=location;
            LocationVC * locationVC= [[LocationVC alloc] initWithNibName:@"LocationVC" bundle:nil withModel:location1 withTripService:[TripService instance] withUserService:[UserService instance] imageService:[ImageService instance] withLocationService:[LocationService instance] withCommentService:[CommentService instance] withFollowService:[FollowService instance] ];
            
            [_self.navigationController pushViewController:locationVC animated:YES];
            
        };
        [_self.locationService getLocationByID:loc.locationID withLocationBlock:complete];
    };
    [self.viewer setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.viewerWindow addSubview: self.viewer];
    
    //set up back button
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:previousViewTitle style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (needsTripLoad) {
        [self.viewer clearAndWait];
        if (self.tripID == [Trip UNDEFINED_TRIP_ID]) {
            //create a new trip and place user into editing mode
            Trip* trip = [[Trip alloc] init];
            trip.tripID = [Trip UNDEFINED_TRIP_ID];
            trip.userID = -1;
            trip.name = @"New Trip";
            trip.description = @"Trip Description";
            trip.imageID = [TripLocationItem UNDEFINED_IMAGE_ID];
            [self dataHasLoaded:@[trip]];
        }
        else {
            //load the trip from the database
            [self.tripService getTripWithID:self.tripID forTarget:self withAction:@selector(dataHasLoaded:)];
        }
    }
}

- (void)dataHasLoaded:(NSArray*)newData
{
    if (newData.count == 1) {
        Trip* returnedTrip = (Trip*)newData[0];
        needsTripLoad = NO;
        
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
        
        //request trip images
        [self.tripService getHeaderImageForTrip:returnedTrip forTarget:self withCompleteAction:@selector(refreshWithNewHeader)];
        [self.tripService getImagesForTrip:returnedTrip forTarget:self withRefreshAction:@selector(refreshWithNewImages) withCompleteAction:nil];
    }
    else {
        [self.viewer displayTripLoadFailure];
    }
}

- (void)refreshWithNewHeader
{
    [self.viewer refreshWithNewHeader];
}

- (void)refreshWithNewImages
{
    [self.viewer refreshWithNewImages];
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
//        [self.tripService updateTrip:[self.viewer viewerTrip] forTarget:self withAction:@selector(changesSavedTo:successfully:)];
        [self.tripService updateNewImagesForTrip:[self.viewer viewerTrip] forTarget:self withCompleteAction:@selector(imagesWereUploaded)];
    }
    else {
        //if no changes were made or a trip is not loaded, simply pop the trip viewer
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)imagesWereUploaded
{
    [self.tripService updateTrip:[self.viewer viewerTrip] forTarget:self withAction:@selector(changesSavedTo:successfully:)];
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
