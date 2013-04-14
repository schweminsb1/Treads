//
//  TripBrowser.h
//  treads
//
//  Created by keavneyrj1 on 3/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Trip.h"

#import "TripBrowserCell.h"

@interface TripBrowser : UIView

- (void)setBrowserData:(NSArray*)newSortedData forTarget:(NSObject*)newTarget withAction:(SEL)newListSelectAction;

- (void)clearAndWait;

@property (nonatomic) TripBrowserCellStyle cellStyle;

- (void)refreshWithNewImages;

@end
