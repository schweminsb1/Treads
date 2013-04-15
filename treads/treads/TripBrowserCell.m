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
#import "TripService.h"
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
    UIView* profilePictureBackgroundView;
    UISwitch * publishSwitch;
    UILabel  * publishLabel;
    Trip    * DisplayTrip;
    UIButton * deleteTrip;
}

+ (int)heightForCellStyle:(TripBrowserCellStyle)cellStyle
{
    if (cellStyle == TripBrowserCell4x1 || cellStyle == TripBrowserCell5x1 || cellStyle == ProfileBrowserCell5x1) {return 110;}
    if (cellStyle == TripBrowserCell6x2) {return 220;}
    if (cellStyle == TripBrowserCell3x4) {return 440;}
    if (cellStyle == TripBrowserCell4x4) {return 380;}
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
    
    if (self.cellStyle == TripBrowserCell3x4) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-165, 8, 330, 440)];
    }
    if (self.cellStyle == TripBrowserCell4x4) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-275, 16, 550, 372)];
    }
    if (self.cellStyle == TripBrowserCell6x2) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-330, 8, 660, 220)];
    }
    if (self.cellStyle == TripBrowserCell5x1) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-275, 8, 550, 110)];
    }
    if (self.cellStyle == TripBrowserCell4x1) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-370, 8, 550, 110)];
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
        publishSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishSwitch setHidden:YES];
        publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishLabel setHidden:YES];
    }
    if (self.cellStyle == TripBrowserCell4x4) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 10, 370, 34)];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 41, 370, 25)];
//        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 64, 370, 18)];
//        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 80, 370, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(-16, -8, 126, 126)];
        profilePictureBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(-20, -12, 134, 134)];
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 76, 550, 220)];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 304, 422, 66)];
        publishSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishSwitch setHidden:YES];
        publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishLabel setHidden:YES];
    }
    if (self.cellStyle == TripBrowserCell6x2) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 10, 260, 34)];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 41, 260, 25)];
        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 64, 260, 18)];
        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 80, 260, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(330, 0, 330, 220)];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 120, 312, 90)];
        publishSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishSwitch setHidden:YES];
        publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishLabel setHidden:YES];
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
        publishSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishSwitch setHidden:YES];
        publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishLabel setHidden:YES];
    }
    if (self.cellStyle == TripBrowserCell4x1) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 10, 370, 34)];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 41, 370, 25)];
        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 64, 370, 18)];
        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 80, 370, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [profilePictureView setHidden:YES];
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(330, 0, 220, 110)];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [tripDescriptionTextView setHidden:YES];
        publishSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(subView.bounds.origin.x +130, subView.bounds.size.height/2+40, 60, 20)];
        [publishSwitch setHidden:NO];
        [publishSwitch setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin ];
        
       [publishSwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(subView.bounds.origin.x +140, subView.bounds.size.height/2+65, 60, 20)];
        publishLabel.text=@"Published";
        [publishLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        deleteTrip = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteTrip.frame=CGRectMake(subView.bounds.origin.x +225, subView.bounds.size.height/2+30, 80, 50);
        [deleteTrip setHidden:NO];
        [deleteTrip setTintColor:[UIColor redColor]];
        [deleteTrip addTarget:self action:@selector(deleteTrip) forControlEvents:UIControlEventTouchUpInside];
        deleteTrip.titleLabel.text=@"Delete";
        deleteTrip.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12];
        deleteTrip.titleLabel.textColor=[UIColor blackColor];
        [deleteTrip setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [self addSubview:deleteTrip];
       
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
    
    publishLabel.backgroundColor=[UIColor clearColor];
    publishLabel.font = [UIFont systemFontOfSize: 17];
    publishLabel.textColor = [AppColors secondaryTextColor];
    publishLabel.textAlignment = NSTextAlignmentLeft;
    publishLabel.adjustsFontSizeToFitWidth = YES;
    
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

    if (profilePictureBackgroundView) {
        profilePictureBackgroundView.backgroundColor = [AppColors mainBackgroundColor];
        [subView addSubview:profilePictureBackgroundView];
    }
    
    [subView bringSubviewToFront:profilePictureView];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.bounds = subView.bounds;
    bgColorView.frame = subView.frame;
    [bgColorView setBackgroundColor:[AppColors toolbarColor]];
    [self setSelectedBackgroundView:bgColorView];
    [self bringSubviewToFront:subView];
    [self addSubview:publishSwitch];
    [self addSubview:publishLabel];
    [self bringSubviewToFront:publishSwitch];
}

- (void)setDisplayTrip:(Trip*)displayTrip
{
    DisplayTrip=displayTrip;
    if (!layoutDone) {
        [self layoutSubviews];
        //[self setNeedsLayout];
    }
    tripOwnerLabel.text = displayTrip.username;
    tripNameLabel.text = displayTrip.name;
    tripDatesLabel.text = @"1/1/2013 - 12/31/2013";
    tripContentLabel.text = @"P213 C87";
    tripFeaturedImageView.image = displayTrip.image;
    profilePictureView.image = displayTrip.profileImage;
    tripDescriptionTextView.text = displayTrip.description;
    tripDescriptionTextView.contentOffset = CGPointMake(-tripDescriptionTextView.contentInset.left, -tripDescriptionTextView.contentInset.top);
    if(displayTrip.published==0){
        [publishSwitch setOn:NO];
    }
    else
    {
        [publishSwitch setOn:YES];
    }
}

-(void)valueChange:(id)sender
{
    if([publishSwitch isOn])
    {
        DisplayTrip.published=1;
        [[TripService instance]updateTrip:DisplayTrip forTarget:self withAction:@selector(tripChanged:withSuccess:)];
    }
    else
    {
        DisplayTrip.published=0;
        [[TripService instance]updateTrip:DisplayTrip forTarget:self withAction:@selector(tripChanged:withSuccess:)];
    }
}
-(void)tripChanged:(NSNumber*)idfield withSuccess:(NSNumber*)success
{
    
    
}
-(void)deleteTrip
{
    [self performSelector:_deletefrom withObject:DisplayTrip];
    
}

@end
