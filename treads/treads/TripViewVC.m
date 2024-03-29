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
#import "FavoriteService.h"
#import "TreadsSession.h"

@interface TripViewVC()<UINavigationBarDelegate>

@property TripService* tripService;
@property  int tripID;
@property (strong) TripViewer* viewer;
@property (strong) UIView* waitView;
@property (strong) UIBarButtonItem* tripEditButton;
@property (strong) UIBarButtonItem* backButton;
@property (strong) UIBarButtonItem* favoriteButton;
@property LocationService * locationService;
@property LocationPickerVC * picker;
@property UINavigationController * navcontroller;
@property CommentService * commentService;
@property UserService * userService;
@property int favoriteID;
@property         CGRect rectangle;
@end

@implementation TripViewVC {
    BOOL needsTripLoad;
    BOOL tappedSave;
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
        self.favoriteID = -1;
        self.showDraft = NO;
        tappedSave = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
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
        myself.picker.tripViewerReturnDelegate=myself;
        [myself.navigationController pushViewController:myself.picker animated:YES];
    };
    TripViewVC* __weak _self = self;
    CameraService* __weak _cameraService = cameraService;
    self.viewer.sendNewImageRequest = ^(void(^onSuccess)(UIImage*)) {
        [_cameraService showImagePickerFromViewController:_self onSuccess:^(UIImage* image) {
            onSuccess(image);
        }];
    };
    self.viewer.sendViewLocationRequest= ^(TripLocation * loc)
    {
         //
        //get location model
        CompletionWithItemsandLocation complete= ^(NSArray * items, Location * location)
        {
            Location * location1=location;
            LocationVC * locationVC= [[LocationVC alloc] initWithNibName:@"LocationVC" bundle:nil withModel:location1 withTripService:[TripService instance] withUserService:[UserService instance] imageService:[ImageService instance] withLocationService:[LocationService instance] withCommentService:[CommentService instance] withFollowService:[FollowService instance] ];
            [_self.viewer setEditingEnabled:NO];
            [_self setTitleBar:nil];
            [_self.navigationController pushViewController:locationVC animated:YES];
            
        };
        [_self.locationService getLocationByID:loc.locationID withLocationBlock:complete];
    };
    self.viewer.sendViewProfileRequest = ^(int profileID) {
        [_self.viewer setEditingEnabled:NO];
        [_self showProfileWithID:profileID];
    };
    self.viewer.refreshTitle = ^() {
        [_self setBaseTitle:[_self.viewer getViewerTrip]];
        if ([_self.viewer editingEnabled]) {[_self setTitleBar:@"Editing"];}
        else {[_self setTitleBar:nil];}
    };
    [self.viewer setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.viewerWindow addSubview: self.viewer];
    
    //set up back button
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:previousViewTitle style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    //set up waiting view
    self.waitView = [[UIView alloc] initWithFrame:self.viewerWindow.frame];
    self.waitView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.waitView.hidden = YES;
    self.waitView.userInteractionEnabled = YES;
    self.waitView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.viewerWindow addSubview:self.waitView];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (needsTripLoad) {
        [self.viewer clearAndWait];
        tappedSave = NO;
        if (self.tripID == [Trip UNDEFINED_TRIP_ID]) {
            //create a new trip and place user into editing mode
            Trip* trip = [[Trip alloc] init];
            trip.tripID = [Trip UNDEFINED_TRIP_ID];
            trip.userID = [TreadsSession instance].treadsUserID;
            trip.name = @"";
            trip.username = [NSString stringWithFormat:@"%@ %@", [TreadsSession instance].fName, [TreadsSession instance].lName];
            trip.profileImageID = [TreadsSession instance].profilePhotoID;
            trip.description = @"";
            trip.imageID = [TripLocationItem UNDEFINED_IMAGE_ID];
            trip.published = 0;
            [self dataHasLoaded:@[trip]];
        }
        else {
            //load the trip from the database
            if (self.showDraft) {
                [self.tripService getDraftWithID:self.tripID forTarget:self withAction:@selector(dataHasLoaded:)];
            }
            else {
                [self.tripService getTripWithID:self.tripID forTarget:self withAction:@selector(dataHasLoaded:)];
            }
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
        if ([self.viewer editingEnabled]) {[self setTitleBar:@"Editing"];}
        else {[self setTitleBar:nil];}
        
        //if the user has editing rights, add the nav bar item
        if (returnedTrip.userID == [TreadsSession instance].treadsUserID) { //can edit
            //set up new trip button and attach to navigation controller
            self.tripEditButton = [[UIBarButtonItem alloc] initWithTitle:(returnedTrip.tripID == [Trip UNDEFINED_TRIP_ID]?@"Preview":@"Edit") style:UIBarButtonItemStyleBordered target:self action:@selector(tapEditButton:)];
            self.navigationItem.rightBarButtonItem = self.tripEditButton;
        }
        else {
            self.favoriteButton = [[UIBarButtonItem alloc] initWithTitle:@"Favorite" style:UIBarButtonItemStyleBordered target:self action:@selector(favorite:)];
            self.navigationItem.rightBarButtonItem = self.favoriteButton;
            [[FavoriteService instance] getMyFavs:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(favsLoaded:)];
        }
        
        //request trip images
        [self.tripService getHeaderImageForTrip:returnedTrip forTarget:self withCompleteAction:@selector(refreshWithNewHeader)];
        [self.tripService getImagesForTrip:returnedTrip forTarget:self withRefreshAction:@selector(refreshWithNewImages) withCompleteAction:nil];

    }
    else {
        [self.viewer displayTripLoadFailure];
    }
}

- (void)favsLoaded:(NSArray*)newData  {
    [self.favoriteButton setTitle:@"Favorite"];
    self.favoriteID = -1;
    
    for (int x = 0; x < newData.count; x++) {
        int y = [((NSString*)newData[x][@"tripID"])intValue];
        if (self.tripID == y) {
            [self.favoriteButton setTitle:@"Unfavorite"];
            self.favoriteID = [((NSString*)newData[x][@"id"])intValue];
            break;
        }
    }
    
    self.favoriteButton.enabled = true;

}

- (void)favorite:(id)tripID {
    self.favoriteButton.enabled = false;
    if(self.favoriteID < 0) {
        [[FavoriteService instance] addFav:[TreadsSession instance].treadsUserID withTripID:self.tripID fromTarget:self withReturn:@selector(favSuccess)];
    }
    else {
        [[FavoriteService instance]deleteFav:[NSString stringWithFormat:@"id = %i", self.favoriteID] fromTarget:self withReturn:@selector(favSuccess)];
    }
}

- (void) favSuccess {
    [[FavoriteService instance] getMyFavs:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(favsLoaded:)];
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
    baseTitle = [NSString stringWithFormat:@"%@: %@", trip.username, trip.name];
}

- (void)setTitleBar:(NSString*)appendedTitle
{
    if (appendedTitle && ![appendedTitle isEqual: @""]) {
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
    if (!tappedSave) {
        tappedSave = YES;
        [self.viewer prepareForExit];
        if ([self.viewer getViewerTrip] != nil && [self.viewer getViewerTrip].userID == [TreadsSession instance].treadsUserID && [self.viewer changesWereMade]) {
            //save trip changes if any were made
            [self.tripService updateNewImagesForTrip:[self.viewer viewerTrip] forTarget:self withCompleteAction:@selector(imagesWereUploaded)];
            self.waitView.hidden = NO;
        }
        else {
            //if no changes were made or a trip is not loaded, simply pop the trip viewer
            [self.viewer didExit];
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
}

- (void)imagesWereUploaded
{
    [self.tripService updateTrip:[self.viewer viewerTrip] forTarget:self withAction:@selector(changesSavedTo:successfully:)];
}

- (void)changesSavedTo:(NSNumber*)savedTripID successfully:(NSNumber*)wasSuccessful {
    BOOL successful = [wasSuccessful boolValue];
    self.waitView.hidden = YES;
    [self.viewer didExit];
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
                              message: @"Connection error: Changes could not be saved."
                              delegate: self
                              cancelButtonTitle:@"Discard Changes"
                              otherButtonTitles:@"Keep Editing", nil];
        [saved show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        tappedSave = NO;
    }
}

- (void)showProfileWithID:(int)profileID
{
    [self.viewer setEditingEnabled:NO];
    [self setTitleBar:nil];
    ProfileVC* profilevc= [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil tripService:_tripService userService:_userService imageService:[ImageService instance] isUser:NO userID:profileID withLocationService:_locationService withCommentService:_commentService withFollowService:[FollowService instance]];
    [self.navigationController pushViewController:profilevc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)keyboardDidShow:(NSNotification *)notification
{
    self.rectangle = self.view.bounds;
    
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
        [self.view setFrame:CGRectMake(0,-90,_rectangle.size.width,_rectangle.size.height)];
    }
    else if(orientation == UIInterfaceOrientationLandscapeRight)
    {
        [self.view setFrame:CGRectMake(0,-90,_rectangle.size.width,_rectangle.size.height)];
    }
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    self.rectangle = self.view.bounds;
    
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
        [self.view setFrame:CGRectMake(0,0,_rectangle.size.width,_rectangle.size.height)];
    }
    else if(orientation == UIInterfaceOrientationLandscapeRight)
    {
        [self.view setFrame:CGRectMake(0,0,_rectangle.size.width,_rectangle.size.height)];
    }
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    
}

@end
