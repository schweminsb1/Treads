//
//  TripViewerLocationCell.m
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewerLocationCell.h"

#import "TripLocation.h"
#import "TripLocationItem.h"

@implementation TripViewerLocationCell {
    BOOL layoutDone;
    UILabel* locationNameLabel;
    UILabel* locationDescriptionLabel;
    //UIImageView* tripFeaturedImage;
    //UILabel* tripNameLabel;
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
    
    self.bounds = CGRectMake(0, 0, 720, 300);
    self.backgroundColor = [AppColors mainBackgroundColor];
    
    if (layoutDone) {
        return;
    }
    
    layoutDone = YES;
    
    //for (UIView* subview in self.subviews)
    //    [subview removeFromSuperview];
    
    //self.bounds = CGRectMake(0, 0, 768, 90);
    
    //tripFeaturedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 720, 240)];
    
    locationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 680, 38)];
    locationNameLabel.backgroundColor = [UIColor clearColor];
    locationNameLabel.font = [UIFont boldSystemFontOfSize: 32];
    locationNameLabel.textColor = [AppColors mainTextColor];
    locationNameLabel.textAlignment = NSTextAlignmentLeft;
    locationNameLabel.adjustsFontSizeToFitWidth = YES;
    
    locationDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 52, 680, 23)];
    locationDescriptionLabel.backgroundColor = [UIColor clearColor];
    locationDescriptionLabel.font = [UIFont systemFontOfSize: 17];
    locationDescriptionLabel.textColor = [AppColors mainTextColor];
    locationDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    locationDescriptionLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:locationNameLabel];
    [self addSubview:locationDescriptionLabel];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.bounds = self.bounds;
    [bgColorView setBackgroundColor:[AppColors mainBackgroundColor]];//[AppColors toolbarColor]];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setTripLocation:(TripLocation *)tripLocation
{
    if (!layoutDone) {
        [self layoutSubviews];
    }
    locationNameLabel.text = [NSString stringWithFormat:@"Location ID: %d", tripLocation.tripLocationID];
    locationDescriptionLabel.text = tripLocation.description;
}

@end
