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
    CGRect tripFeaturedImageFrameFull;
    UIView* profilePictureBackgroundView;
    UISwitch* publishSwitch;
    UILabel* publishLabel;
    Trip* DisplayTrip;
    UIButton* deleteTrip;
//    UIView* bgColorView;
//    UIView* bgSubView;
}

+ (int)heightForCellStyle:(TripBrowserCellStyle)cellStyle
{
    if (cellStyle == TripBrowserCell4x1) {return 79;}
    if (cellStyle == TripBrowserCell5x1 || cellStyle == ProfileBrowserCell5x1) {return 110;}
    if (cellStyle == TripBrowserCell6x2) {return 309;}
    if (cellStyle == TripBrowserCell3x4) {return 344;}
    if (cellStyle == TripBrowserCell4x4) {return 380;}
    return 0;
}

- (id)initWithCellStyle:(TripBrowserCellStyle)cellStyle
{
    self = [super init];
    if (self) {
        //[self layoutSubviews];
        layoutDone = NO;
        self.cellStyle = cellStyle;
    }
    return self;
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
        [subView setFrame:CGRectMake(self.bounds.size.width/2-165, 8, 330, 344)];
    }
    if (self.cellStyle == TripBrowserCell4x4) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-275, 16, 550, 372)];
    }
    if (self.cellStyle == TripBrowserCell6x2) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-275, 8, 550, 309)];
    }
    if (self.cellStyle == TripBrowserCell5x1) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-275, 8, 550, 110)];
    }
    if (self.cellStyle == TripBrowserCell4x1) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-280, 8, 550, 79)];
        [publishSwitch setFrame:CGRectMake(self.bounds.size.width/2 + 290, 33, 60, 20)];
        [publishLabel setFrame:CGRectMake(self.bounds.size.width/2 + 300, 58, 60, 20)];
        [deleteTrip setFrame:CGRectMake(self.bounds.size.width/2 - 350, 23, 50, 50)];
    }
    
//    [bgColorView setBounds:self.bounds];
//    [bgSubView setFrame:subView.frame];
}

- (void)createAndAddSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    //set frame layout based on style enum
    if (self.cellStyle == TripBrowserCell3x4) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 10, 260, 34)];
        [tripOwnerLabel setHidden:YES];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 10, 260, 25)];
        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 33, 260, 18)];
        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 49, 260, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(-16, -8, 126, 126)];
        profilePictureBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(-20, -12, 134, 134)];
        [profilePictureView setHidden:YES];
        [profilePictureBackgroundView setHidden:YES];
        tripFeaturedImageFrameFull = CGRectMake(0, 79, 330, 265);
//        tripFeaturedImageFrameFull = CGRectMake(0, 79, 330, 186);
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:tripFeaturedImageFrameFull];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 273, 312, 66)];
        publishSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishSwitch setHidden:YES];
        publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishLabel setHidden:YES];
    }
    if (self.cellStyle == TripBrowserCell4x4) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 10, 370, 34)];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 41, 370, 25)];
        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 64, 370, 18)];
        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 80, 370, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(-16, -8, 126, 126)];
        profilePictureBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(-20, -12, 134, 134)];
        tripFeaturedImageFrameFull = CGRectMake(0, 110, 550, 262); //372 {262} [32]
//        tripFeaturedImageFrameFull = CGRectMake(0, 110, 550, 186); //296
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:tripFeaturedImageFrameFull];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 304, 526, 66)];
        publishSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishSwitch setHidden:YES];
        publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishLabel setHidden:YES];
    }
    if (self.cellStyle == TripBrowserCell6x2) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
        [tripOwnerLabel setHidden:YES];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(122, 10, 370, 25)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(-16, -8, 126, 126)];
        profilePictureBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(-20, -12, 134, 134)];
        [profilePictureView setHidden:YES];
        [profilePictureBackgroundView setHidden:YES];
        tripFeaturedImageFrameFull = CGRectMake(0, 45, 550, 180);
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:tripFeaturedImageFrameFull];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 233, 422, 66)];
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
        tripFeaturedImageFrameFull = CGRectMake(330, 0, 220, 110);
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:tripFeaturedImageFrameFull];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [tripDescriptionTextView setHidden:YES];
        publishSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishSwitch setHidden:YES];
        publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [publishLabel setHidden:YES];
    }
    if (self.cellStyle == TripBrowserCell4x1) {
        tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 10, 260, 34)];
        [tripOwnerLabel setHidden:YES];
        tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 10, 260, 25)];
        tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 33, 260, 18)];
        tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 49, 260, 18)];
        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [profilePictureView setHidden:YES];
        tripFeaturedImageFrameFull = CGRectMake(330, 0, 220, 79);
        tripFeaturedImageView = [[UIImageView alloc] initWithFrame:tripFeaturedImageFrameFull];
        tripDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [tripDescriptionTextView setHidden:YES];
        publishSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(subView.bounds.origin.x +130, subView.bounds.size.height/2+40, 60, 20)];
//        [publishSwitch setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin ];
        
       [publishSwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(subView.bounds.origin.x +140, subView.bounds.size.height/2+65, 60, 20)];
        publishLabel.text=@"Published";
        [publishLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        
        
        deleteTrip = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteTrip.frame=CGRectMake(subView.bounds.origin.x +225, subView.bounds.size.height/2+30, 50, 50);
        [deleteTrip setHidden:NO];
        [deleteTrip setBackgroundImage:[UIImage imageNamed:@"button_red_unselect.png"] forState:UIControlStateNormal];
        [deleteTrip setBackgroundImage:[UIImage imageNamed:@"button_red_select.png"] forState:UIControlStateSelected];
        [deleteTrip setImage:[UIImage imageNamed:@"icon_minus.png"] forState:UIControlStateNormal];
        [deleteTrip setImage:[UIImage imageNamed:@"icon_minus.png"] forState:UIControlStateSelected];
        [deleteTrip addTarget:self action:@selector(deleteTrip) forControlEvents:UIControlEventTouchUpInside];
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
    tripNameLabel.font = (self.cellStyle == TripBrowserCell3x4 || self.cellStyle == TripBrowserCell4x1)?[UIFont boldSystemFontOfSize:19]:[UIFont systemFontOfSize:19];
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
    
//    bgColorView = [[UIView alloc] init];
//    bgColorView.bounds = self.bounds;
//    bgColorView.frame = self.frame;
//    [bgColorView setBackgroundColor:[UIColor clearColor]];
//    bgSubView = [[UIView alloc] init];
//    bgColorView.frame = subView.frame;
//    bgColorView.backgroundColor = [UIColor clearColor];
//    [bgColorView addSubview:bgSubView];
//    [self setSelectedBackgroundView:bgColorView];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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
    int photoCount = 0;
    for (TripLocation* tripLocation in displayTrip.tripLocations) {
        photoCount += tripLocation.tripLocationItems.count;
    }
    tripOwnerLabel.text = displayTrip.username;
    tripNameLabel.text = displayTrip.name;
    tripDatesLabel.text = [NSString stringWithFormat:@"%d Photo%@", photoCount, photoCount == 1 ? @"" : @"s"];
    tripContentLabel.text = [NSString stringWithFormat:@"%d Location%@", displayTrip.tripLocations.count, displayTrip.tripLocations.count == 1 ? @"" : @"s"];
    tripFeaturedImageView.image = displayTrip.image;
    profilePictureView.image = displayTrip.profileImage;
    if (self.cellStyle == TripBrowserCell3x4 || self.cellStyle == TripBrowserCell4x4) {
        if ([displayTrip.description isEqual:@""]) {
            tripDescriptionTextView.text = @"";
            tripDescriptionTextView.hidden = YES;
            int offset = 16 + [@"ABC" sizeWithFont:tripDescriptionTextView.font constrainedToSize:CGSizeMake(tripDescriptionTextView.bounds.size.width, tripFeaturedImageView.bounds.size.height / 2) lineBreakMode:NSLineBreakByWordWrapping].height;;
            tripFeaturedImageView.frame = CGRectMake(
                                                     tripFeaturedImageFrameFull.origin.x,
                                                     tripFeaturedImageFrameFull.origin.y,
                                                     tripFeaturedImageFrameFull.size.width,
                                                     tripFeaturedImageFrameFull.size.height - offset);
        }
        else {
            tripDescriptionTextView.text = displayTrip.description;
            tripDescriptionTextView.hidden = NO;
            int offset = 16 + [displayTrip.description sizeWithFont:tripDescriptionTextView.font constrainedToSize:CGSizeMake(tripDescriptionTextView.bounds.size.width, tripFeaturedImageFrameFull.size.height / 2) lineBreakMode:NSLineBreakByWordWrapping].height;
            //        int offset = 76;
            tripFeaturedImageView.frame = CGRectMake(
                                                     tripFeaturedImageFrameFull.origin.x,
                                                     tripFeaturedImageFrameFull.origin.y,
                                                     tripFeaturedImageFrameFull.size.width,
                                                     tripFeaturedImageFrameFull.size.height - offset);
            tripDescriptionTextView.frame = CGRectMake(
                                                       tripDescriptionTextView.frame.origin.x,
                                                       tripFeaturedImageView.frame.origin.y + tripFeaturedImageView.frame.size.height + 8,
                                                       tripDescriptionTextView.frame.size.width,
                                                       offset - 16);
        }
    }
    else {
        tripDescriptionTextView.text = displayTrip.description;
    }
    tripDescriptionTextView.contentOffset = CGPointMake(-tripDescriptionTextView.contentInset.left, -tripDescriptionTextView.contentInset.top);
    if(displayTrip.published==0){
        [publishSwitch setOn:NO];
    }
    else
    {
        [publishSwitch setOn:YES];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in event.allTouches) {
        if (CGRectContainsPoint(subView.bounds, [touch locationInView:subView])) {
            [self.delegate respondToSelectAtRow:self.row];
        }
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)valueChange:(id)sender
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

- (void)tripChanged:(NSNumber*)idfield withSuccess:(NSNumber*)success
{
    
}

- (void)deleteTrip
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [ _delegate performSelector:_deletefrom withObject:DisplayTrip];
#pragma clang diagnostic pop
}

@end
