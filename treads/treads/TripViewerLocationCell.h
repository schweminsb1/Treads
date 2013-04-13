//
//  TripViewerLocationCell.h
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TripLocation;

@interface TripViewerLocationCell : UITableViewCell

@property (assign, nonatomic) TripLocation* tripLocation;

@property (copy) BOOL(^editingEnabled)();
@property (copy) void(^markChangeMade)();

@property (copy) void(^sendNewLocationRequest)();
@property (copy) void(^sendDeleteLocationRequest)();
@property (copy) void(^sendMoveForwardRequest)();
@property (copy) void(^sendMoveBackwardRequest)();
- (void)changeLocation:(int)newLocationID;
-(void)gotoLocationPage;
@property (copy) void(^gotolocationpage)(TripLocation* loc);
@property (copy) void(^sendNewImageRequest)(void(^onSuccess)(UIImage*));

@end
