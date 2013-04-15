//
//  TripBrowserCell.h
//  treads
//
//  Created by keavneyrj1 on 3/18/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TripBrowser.h"

@class Trip;

@interface TripBrowserCell : UITableViewCell

@property SEL deletefrom;

+ (int)heightForCellStyle:(TripBrowserCellStyle)cellStyle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(TripBrowserCellStyle)cellStyle;

@property (readonly) TripBrowserCellStyle cellStyle;

@property (assign, nonatomic) Trip* displayTrip;
@property TripBrowser * delegate;
@end
