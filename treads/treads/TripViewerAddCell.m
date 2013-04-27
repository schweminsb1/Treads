//
//  TripViewerAddCell.m
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewerAddCell.h"

#import "ImageService.h"

@implementation TripViewerAddCell {
    BOOL layoutDone;
    UIButton* subView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    [subView setFrame:CGRectMake(48, 8, self.bounds.size.width-96, 90)];
}

- (void)createAndAddSubviews
{
    subView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage* buttonNormalImage = [ImageService imageWithImage:[UIImage imageNamed:@"button_blue_unselect.png"] scaledToSize:CGSizeMake(90, 90)];
    [subView setBackgroundImage:[buttonNormalImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, buttonNormalImage.size.width * (72.0/312.0), 0, buttonNormalImage.size.width * (72.0/312.0))]forState:UIControlStateNormal];
    
    UIImage* buttonSelectImage = [ImageService imageWithImage:[UIImage imageNamed:@"button_blue_select.png"] scaledToSize:CGSizeMake(90, 90)];
    [subView setBackgroundImage:[buttonSelectImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, buttonSelectImage.size.width * (72.0/312.0), 0, buttonSelectImage.size.width * (72.0/312.0))]forState:UIControlStateHighlighted];
    
    NSString* buttonText = @"Add Location";
    
    [subView setTitle:buttonText forState:UIControlStateNormal];
    [subView setTitle:buttonText forState:UIControlStateHighlighted];
    [subView setTitleColor:[UIColor colorWithWhite:0 alpha:0.6] forState:UIControlStateNormal];
    [subView setTitleColor:[UIColor colorWithWhite:0 alpha:0.6] forState:UIControlStateHighlighted];
    [subView.titleLabel setFont:[UIFont boldSystemFontOfSize:32]];
    
    UIImage* icon = [ImageService imageWithImage:[UIImage imageNamed:@"icon_plus.png"] scaledToSize:CGSizeMake(60, 60)];
    [subView setImage:icon forState:UIControlStateNormal];
    [subView setImage:icon forState:UIControlStateHighlighted];
    
    CGSize textSize = [buttonText sizeWithFont:subView.titleLabel.font constrainedToSize:subView.bounds.size lineBreakMode:NSLineBreakByClipping];
    [subView setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -icon.size.width/4)];
    [subView setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -textSize.width/4)];
    
    [subView addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:subView];
}

- (void)tappedButton:(id)sender
{
    self.requestAddItem();
}

@end
