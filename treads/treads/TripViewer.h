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
- (Trip*)viewerTrip;
- (void)displayTripLoadFailure;

- (BOOL)editingEnabled;
- (void)setEditingEnabled:(BOOL)canEditTrip;

- (BOOL)changesWereMade;

- (Trip*)getViewerTrip;

- (void)clearAndWait;

@end
