//
//  TripViewerLocationCell.h
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TripLocation;
@class TripLocationItem;

@interface TripViewerLocationCell : UITableViewCell

@property (assign, nonatomic) TripLocation* tripLocation;

@property (copy) BOOL(^editingEnabled)();
@property (copy) void(^markChangeMade)();

@property (copy) void(^sendAddLocationRequest)();
@property (copy) void(^sendNewLocationRequest)();
@property (copy) void(^sendDeleteLocationRequest)();
@property (copy) void(^sendMoveForwardRequest)();
@property (copy) void(^sendMoveBackwardRequest)();

@property (copy) void(^sendTripImageIDRequest)(TripLocationItem* locationItem);

- (void)changeLocation:(int)newLocationID withName:(NSString*)name;
- (void)gotoLocationPage;

@property (copy) void(^sendViewLocationRequest)(TripLocation* location);
@property (copy) void(^sendNewImageRequest)(void(^onSuccess)(UIImage*));

@end
