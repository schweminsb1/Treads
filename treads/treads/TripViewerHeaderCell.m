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
    
    UIView* textBackground;
    UIImageView* profilePictureView;
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
    
    self.bounds = CGRectMake(0, 0, 720, 480);
    self.backgroundColor = [AppColors mainBackgroundColor];
    
    if (layoutDone) {
        return;
    }
    
    layoutDone = YES;
    
    //for (UIView* subview in self.subviews)
    //    [subview removeFromSuperview];
    
    //self.bounds = CGRectMake(0, 0, 768, 90);
    
    tripFeaturedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 720, 320)]; //280
    tripFeaturedImage.contentMode = UIViewContentModeScaleAspectFill;
    tripFeaturedImage.clipsToBounds = YES;
    
    //tripOwnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 16 + tripFeaturedImage.bounds.size.height, 680, 38)];
    tripOwnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(176, 38, 680, 44)];
    tripOwnerLabel.backgroundColor = [UIColor clearColor];
    tripOwnerLabel.font = [UIFont boldSystemFontOfSize: 38];
    tripOwnerLabel.textColor = [AppColors lightTextColor];
    tripOwnerLabel.textAlignment = NSTextAlignmentLeft;
    tripOwnerLabel.adjustsFontSizeToFitWidth = YES;
    
    //tripNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 52 + tripFeaturedImage.bounds.size.height, 680, 31)];
    tripNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(176, 82, 680, 36)];
    tripNameLabel.backgroundColor = [UIColor clearColor];
    tripNameLabel.font = [UIFont systemFontOfSize: 28];
    tripNameLabel.textColor = [AppColors lightTextColor];
    tripNameLabel.textAlignment = NSTextAlignmentLeft;
    tripNameLabel.adjustsFontSizeToFitWidth = YES;
    
    tripDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 336, 680, 23)];
    tripDescriptionLabel.backgroundColor = [UIColor clearColor];
    tripDescriptionLabel.font = [UIFont systemFontOfSize: 17];
    tripDescriptionLabel.textColor = [AppColors mainTextColor];
    tripDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    tripDescriptionLabel.adjustsFontSizeToFitWidth = YES;
    
    textBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 24, 720, 108)];
    textBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 16, 136, 136)];
    profilePictureView.backgroundColor = [UIColor lightGrayColor];
    profilePictureView.contentMode = UIViewContentModeScaleAspectFill;
    profilePictureView.clipsToBounds = YES;
    
    [self addSubview:tripFeaturedImage];
    
    [self addSubview:textBackground];
    [self addSubview:profilePictureView];
    
    [self addSubview:tripOwnerLabel];
    [self addSubview:tripNameLabel];
    [self addSubview:tripDescriptionLabel];
    
    [self bringSubviewToFront:tripOwnerLabel];
    
    /*UIView *bgColorView = [[UIView alloc] init];
    bgColorView.bounds = self.bounds;
    [bgColorView setBackgroundColor:[AppColors mainBackgroundColor]];//[AppColors toolbarColor]];
    [self setSelectedBackgroundView:bgColorView];*/
}

- (void)setTrip:(Trip*)trip
{
    if (!layoutDone) {
        [self layoutSubviews];
        //[self setNeedsLayout];
    }
    if (trip.featuredLocationItem != nil) {
        if (trip.featuredLocationItem.image != nil) {
            tripFeaturedImage.image = trip.featuredLocationItem.image;
        }
    }
    tripOwnerLabel.text = @"Trip Owner";
    //CGSize sizeOfText=[tripOwnerLabel.text sizeWithFont:tripOwnerLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    //[tripOwnerLabel setBounds:CGRectMake(
    //                                     tripOwnerLabel.bounds.origin.x,
    //                                     tripOwnerLabel.bounds.origin.y,
    //                                     sizeOfText.width,
    //                                     tripOwnerLabel.bounds.size.height)];
    //tripOwnerLabel.font = [UIFont boldSystemFontOfSize: 36];
    tripNameLabel.text = trip.name;
    tripDescriptionLabel.text = trip.description;
    profilePictureView.image = [UIImage imageNamed:@"helicopter-bouldering-crash-pad.jpg"];
}

@end
