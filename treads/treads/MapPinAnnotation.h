//
//  MapPinAnnotation.h
//  project1
//
//  Created by Sam Schwemin on 2/27/13.
//  Copyright (c) 2013 gcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Location.h"
@interface MapPinAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* subtitle;
@property (nonatomic) Location * location;
@property (nonatomic) int tripCount;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;
- (id)initWithLocation:(Location *) location;



@end
