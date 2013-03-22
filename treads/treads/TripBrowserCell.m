//
//  TripBrowserCell.m
//  treads
//
//  Created by keavneyrj1 on 3/18/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripBrowserCell.h"

#import "Trip.h"

#import "AppColors.h"

@implementation TripBrowserCell {
    BOOL layoutDone;
    UILabel* tripOwnerLabel;
    UILabel* tripNameLabel;
    UILabel* tripDatesLabel;
    UILabel* tripContentLabel;
    UIImageView* tripFeaturedImage;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self layoutSubviews];
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
    
    self.bounds = CGRectMake(0, 0, 720, 110);
    self.backgroundColor = [AppColors mainBackgroundColor];
    
    if (layoutDone) {
        return;
    }
    
    layoutDone = YES;
    
    //for (UIView* subview in self.subviews)
    //    [subview removeFromSuperview];
    
    //self.bounds = CGRectMake(0, 0, 768, 90);
    
    tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 12, 260, 30)];
    tripOwnerLabel.backgroundColor = [UIColor clearColor];
    tripOwnerLabel.font = [UIFont boldSystemFontOfSize: 24];
    tripOwnerLabel.textColor = [AppColors mainTextColor];
    tripOwnerLabel.textAlignment = NSTextAlignmentLeft;
    tripOwnerLabel.adjustsFontSizeToFitWidth = YES;
    
    tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 40, 260, 23)];
    tripNameLabel.backgroundColor = [UIColor clearColor];
    tripNameLabel.font = [UIFont systemFontOfSize: 17];
    tripNameLabel.textColor = [AppColors mainTextColor];
    tripNameLabel.textAlignment = NSTextAlignmentLeft;
    tripNameLabel.adjustsFontSizeToFitWidth = YES;
    
    tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 62, 260, 19)];
    tripDatesLabel.backgroundColor = [UIColor clearColor];
    tripDatesLabel.font = [UIFont systemFontOfSize: 13];
    tripDatesLabel.textColor = [AppColors secondaryTextColor];
    tripDatesLabel.textAlignment = NSTextAlignmentLeft;
    tripDatesLabel.adjustsFontSizeToFitWidth = YES;
    
    tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 79, 260, 19)];
    tripContentLabel.backgroundColor = [UIColor clearColor];
    tripContentLabel.font = [UIFont systemFontOfSize: 13];
    tripContentLabel.textColor = [AppColors secondaryTextColor];
    tripContentLabel.textAlignment = NSTextAlignmentLeft;
    tripContentLabel.adjustsFontSizeToFitWidth = YES;
    
    tripFeaturedImage = [[UIImageView alloc] initWithFrame:CGRectMake(260, 0, 460, 110)];
    
    [self addSubview:tripOwnerLabel];
    [self addSubview:tripNameLabel];
    [self addSubview:tripDatesLabel];
    [self addSubview:tripContentLabel];
    //[self addSubview:tripFeaturedImage];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.bounds = self.bounds;
    [bgColorView setBackgroundColor:[AppColors toolbarColor]];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setDisplayTrip:(Trip*)displayTrip
{
    if (!layoutDone)
        [self layoutSubviews];
    tripOwnerLabel.text = @"Trip Owner";
    tripNameLabel.text = displayTrip.name;
    tripDatesLabel.text = @"1/1/2013 - 12/31/2013";
    tripContentLabel.text = @"P213 C87";
    tripFeaturedImage.image = nil;
    if (displayTrip.featuredLocationItem != nil) {
        if (displayTrip.featuredLocationItem.image != nil) {
            tripFeaturedImage.image = displayTrip.featuredLocationItem.image;
        }
    }
}

@end
