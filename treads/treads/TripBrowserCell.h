//
//  TripBrowserCell.h
//  treads
//
//  Created by keavneyrj1 on 3/18/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trip;

@interface TripBrowserCell : UITableViewCell

typedef enum {TripBrowserCell3x4, TripBrowserCell6x2, TripBrowserCell5x1, TripBrowserCell4x1} TripBrowserCellStyle;

+ (int)heightForCellStyle:(TripBrowserCellStyle)cellStyle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(TripBrowserCellStyle)cellStyle;

@property (readonly) TripBrowserCellStyle cellStyle;

@property (assign, nonatomic) Trip* displayTrip;

@end
