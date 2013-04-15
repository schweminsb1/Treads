//
//  TripBrowser.h
//  treads
//
//  Created by keavneyrj1 on 3/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Trip.h"

//#import "TripBrowserCell.h"

@interface TripBrowser : UIView

typedef enum {TripBrowserCell3x4, TripBrowserCell4x4, TripBrowserCell6x2, TripBrowserCell5x1, TripBrowserCell4x1, ProfileBrowserCell5x1} TripBrowserCellStyle;

- (void)setBrowserData:(NSArray*)newSortedData withCellStyle:(TripBrowserCellStyle)cellStyle forTarget:(NSObject*)newTarget withAction:(SEL)newListSelectAction;

- (void)clearAndWait;

//@property (nonatomic) TripBrowserCellStyle cellStyle;

- (void)refreshWithNewImages;



@end
