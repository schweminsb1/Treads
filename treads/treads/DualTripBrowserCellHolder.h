//
//  DualTripBrowserCellHolder.h
//  treads
//
//  Created by keavneyrj1 on 4/23/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TripBrowser.H"

@class Trip;

@interface DualTripBrowserCellHolder : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(TripBrowserCellStyle)cellStyle;

@property (readonly) TripBrowserCellStyle cellStyle;

@property (assign, nonatomic) NSArray* displayTripArray;

@property (assign, nonatomic) TripBrowser* delegate;
@property (assign, nonatomic) int row;
@property (assign, nonatomic) SEL deletefrom;

@end
