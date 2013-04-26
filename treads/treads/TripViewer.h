//
//  TripViewer.h
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trip;
@class TripLocation;

@interface TripViewer : UIView

- (void)setViewerTrip:(Trip*)newTrip enableEditing:(BOOL)canEditTrip;
- (Trip*)viewerTrip;
- (void)displayTripLoadFailure;

- (BOOL)editingEnabled;
- (void)setEditingEnabled:(BOOL)canEditTrip;

- (void)clearChangesFlag;
- (BOOL)changesWereMade;

- (Trip*)getViewerTrip;
- (void)prepareForExit;
- (void)didExit;

- (void)clearAndWait;

- (void)refreshWithNewHeader;
- (void)refreshWithNewImages;

@property (copy) void(^refreshTitle)();
@property (copy) void(^sendNewLocationRequest)(void(^onSuccess)(TripLocation*));
@property (copy) void(^sendNewImageRequest)(void(^onSuccess)(UIImage*));
@property (copy) void(^sendViewLocationRequest)(TripLocation* location);
@property (copy) void(^sendViewProfileRequest)(int profileID);
@end
