//
//  TripViewer.h
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trip;

@interface TripViewer : UIView

- (void)setViewerTrip:(Trip*)newTrip enableEditing:(BOOL)canEditTrip;
- (void)displayTripLoadFailure;

- (Trip*)getViewerTrip;

- (void)clearAndWait;

@end
