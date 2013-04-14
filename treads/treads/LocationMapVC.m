//
//  LocationMapVC.m
//  treads
//
//  Created by Anthony DeLeone on 4/13/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

// Code referenced for this view
// http:stackoverflow.com/questions/3959994/how-to-add-a-push-pin-to-a-mkmapviewios-when-touching/3960754#3960754

#import "LocationMapvc.h"

@interface LocationMapVC ()
@property MapPinAnnotation * locationPin;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (strong) UIBarButtonItem* doneButton;
@property CLLocationCoordinate2D placedLocation;
@end

@implementation LocationMapVC



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
}
- (void)doneAddingLocation
{
    if(_placedLocation.latitude != -500 && _placedLocation.longitude != -500)
    {
         self.locationMapSuccess(_placedLocation);
        [self.navigationController popViewControllerAnimated:YES];
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
    
}
//void(^onSuccessLocation)(CLLocationCoordinate2D)location=^
//{
//        location = _placedLocation;
//        return _placedLocation;
//};
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
