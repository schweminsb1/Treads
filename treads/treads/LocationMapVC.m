//
//  LocationMapVC.m
//  treads
//
//  Created by Anthony DeLeone on 4/13/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

// Code referenced for this view
// http:stackoverflow.com/questions/3959994/how-to-add-a-push-pin-to-a-mkmapviewios-when-touching/3960754#3960754
// http://stackoverflow.com/questions/2473706/how-do-i-zoom-an-mkmapview-to-the-users-current-location-without-cllocationmanag
#import "LocationMapvc.h"
#import "AddLocationVC.h"
@interface LocationMapVC ()
@property MapPinAnnotation * locationPin;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (strong) CLLocationManager* locationManager;
@property (strong) UIBarButtonItem* doneButton;
@property CLLocationCoordinate2D placedLocation;
@property (strong) UIPopoverController *addLocPop;

@end

@implementation LocationMapVC

bool popNavigationStack = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _finishClicked=NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //set up new trip button and attach to navigation controller
    _placedLocation = CLLocationCoordinate2DMake(-500, -500);
    //self.navigationController.title = @"Tap"
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAddingLocation)];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .1; //user needs to press for .1 seconds
    [self.mapView addGestureRecognizer:lpgr];
    self.title = NSLocalizedString(@"Drop a Pin on the Map", @"Drop a Pin on the Map");
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

}
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* myLocation = locations[0];
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = .5; // Change these values to change the zoom
    span.longitudeDelta = .5;
    region.span = span;
    region.center = myLocation.coordinate;
    [self.mapView setRegion:region animated:YES];
    [self.locationManager stopUpdatingLocation];
}
-(void)viewDidAppear:(BOOL)animated
{
    // check if the location data has been already entered and pop the navstack again.
    if(popNavigationStack == YES)
    {
        popNavigationStack = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)doneAddingLocation
{
    if(_placedLocation.latitude != -500 && _placedLocation.longitude != -500)
    {
        
        AddLocationVC *addLocVC = [[AddLocationVC alloc]initWithCoordinates: _placedLocation];
        _addLocPop = [[UIPopoverController alloc]initWithContentViewController:addLocVC];
        _addLocPop.delegate=self;
        addLocVC.returnLocationToTripView=_returnLocationToTripView;
        popNavigationStack = YES;
        addLocVC.tripViewReturnDelegate=_tripViewReturnDelegate;
        addLocVC.delegatepopover=_addLocPop;
        addLocVC.delegate = self;
        _addLocPop.popoverContentSize = CGSizeMake(320,140);
        
        [_addLocPop presentPopoverFromRect:CGRectMake( self.view.bounds.size.width/2, self.view.bounds.size.height/2-70, 200, 200) inView:self.view permittedArrowDirections:0 animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Woah!!"
                              message: @"We need you to place a Location Pin."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    // place a pin on the map and return the coordinates
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.locationPin = [[MapPinAnnotation alloc] initWithCoordinates:touchMapCoordinate placeName:nil description:nil];
    [self.mapView addAnnotation:self.locationPin];
    _placedLocation.latitude = touchMapCoordinate.latitude;
    _placedLocation.longitude = touchMapCoordinate.longitude;
    [_mapView setRegion:MKCoordinateRegionMake(touchMapCoordinate, _mapView.region.span) animated: YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popovercontroller
{
    if(_finishClicked == YES)
    {
        [self.navigationController popToViewController:_tripViewReturnDelegate animated:YES];
        
    }
    
}
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController*)popovercontroller
{
    
    return YES;
}

@end
