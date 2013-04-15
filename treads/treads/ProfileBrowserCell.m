//
//  ProfileBrowserCell.m
//  treads
//
//  Created by keavneyrj1 on 4/14/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "ProfileBrowserCell.h"

#import "User.h"

@interface ProfileBrowserCell()

@property (readwrite) TripBrowserCellStyle cellStyle;

@end

@implementation ProfileBrowserCell {
    BOOL layoutDone;
    UIView* subView;
    UILabel* tripOwnerLabel;
    UILabel* tripNameLabel;
    UILabel* tripDatesLabel;
    UILabel* tripContentLabel;
    UIImageView* profilePictureView;
    UIImageView* tripFeaturedImageView;
}

+ (int)heightForCellStyle:(TripBrowserCellStyle)cellStyle
{
    if (cellStyle == ProfileBrowserCell5x1) {return 110;}
    return 0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(TripBrowserCellStyle)cellStyle
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self layoutSubviews];
        layoutDone = NO;
        self.cellStyle = cellStyle;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!layoutDone) {
        //add subviews if layout has not been set
        [self createAndAddSubviews];
        layoutDone = YES;
    }
    
    if (self.cellStyle == ProfileBrowserCell5x1) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-275, 8, 550, 110)];
    }
}

- (void)createAndAddSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    //set frame layout based on style enum
    if (self.cellStyle == ProfileBrowserCell5x1) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 10, 260, 34)];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 41, 260, 25)];
        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 64, 260, 18)];
        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 80, 260, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(330, 0, 220, 110)];
    }
    
    subView = [[UIView alloc] init];
    subView.backgroundColor = [AppColors mainBackgroundColor];
    [self addSubview:subView];
    
    tripOwnerLabel.backgroundColor = [UIColor clearColor];
    tripOwnerLabel.font = [UIFont boldSystemFontOfSize: 28];
    tripOwnerLabel.textColor = [AppColors mainTextColor];
    tripOwnerLabel.textAlignment = NSTextAlignmentLeft;
    tripOwnerLabel.adjustsFontSizeToFitWidth = YES;
    tripOwnerLabel.text = @"TEST";
    
    tripNameLabel.backgroundColor = [UIColor clearColor];
    tripNameLabel.font = [UIFont systemFontOfSize: 19];
    tripNameLabel.textColor = [AppColors mainTextColor];
    tripNameLabel.textAlignment = NSTextAlignmentLeft;
    tripNameLabel.adjustsFontSizeToFitWidth = YES;
    
    tripDatesLabel.backgroundColor = [UIColor clearColor];
    tripDatesLabel.font = [UIFont systemFontOfSize: 12];
    tripDatesLabel.textColor = [AppColors secondaryTextColor];
    tripDatesLabel.textAlignment = NSTextAlignmentLeft;
    tripDatesLabel.adjustsFontSizeToFitWidth = YES;
    
    tripContentLabel.backgroundColor = [UIColor clearColor];
    tripContentLabel.font = [UIFont systemFontOfSize: 12];
    tripContentLabel.textColor = [AppColors secondaryTextColor];
    tripContentLabel.textAlignment = NSTextAlignmentLeft;
    tripContentLabel.adjustsFontSizeToFitWidth = YES;
    
    profilePictureView.backgroundColor = [UIColor lightGrayColor];
    profilePictureView.contentMode = UIViewContentModeScaleAspectFill;
    profilePictureView.clipsToBounds = YES;
    
    tripFeaturedImageView.backgroundColor = [UIColor lightGrayColor];
    tripFeaturedImageView.contentMode = UIViewContentModeScaleAspectFill;
    tripFeaturedImageView.clipsToBounds = YES;
    
    [subView addSubview:tripOwnerLabel];
    [subView addSubview:tripNameLabel];
    [subView addSubview:tripDatesLabel];
    [subView addSubview:tripContentLabel];
    [subView addSubview:profilePictureView];
//    [subView addSubview:tripFeaturedImageView];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.bounds = subView.bounds;
    bgColorView.frame = subView.frame;
    [bgColorView setBackgroundColor:[AppColors toolbarColor]];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setDisplayProfile:(User*)displayProfile
{
    if (!layoutDone) {
        [self layoutSubviews];
        //[self setNeedsLayout];
    }
    tripOwnerLabel.text = [NSString stringWithFormat:@"%@ %@", displayProfile.fname, displayProfile.lname];
    tripNameLabel.text = [NSString stringWithFormat:@"Trips: %d", displayProfile.tripCount];
//    tripDatesLabel.text = @"1/1/2013 - 12/31/2013";
//    tripContentLabel.text = @"P213 C87";
    tripFeaturedImageView.image = displayProfile.coverImage;
    profilePictureView.image = displayProfile.profileImage;
}

@end
