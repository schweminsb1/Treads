//
//  TripBrowser.h
//  treads
//
//  Created by keavneyrj1 on 3/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Trip.h"

@class User;

@interface TripBrowser : UIView

typedef enum {TripBrowserCell3x4, TripBrowserCell4x4, TripBrowserCell6x2, TripBrowserCell5x1, TripBrowserCell4x1, ProfileBrowserCell5x1} TripBrowserCellStyle;

- (void)setBrowserData:(NSArray*)newSortedData withCellStyle:(TripBrowserCellStyle)cellStyle forTarget:(NSObject*)newTarget withAction:(SEL)newListSelectAction;

@property (copy, nonatomic) NSString* filterString;

- (void)clearAndWait;

- (void)refreshWithNewImages;

- (void)respondToSelectAtRow:(int)row;

@property (copy) void(^sendToggleFollowRequestForUser)(User* user);

- (void)toggleFollowForUser:(User*)user;

@end
