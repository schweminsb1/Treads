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

@interface TripBrowserCell()

@property (readwrite) TripBrowserCellStyle cellStyle;

@end

@implementation TripBrowserCell {
    BOOL layoutDone;
    UIView* subView;
    UILabel* tripOwnerLabel;
    UILabel* tripNameLabel;
    UILabel* tripDatesLabel;
    UILabel* tripContentLabel;
    UITextView* tripDescriptionTextView;
    UIImageView* profilePictureView;
    UIImageView* tripFeaturedImageView;
}

+ (int)heightForCellStyle:(TripBrowserCellStyle)cellStyle
{
    if (cellStyle == TripBrowserCell4x1 || cellStyle == TripBrowserCell5x1) {return 110;}
    if (cellStyle == TripBrowserCell6x2) {return 220;}
    if (cellStyle == TripBrowserCell3x4) {return 440;}
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
    
    //set frames of subviews
//    [subView setFrame:CGRectMake(24, 8, self.bounds.size.width-48, 110)];
    
    if (self.cellStyle == TripBrowserCell3x4) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-165, 8, 330, 440)];
    }
    if (self.cellStyle == TripBrowserCell6x2) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-330, 8, 660, 220)];
    }
    if (self.cellStyle == TripBrowserCell5x1) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-275, 8, 550, 110)];
    }
    if (self.cellStyle == TripBrowserCell4x1) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-330, 8, 440, 110)];
    }
    
}

- (void)createAndAddSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    //set frame layout based on style enum
    if (self.cellStyle == TripBrowserCell3x4) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 10, 260, 34)];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 41, 260, 25)];
        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 64, 260, 18)];
        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 80, 260, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 110, 330, 220)];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 340, 312, 90)];
    }
    if (self.cellStyle == TripBrowserCell6x2) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 10, 260, 34)];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 41, 260, 25)];
        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 64, 260, 18)];
        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 80, 260, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(330, 0, 330, 220)];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 120, 312, 90)];
    }
    if (self.cellStyle == TripBrowserCell5x1) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 10, 260, 34)];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 41, 260, 25)];
        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 64, 260, 18)];
        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 80, 260, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(330, 0, 220, 110)];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [tripDescriptionTextView setHidden:YES];
    }
    if (self.cellStyle == TripBrowserCell4x1) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 10, 260, 34)];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 41, 260, 25)];
        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 64, 260, 18)];
        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 80, 260, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [profilePictureView setHidden:YES];
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 0, 220, 110)];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [tripDescriptionTextView setHidden:YES];
    }
    
    subView = [[UIView alloc] init];
    subView.backgroundColor = [AppColors mainBackgroundColor];
    [self addSubview:subView];
    
    tripOwnerLabel.backgroundColor = [UIColor clearColor];
    tripOwnerLabel.font = [UIFont boldSystemFontOfSize: 28];
    tripOwnerLabel.textColor = [AppColors mainTextColor];
    tripOwnerLabel.textAlignment = NSTextAlignmentLeft;
    tripOwnerLabel.adjustsFontSizeToFitWidth = YES;
    
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
    
    tripDescriptionTextView.backgroundColor = [UIColor clearColor];
    tripDescriptionTextView.font = [UIFont systemFontOfSize: 14];
    tripDescriptionTextView.textColor = [AppColors mainTextColor];
    tripDescriptionTextView.textAlignment = NSTextAlignmentLeft;
    tripDescriptionTextView.editable = NO;
    tripDescriptionTextView.scrollEnabled = NO;
    tripDescriptionTextView.contentInset = UIEdgeInsetsMake(-9, -8, 0, -8);
    
    [subView addSubview:tripOwnerLabel];
    [subView addSubview:tripNameLabel];
    [subView addSubview:tripDatesLabel];
    [subView addSubview:tripContentLabel];
    [subView addSubview:profilePictureView];
    [subView addSubview:tripFeaturedImageView];
    [subView addSubview:tripDescriptionTextView];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.bounds = subView.bounds;
    bgColorView.frame = subView.frame;
    [bgColorView setBackgroundColor:[AppColors toolbarColor]];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setDisplayTrip:(Trip*)displayTrip
{
    if (!layoutDone) {
        [self layoutSubviews];
        //[self setNeedsLayout];
    }
    tripOwnerLabel.text = @"Trip Owner";
    tripNameLabel.text = displayTrip.name;
    tripDatesLabel.text = @"1/1/2013 - 12/31/2013";
    tripContentLabel.text = @"P213 C87";
//    tripContentLabel.text = [NSString stringWithFormat:@"%f, %f, %f, %f", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height];
    tripFeaturedImageView.image = nil;
    if (displayTrip.featuredLocationItem != nil) {
        if (displayTrip.featuredLocationItem.image != nil) {
            tripFeaturedImageView.image = displayTrip.featuredLocationItem.image;
        }
    }
    profilePictureView.image = [self randomImage];
    tripDescriptionTextView.text = displayTrip.description;
    tripDescriptionTextView.contentOffset = CGPointMake(-tripDescriptionTextView.contentInset.left, -tripDescriptionTextView.contentInset.top);
}

- (UIImage*)randomImage
{
    int image = random()%5;
    switch (image) {
        case 0:
            return [UIImage imageNamed:@"mountains.jpeg"];
            break;
        case 1:
            return [UIImage imageNamed:@"helicopter-bouldering-crash-pad.jpg"];
            break;
        case 2:
            return [UIImage imageNamed:@"remote-luxury-hiking-canada.jpg"];
            break;
        case 3:
            return [UIImage imageNamed:@"summit-boots-hiking-rocks.jpg"];
            break;
        case 4:
            return [UIImage imageNamed:@"virgin_river_hiking.jpg"];
            break;
        default:
            break;
    }
    return nil;
}


@end
