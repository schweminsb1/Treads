//
//  ProfileBrowserCell.h
//  treads
//
//  Created by keavneyrj1 on 4/14/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TripBrowser.h"

@class User;

@interface ProfileBrowserCell : UITableViewCell

+ (int)heightForCellStyle:(TripBrowserCellStyle)cellStyle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(TripBrowserCellStyle)cellStyle;

@property (readonly) TripBrowserCellStyle cellStyle;

@property (assign, nonatomic) User* displayProfile;

@property TripBrowser* delegate;
@property NSIndexPath* indexPath;

@end
