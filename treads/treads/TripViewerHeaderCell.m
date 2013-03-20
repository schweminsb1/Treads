//
//  TripViewerHeaderCell.m
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewerHeaderCell.h"

#import "Trip.h"

#import "AppColors.h"

@implementation TripViewerHeaderCell {
    BOOL layoutDone;
    UIImageView* tripFeaturedImage;
    UILabel* tripOwnerLabel;
    UILabel* tripNameLabel;
    UILabel* tripDescriptionLabel;
    //UILabel* tripDatesLabel;
    //UILabel* tripContentLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        layoutDone = NO;
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
    
    self.bounds = CGRectMake(0, 0, 720, 370);
    self.backgroundColor = [AppColors mainBackgroundColor];
    
    if (layoutDone) {
        return;
    }
    
    layoutDone = YES;
    
    //for (UIView* subview in self.subviews)
    //    [subview removeFromSuperview];
    
    //self.bounds = CGRectMake(0, 0, 768, 90);
    
    tripFeaturedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 720, 240)];
    
    tripOwnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 16 + tripFeaturedImage.bounds.size.height, 680, 38)];
    tripOwnerLabel.backgroundColor = [UIColor clearColor];
    tripOwnerLabel.font = [UIFont boldSystemFontOfSize: 32];
    tripOwnerLabel.textColor = [AppColors mainTextColor];
    tripOwnerLabel.textAlignment = NSTextAlignmentLeft;
    tripOwnerLabel.adjustsFontSizeToFitWidth = YES;
    
    tripNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 52 + tripFeaturedImage.bounds.size.height, 680, 31)];
    tripNameLabel.backgroundColor = [UIColor clearColor];
    tripNameLabel.font = [UIFont systemFontOfSize: 25];
    tripNameLabel.textColor = [AppColors mainTextColor];
    tripNameLabel.textAlignment = NSTextAlignmentLeft;
    tripNameLabel.adjustsFontSizeToFitWidth = YES;
    
    tripDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 84 + tripFeaturedImage.bounds.size.height, 680, 23)];
    tripDescriptionLabel.backgroundColor = [UIColor clearColor];
    tripDescriptionLabel.font = [UIFont systemFontOfSize: 17];
    tripDescriptionLabel.textColor = [AppColors mainTextColor];
    tripDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    tripDescriptionLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:tripFeaturedImage];
    [self addSubview:tripOwnerLabel];
    [self addSubview:tripNameLabel];
    [self addSubview:tripDescriptionLabel];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.bounds = self.bounds;
    [bgColorView setBackgroundColor:[AppColors mainBackgroundColor]];//[AppColors toolbarColor]];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setTrip:(Trip*)trip
{
    if (!layoutDone) {
        [self layoutSubviews];
    }
    if (trip.featuredLocationItem != nil) {
        if (trip.featuredLocationItem.image != nil) {
            tripFeaturedImage.image = trip.featuredLocationItem.image;
        }
    }
    tripOwnerLabel.text = @"Trip Owner";
    tripNameLabel.text = trip.name;
    tripDescriptionLabel.text = trip.description;
}

@end
