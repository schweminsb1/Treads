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
    UILabel* tripOwnerLabel;
    UILabel* tripNameLabel;
    UILabel* tripDatesLabel;
    UILabel* tripContentLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutSubviews];
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
    //self.bounds = CGRectMake(0, 0, 768, 90);
    self.bounds = CGRectMake(0, 0, 720, 110);
    self.backgroundColor = [UIColor whiteColor];
    
    UIColor* lightColor = [UIColor colorWithHue:[AppColors primaryHue] saturation:[AppColors primarySaturation]*0.85 brightness:[AppColors primaryValue]*0.54 alpha:1];
    
    tripOwnerLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 12, 260, 30)];
    tripOwnerLabel.backgroundColor = [UIColor clearColor];
    tripOwnerLabel.font = [UIFont boldSystemFontOfSize: 24];
    tripOwnerLabel.textColor = [UIColor blackColor];
    tripOwnerLabel.textAlignment = NSTextAlignmentLeft;
    tripOwnerLabel.adjustsFontSizeToFitWidth = YES;
    
    tripNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 40, 260, 23)];
    tripNameLabel.backgroundColor = [UIColor clearColor];
    tripNameLabel.font = [UIFont systemFontOfSize: 17];
    tripNameLabel.textColor = [UIColor blackColor];
    tripNameLabel.textAlignment = NSTextAlignmentLeft;
    tripNameLabel.adjustsFontSizeToFitWidth = YES;
    
    tripDatesLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 62, 260, 19)];
    tripDatesLabel.backgroundColor = [UIColor clearColor];
    tripDatesLabel.font = [UIFont systemFontOfSize: 13];
    tripDatesLabel.textColor = lightColor;
    tripDatesLabel.textAlignment = NSTextAlignmentLeft;
    tripDatesLabel.adjustsFontSizeToFitWidth = YES;
    
    tripContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 79, 260, 19)];
    tripContentLabel.backgroundColor = [UIColor clearColor];
    tripContentLabel.font = [UIFont systemFontOfSize: 13];
    tripContentLabel.textColor = lightColor;
    tripContentLabel.textAlignment = NSTextAlignmentLeft;
    tripContentLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:tripOwnerLabel];
    [self addSubview:tripNameLabel];
    [self addSubview:tripDatesLabel];
    [self addSubview:tripContentLabel];
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithHue:85.0/360.0 saturation:0.85 brightness:0.75 alpha:1]];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setDisplayTrip:(Trip*)displayTrip
{
    tripOwnerLabel.text = @"Trip Owner";
    tripNameLabel.text = displayTrip.name;
    tripDatesLabel.text = @"1/1/2013 - 12/31/2013";
    tripContentLabel.text = @"P213 C87";
}

@end
