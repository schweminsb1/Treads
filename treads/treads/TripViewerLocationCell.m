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
    UIView* bgrView;
    UIView* subView;
    UILabel* locationNameLabel;
    UITextView* locationDescriptionTextView;
    UIImageView* locationMapView;
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
    
    if (!layoutDone) {
        //add subviews if layout has not been set
        [self createAndAddSubviews];
        layoutDone = YES;
    }
    
    //set frames of subviews
    //[bgrView setFrame:CGRectMake(0, 16, self.bounds.size.width, 70)];
    //[bgrView setFrame:self.bounds];
    [subView setFrame:CGRectMake(24, 8, self.bounds.size.width-48, 620)];
    [locationNameLabel setFrame:CGRectMake(20, 16, self.bounds.size.width, 38)];
    CGSize sizeOfText=[locationNameLabel.text sizeWithFont:locationNameLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    [locationTextBackgroundView setFrame:CGRectMake(0, 0, 40 + sizeOfText.width, 70)];
    [locationMapView setFrame:CGRectMake(0, 0, subView.bounds.size.width, 70)];
    [imageScrollBrowser setFrame:CGRectMake(0, 70, subView.bounds.size.width, 550)];
    [imageScrollBrowser setNeedsLayout];
}

- (void)createAndAddSubviews
{
    //bgrView = [[UIView alloc] init];
    //bgrView.backgroundColor = [AppColors tertiaryBackgroundColor];
    //[self addSubview:bgrView];
    
    subView = [[UIView alloc] init];
    subView.backgroundColor = [AppColors mainBackgroundColor];
    [self addSubview:subView];
    
    locationNameLabel = [[UILabel alloc] init];
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
    
    locationTextBackgroundView = [[UIView alloc] init];
    locationTextBackgroundView.backgroundColor = [AppColors mainBackgroundColor];
    
    locationMapView = [[UIImageView alloc] init];
    locationMapView.contentMode = UIViewContentModeRight;
    locationMapView.clipsToBounds = YES;
    
    imageScrollBrowser = [[ImageScrollBrowser alloc] init];
    
    [subView addSubview:locationMapView];
    [subView addSubview:locationTextBackgroundView];
    [subView addSubview:locationNameLabel];
    //[subView addSubview:locationDescriptionTextView];
    [subView addSubview:imageScrollBrowser];
}

- (void)setTripLocation:(TripLocation *)tripLocation
{
    if (!layoutDone) {
        [self layoutSubviews];
        //[self setNeedsLayout];
    }
    locationNameLabel.text = [NSString stringWithFormat:@"Location ID: %d", tripLocation.tripLocationID];
    
    locationMapView.image = [UIImage imageNamed:@"map_preview.png"];
    
    locationDescriptionTextView.text = [NSString stringWithFormat:@"Description for Trip Location %d: %@", tripLocation.tripID, tripLocation.description];
    locationDescriptionTextView.contentOffset = CGPointZero;
    
    imageScrollBrowser.tripLocation = tripLocation;
}

@end
