//
//  TripViewerLocationCell.m
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewerLocationCell.h"

#import "ImageScrollBrowser.h"

#import "TripLocation.h"
#import "TripLocationItem.h"

@implementation TripViewerLocationCell {
    BOOL layoutDone;
    UILabel* locationNameLabel;
    UITextView* locationDescriptionTextView;
    UIView* locationMapView;
    UIView* locationTextBackgroundView;
    ImageScrollBrowser* imageScrollBrowser;
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
    
    self.bounds = CGRectMake(0, 0, 720, 620);
    self.backgroundColor = [AppColors mainBackgroundColor];
    
    if (layoutDone) {
        return;
    }
    
    layoutDone = YES;
    
    //for (UIView* subview in self.subviews)
    //    [subview removeFromSuperview];
    
    //self.bounds = CGRectMake(0, 0, 768, 90);
    
    //tripFeaturedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 720, 240)];
    
    locationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 500, 38)];
    locationNameLabel.backgroundColor = [UIColor clearColor];
    locationNameLabel.font = [UIFont boldSystemFontOfSize: 32];
    locationNameLabel.textColor = [AppColors mainTextColor];
    locationNameLabel.textAlignment = NSTextAlignmentLeft;
    locationNameLabel.adjustsFontSizeToFitWidth = YES;
    
//    locationDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 56, 430, 116)];
//    locationDescriptionTextView.backgroundColor = [UIColor clearColor];
//    locationDescriptionTextView.font = [UIFont systemFontOfSize: 17];
//    locationDescriptionTextView.textColor = [AppColors mainTextColor];
//    locationDescriptionTextView.textAlignment = NSTextAlignmentLeft;
//    locationDescriptionTextView.editable = false;
//    locationDescriptionTextView.contentInset = UIEdgeInsetsMake(-10, -7, 0, -7);
    
    locationTextBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 70)];
    locationTextBackgroundView.backgroundColor = [AppColors mainBackgroundColor];
    
    locationMapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 70)];
    locationMapView.backgroundColor = [UIColor colorWithHue:60.0/360.0 saturation:0.5 brightness:0.8 alpha:1];
    
    imageScrollBrowser = [[ImageScrollBrowser alloc] initWithFrame:CGRectMake(0, 70, 720, 550)];
    
    [self addSubview:locationMapView];
    [self addSubview:locationTextBackgroundView];
    [self addSubview:locationNameLabel];
    //[self addSubview:locationDescriptionTextView];
    [self addSubview:imageScrollBrowser];
    
    /*UIView *bgColorView = [[UIView alloc] init];
    bgColorView.bounds = self.bounds;
    [bgColorView setBackgroundColor:[AppColors mainBackgroundColor]];//[AppColors toolbarColor]];
    [self setSelectedBackgroundView:bgColorView];*/
}

- (void)setTripLocation:(TripLocation *)tripLocation
{
    if (!layoutDone) {
        [self layoutSubviews];
        //[self setNeedsLayout];
    }
    locationNameLabel.text = [NSString stringWithFormat:@"Location ID: %d", tripLocation.tripLocationID];
    CGSize sizeOfText=[locationNameLabel.text sizeWithFont:locationNameLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    [locationTextBackgroundView setFrame:CGRectMake(0, 0, 40 + sizeOfText.width, 70)];
    
    locationDescriptionTextView.text = [NSString stringWithFormat:@"Description for Trip Location %d: %@", tripLocation.tripID, tripLocation.description];
    locationDescriptionTextView.contentOffset = CGPointZero;
    
    imageScrollBrowser.tripLocation = tripLocation;
}

@end
