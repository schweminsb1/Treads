//
//  TripViewerHeaderCell.m
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewerHeaderCell.h"

#import "Trip.h"

#import "EditableTextView.h"

#import "AppColors.h"

@implementation TripViewerHeaderCell {
    BOOL layoutDone;
    UIView* bgrView;
    UIView* subView;
    UIImageView* tripFeaturedImage;
    UILabel* tripOwnerLabel;
    EditableTextView* tripNameLabel;
    EditableTextView* tripDescriptionEditableTextView;
    UIView* textBackground;
    UIImageView* profilePictureView;
    UIButton* profileButton;
    UIButton* tripOwnerButton;
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
    [bgrView setFrame:CGRectMake(0, 16, self.bounds.size.width, 320)];
    //[bgrView setFrame:CGRectMake(0, 328, self.bounds.size.width, self.bounds.size.height-328)];
    [subView setFrame:CGRectMake(24, 8, self.bounds.size.width-48, 480)];
    [tripFeaturedImage setFrame:CGRectMake(0, 0, subView.frame.size.width, 320)];
    [tripOwnerLabel setFrame:CGRectMake(176, 33, subView.frame.size.width-196, 46)];
    [tripOwnerButton setFrame:tripOwnerLabel.frame];
    [tripNameLabel setFrame:CGRectMake(176, 78, subView.frame.size.width-196, 36)];
    [tripDescriptionEditableTextView setFrame:CGRectMake(20, 336, subView.frame.size.width-40, subView.frame.size.height-352)];
    [textBackground setFrame:CGRectMake(0, 24, subView.frame.size.width, 102)];
    [profilePictureView setFrame:CGRectMake(20, 16, 136, 136)];
    [profileButton setFrame:profilePictureView.frame];
    
    //set editing-related properties
    BOOL __editingEnabled = self.editingEnabled();
    if (__editingEnabled) {
        //subView.backgroundColor = [AppColors tertiaryBackgroundColor];
    }
    else {
        //subView.backgroundColor = [AppColors mainBackgroundColor];
    }
    [tripNameLabel setNeedsLayout];
    [tripDescriptionEditableTextView setNeedsLayout];
    
}

- (void)createAndAddSubviews
{
    TripViewerHeaderCell* __weak _self = self;
    
    //self.backgroundColor = [UIColor clearColor];
    bgrView = [[UIView alloc] init];
    bgrView.backgroundColor = [AppColors tertiaryBackgroundColor];
    [self addSubview:bgrView];
    
    subView = [[UIView alloc] init];
    subView.backgroundColor = [AppColors mainBackgroundColor];
    [self addSubview:subView];
    
    tripFeaturedImage = [[UIImageView alloc] init]; //280
    tripFeaturedImage.contentMode = UIViewContentModeScaleAspectFill;
    tripFeaturedImage.clipsToBounds = YES;
    
    tripOwnerLabel = [[UILabel alloc] init];
    tripOwnerLabel.backgroundColor = [UIColor clearColor];
    tripOwnerLabel.font = [UIFont boldSystemFontOfSize: 38];
    tripOwnerLabel.textColor = [AppColors lightTextColor];
    tripOwnerLabel.textAlignment = NSTextAlignmentLeft;
    tripOwnerLabel.adjustsFontSizeToFitWidth = YES;
    
    tripOwnerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tripOwnerButton.hidden = NO;
    [tripOwnerButton addTarget:self action:@selector(profilePictureWasTapped) forControlEvents:UIControlEventTouchUpInside];
    
    tripNameLabel = [[EditableTextView alloc] initWithFont:[UIFont systemFontOfSize:28] edgeInset:UIEdgeInsetsMake(-8, -7, 0, 0) restrictSingleLine:YES maxTextLength:50];
    tripNameLabel.editingDisabledBackgroundColor = [UIColor clearColor];
    tripNameLabel.editingEnabledBackgroundColor = [AppColors secondaryBackgroundColor];
    tripNameLabel.editingDisabledTextColor = [AppColors lightTextColor];
    tripNameLabel.editingEnabledTextColor = [AppColors mainTextColor];
    tripNameLabel.editingEnabled = ^BOOL(){return _self.editingEnabled();};
    tripNameLabel.markChangeMade = ^(){_self.markChangeMade();};
//    [tripNameLabel setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    tripDescriptionEditableTextView = [[EditableTextView alloc] initWithFont:[UIFont systemFontOfSize:17]  edgeInset:UIEdgeInsetsMake(-10, -7, 0, -7) restrictSingleLine:NO maxTextLength:1000];
    tripDescriptionEditableTextView.editingDisabledBackgroundColor = [UIColor clearColor];
    tripDescriptionEditableTextView.editingEnabledBackgroundColor = [AppColors secondaryBackgroundColor];
    tripDescriptionEditableTextView.editingDisabledTextColor = [AppColors mainTextColor];
    tripDescriptionEditableTextView.editingEnabledTextColor = [AppColors mainTextColor];
    tripDescriptionEditableTextView.editingEnabled = ^BOOL(){return _self.editingEnabled();};
    tripDescriptionEditableTextView.markChangeMade = ^(){_self.markChangeMade();};
    
    textBackground = [[UIView alloc] init];
    textBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    profilePictureView = [[UIImageView alloc] init];
    profilePictureView.backgroundColor = [UIColor lightGrayColor];
    profilePictureView.contentMode = UIViewContentModeScaleAspectFill;
    profilePictureView.clipsToBounds = YES;
    
    profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.hidden = NO;
    [profileButton addTarget:self action:@selector(profilePictureWasTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [subView addSubview:tripFeaturedImage];
    
    [subView addSubview:textBackground];
    [subView addSubview:profilePictureView];
    [subView addSubview:profileButton];
    
    [subView addSubview:tripOwnerLabel];
    [subView addSubview:tripOwnerButton];
    [subView addSubview:tripNameLabel];
    [subView addSubview:tripDescriptionEditableTextView];
    
    [subView bringSubviewToFront:tripOwnerLabel];
    [subView bringSubviewToFront:tripOwnerButton];
    [subView bringSubviewToFront:profileButton];
}

- (void)profilePictureWasTapped
{
    self.sendViewProfileRequest(self.trip.userID);
}

- (void)setTrip:(Trip*)trip
{
    _trip = trip;
    if (!layoutDone) {
        [self layoutSubviews];
        //[self setNeedsLayout];
    }
//    if (trip.featuredLocationItem != nil) {
//        if (trip.featuredLocationItem.image != nil) {
//            tripFeaturedImage.image = trip.featuredLocationItem.image;
//        }
//    }
    tripFeaturedImage.image = trip.image;
    tripOwnerLabel.text = trip.username;
    //CGSize sizeOfText=[tripOwnerLabel.text sizeWithFont:tripOwnerLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    //[tripOwnerLabel setBounds:CGRectMake(
    //                                     tripOwnerLabel.bounds.origin.x,
    //                                     tripOwnerLabel.bounds.origin.y,
    //                                     sizeOfText.width,
    //                                     tripOwnerLabel.bounds.size.height)];
    //tripOwnerLabel.font = [UIFont boldSystemFontOfSize: 36];
    //tripNameLabel.text = trip.name;
    [tripNameLabel setText:trip.name];
    tripNameLabel.textWasChanged = ^(NSString* newText){trip.name = newText;};
    [tripDescriptionEditableTextView setText:trip.description];
    tripDescriptionEditableTextView.textWasChanged = ^(NSString* newText){trip.description = newText;};
    profilePictureView.image = trip.profileImage;//[UIImage imageNamed:@"helicopter-bouldering-crash-pad.jpg"];
}

@end
