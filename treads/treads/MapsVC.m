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

@property NSMutableArray * locationsInView;
@property NSMutableArray * locaionsTotal;

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
    
    MapPinAnnotation * testpin= [[MapPinAnnotation alloc]initWithCoordinates:myLocation.coordinate placeName:@"Test" description:@"The test"];
    [self.mapView addAnnotation:testpin];
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
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    // create a new view else
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
    }
    UIImage *img = [UIImage imageNamed:@"default_thumb.png"];
    aView.image=img;
    aView.pinColor = MKPinAnnotationColorGreen;
    // now configure the view

    aView.canShowCallout = NO;
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

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    LocationSmallViewController *ycvc = [[LocationSmallViewController alloc] init];
                                       UIPopoverController *poc = [[UIPopoverController alloc] initWithContentViewController:ycvc];
                                   
                                       //hold ref to popover in an ivar
                                       self.callout = poc;
                                       
                                       //size as needed
                                       poc.popoverContentSize = CGSizeMake(320, 400);
                                       
                                       //show the popover next to the annotation view (pin)
                                       [poc presentPopoverFromRect:view.bounds inView:view 
                                          permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                                       
                                 
    
}
-(void)mapView:(MKMapView *)mapView didDeSelectAnnotationView:(MKAnnotationView *)view
{
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //Do search on searchbar
    //set mapview center focus on pin with location the searchbar most matches
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

@end
