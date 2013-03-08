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


@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;
{
    self = [super init];
    if (self)
    {
        coordinate = location;
        title = placeName;
        subtitle = description;
    }
    
    return self;
}

@end
