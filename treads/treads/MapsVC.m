//
//  MapsVC.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "MapsVC.h"
#import "MapPinAnnotation.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "CommentService.h"
#import "LoginVC.h"
#import "TripLocationService.h"
#import "ProfileVC.h"
#import "ImageService.h"
#import "FollowService.h"
#import "LocationService.h"
#import "UserService.h"
#import "TripService.h"
#import "ImageService.h"


@interface MapsVC ()
@property NSMutableArray * locationsInView;
@property NSMutableArray * locationsTotal;
@property Location * currentLocation;
@property TripLocationService * tripLocationService;
@property int locationCounter;
@property __block int locationTotal;
@property (nonatomic,copy)MSReadQueryBlock recieveAll;
@property UIPopoverController* poc;
@end

@implementation MapsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withLocationService:(LocationService *) locationService withCommentService: (CommentService*) commentService withTripLocationService:(TripLocationService*) tripLocationService withUserService:(UserService*)userService{
    if (self) {
        _PINLIMIT=50;
        _locationService=locationService;
        _commentService = commentService;
        self.title = NSLocalizedString(@"Maps", @"Maps");
        self.tabBarItem.image = [UIImage imageNamed:@"map-pin.png"];
        _locationsTotal = [[NSMutableArray alloc]init];
        _locationsInView = [[NSMutableArray alloc]init];
        _tripLocationService=tripLocationService;
        _locationCounter=0;
        _locationTotal=0;
        _userService=userService;
    }
    return self;
}
- (void) viewDidLoad
{
        [super viewDidLoad];
            //recieve a bunch of Location models
        //create a bunch of pins
        // add the pins to locations Total
        //add the pins to the mapView
    //end block;
  
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    __block MapsVC* myself=self;
CompletionWithItemsandLocation comp= ^(NSArray * items, Location * location)
    {
        myself.locationCounter+=1;
        MapPinAnnotation * locationPin= [[MapPinAnnotation alloc] initWithLocation:location];
        locationPin.tripCount = items.count;
        [_locationsTotal addObject:locationPin];
        CGPoint nePoint = CGPointMake(self.mapView.bounds.origin.x + _mapView.bounds.size.width, _mapView.bounds.origin.y);
        CGPoint swPoint = CGPointMake((self.mapView.bounds.origin.x), (_mapView.bounds.origin.y + _mapView.bounds.size.height));
        //Then transform those point into lat,lng values
        CLLocationCoordinate2D neCoord;
        neCoord = [_mapView convertPoint:nePoint toCoordinateFromView:_mapView];
        CLLocationCoordinate2D swCoord;
        swCoord = [_mapView convertPoint:swPoint toCoordinateFromView:_mapView];
        
        if(_locationCounter == _locationTotal)
        {
            _locationsTotal = [NSMutableArray arrayWithArray:[_locationsTotal sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                int first = ((MapPinAnnotation*)a).tripCount;
                int second = ((MapPinAnnotation*)b).tripCount;
                return [[NSNumber numberWithInt: first ]compare:[NSNumber numberWithInt: second ]];
            }]];
             for(int i=0; i< _locationsTotal.count && i<_PINLIMIT; i++)
             {
                 double lat=((MapPinAnnotation*)_locationsTotal[i]).location.latitude;
                 double lon=((MapPinAnnotation*)_locationsTotal[i]).location.longitude;
                    if(neCoord.latitude>lat && swCoord.latitude<lat && neCoord.longitude>lon && swCoord.longitude<lon)
                    {
                        [self.mapView addAnnotation:_locationsTotal[i]];
                    }
             }
        }
    };
    
     _recieveAll= ^(NSArray *items, NSInteger totalCount, NSError *error)
    {
        myself.locationTotal=items.count;
        for( int i=0; i< items.count; i++)
        {
            Location * location= [[Location alloc] init];
            location.idField= items[i][@"LocationID"];
            location.title= items[i][@"name"];
            location.description= items[i][@"description"];
            NSString * latstring= items[i][@"latitude"];
            NSString * lonstring= items[i][@"longitude"];
            location.latitude = [latstring floatValue];
            location.longitude= [lonstring floatValue];
            [myself.tripLocationService getTripLocationWithLocation:location withCompletion:comp];
                       //MapPinAnnotation * locationPin= [[MapPinAnnotation alloc] initWithLocation:location];
            //[_locationsTotal addObject:locationPin];
        }
        //add trip count
        
        CGPoint nePoint = CGPointMake(myself.mapView.bounds.origin.x + myself.mapView.bounds.size.width, myself.mapView.bounds.origin.y);
        CGPoint swPoint = CGPointMake((myself.mapView.bounds.origin.x), (myself.mapView.bounds.origin.y + myself.mapView.bounds.size.height));
        
        //Then transform those point into lat,lng values
        CLLocationCoordinate2D neCoord;
        neCoord = [myself.mapView convertPoint:nePoint toCoordinateFromView:myself.mapView];
        
        CLLocationCoordinate2D swCoord;
        swCoord = [myself.mapView convertPoint:swPoint toCoordinateFromView:myself.mapView];
     /* 
      for(int i=0; i< _locationsTotal.count; i++)
        {
            double lat=((MapPinAnnotation*)_locationsTotal[i]).location.latitude;
            double lon=((MapPinAnnotation*)_locationsTotal[i]).location.longitude;
            //double topcornerlat=neCoord.latitude;
            //double bottomcornerlat=swCoord.latitude;
            //double topcornerlon=neCoord.longitude;
            //double bottomcornerlon=swCoord.longitude;
            if(neCoord.latitude>lat && swCoord.latitude<lat && neCoord.longitude>lon && swCoord.longitude<lon)
            {
                [self.mapView addAnnotation:_locationsTotal[i]];
            }
        }
      */
    };
    [_locationService getLocationsOrdered:_recieveAll];
    //[_locationService performSelectorOnMainThread:@selector(getLocationsOrdered:) withObject:recieveAll waitUntilDone:YES];
    
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
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    // create a new view else
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
    }
    UIImage *img = [UIImage imageNamed:@"default_thumb.png"];
    aView.image=img;
    aView.pinColor = MKPinAnnotationColorRed;
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
    MapPinAnnotation * thisPin= (MapPinAnnotation *)view.annotation;
    _currentLocation = thisPin.location;
    
    LocationSmallViewController *ycvc = [[LocationSmallViewController alloc] initWithNibName:@"LocationSmallViewController" bundle:nil location:thisPin.location homeController:self Service: _locationService];
    
                                        self.poc = [[UIPopoverController alloc] initWithContentViewController:ycvc];
                                   
                                       //hold ref to popover in an ivar
                                       self.callout = self.poc;
                                       
                                       //size as neededs
                                       self.poc.popoverContentSize = CGSizeMake(320, 400);
                                       
                                       //show the popover next to the annotation view (pin)
                                       [self.poc presentPopoverFromRect:view.bounds inView:view
                                          permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                                       
                                 
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self.poc dismissPopoverAnimated:YES];
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

-(void)pushLocation
{
    
    LocationVC * locationvc= [[LocationVC alloc]initWithNibName:@"LocationVC" bundle:nil withModel: _currentLocation withTripService: [TripService instance]  withUserService:[UserService instance] imageService:[ImageService instance]  withLocationService:[LocationService instance] withCommentService:[CommentService instance] withFollowService:[FollowService instance]];
    
    [self.navigationController pushViewController:locationvc animated:YES];
    [self.callout dismissPopoverAnimated:YES];
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    CGPoint nePoint = CGPointMake(self.mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
    CGPoint swPoint = CGPointMake((self.mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
    //Then transform those point into lat,lng values
    CLLocationCoordinate2D neCoord;
    neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
    CLLocationCoordinate2D swCoord;
    swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
    
    for(int i=0; i<mapView.annotations.count && i<_PINLIMIT; i++)
    {
        double lat=((MapPinAnnotation*)mapView.annotations[i]).location.latitude;
        double lon=((MapPinAnnotation*)mapView.annotations[i]).location.longitude;
        if(!(neCoord.latitude>lat && swCoord.latitude<lat && neCoord.longitude>lon && swCoord.longitude<lon))
        {//not in the current map view, remove annotation
            [mapView removeAnnotation:mapView.annotations[i]];
        }
    }
    for(int i=0; i< _locationsTotal.count; i++)//add annotations in view
    {
        double lat=((MapPinAnnotation*)_locationsTotal[i]).location.latitude;
        double lon=((MapPinAnnotation*)_locationsTotal[i]).location.longitude;
        if(neCoord.latitude>lat && swCoord.latitude<lat && neCoord.longitude>lon && swCoord.longitude<lon)
        {
            [self.mapView addAnnotation:_locationsTotal[i]];
        }
    }
    //removr all annotations not in between these points, add all annottions in between the points
}

@end
