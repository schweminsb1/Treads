//
//  MapsVC.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "MapsVC.h"
#import "MapPinAnnotation.h"


@interface MapsVC ()

@end

@implementation MapsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self) {
        self.title = NSLocalizedString(@"Maps", @"Maps");
        self.tabBarItem.image = [UIImage imageNamed:@"map-pin.png"];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    // Do any additional setup after loading the view from its nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation* myLocation = locations[0];
    MKCoordinateSpan span;
    span.latitudeDelta = .5;
    span.longitudeDelta = .5;
    
    MKCoordinateRegion region;
    region.center = myLocation.coordinate;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    [self.locationManager stopUpdatingLocation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//This function returns the View that will contain the small location view info, tutorial here
// http://www.altinkonline.nl/tutorials/xcode/corelocation/add-a-button-to-an-annotation/
//
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    // reuse a view, if one exists
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    // create a new view else
    if (!aView) {
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
    }
    
    // now configure the view
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [(UIButton*)aView.rightCalloutAccessoryView addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    [aView setRightCalloutAccessoryView:rightButton];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [leftButton setTitle:annotation.title forState:UIControlStateNormal];
    [aView setLeftCalloutAccessoryView:leftButton];
    
    aView.canShowCallout = YES;
    aView.enabled = YES;
    [aView setDraggable:YES];
    
    
    aView.centerOffset = CGPointMake(0, -20);
    
    return aView;
}

//this function handles what happens if one of the controls on the view is touched
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){
        // Do your thing when the detailDisclosureButton is touched
        UIViewController *mapDetailViewController = [[UIViewController alloc] init];
        [[self navigationController] pushViewController:mapDetailViewController animated:YES];
        
    } else if([(UIButton*)control buttonType] == UIButtonTypeInfoDark) {
        // Do your thing when the infoDarkButton is touched
        
        NSLog(@"infoDarkButton for longitude: %f and latitude: %f",
              [(MapPinAnnotation*)[view annotation] coordinate].longitude,
              [(MapPinAnnotation*)[view annotation] coordinate].latitude);
    }
}

@end
