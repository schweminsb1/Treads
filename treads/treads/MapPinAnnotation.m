//
//  MapPinAnnotation.m
//  project1
//
//  Created by Sam Schwemin on 2/27/13.
//  Copyright (c) 2013 gcc. All rights reserved.
//

#import "MapPinAnnotation.h"
#import <MapKit/MapKit.h>
@implementation MapPinAnnotation




- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;
{
    self = [super init];
    if (self)
    {
        _coordinate = location;
        _title = placeName;
        _subtitle = description;
    }
    return self;
}


- (id)initWithLocation:(Location *) location
{
    
    self = [super init];
    if (self)
    {
        _coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        _title = location.title;
        _subtitle = location.description;
        _location=location;
        _tripCount=0;
    }
    
    return self;
    
}
@end
