//
//  ImageScrollBrowser.m
//  treads
//
//  Created by keavneyrj1 on 3/22/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "ImageScrollBrowser.h"

#import "TripLocation.h"

#import "AppColors.h"

@interface ImageScrollBrowser() <UIScrollViewDelegate>

@end

@implementation ImageScrollBrowser {
    BOOL layoutDone;
    UIScrollView* imageScrollView;
    UIImageView* imageScrollPaddingLeft;
    UIImageView* imageScrollPaddingRight;

    UITextView* descriptionTextView;
    
    UIImageView* imageSubView;
    UIImageView* imageSubView2;
    UIImageView* imageSubView3;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        layoutDone = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.backgroundColor = [AppColors mainBackgroundColor];
    
    if (layoutDone) {
        return;
    }
    
    layoutDone = YES;
    
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 360)];
    //imageScrollView.backgroundColor = [AppColors toolbarColor];
    imageScrollView.bounces = NO;
    
    imageScrollView.delegate = self;
    
    imageScrollPaddingLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (self.bounds.size.width-540)/2, imageScrollView.bounds.size.width)];
    imageScrollPaddingLeft.backgroundColor = [AppColors tertiaryBackgroundColor];
    
    imageScrollPaddingRight = [[UIImageView alloc] initWithFrame:CGRectMake(1620 + imageScrollPaddingLeft.bounds.size.width, 0, (self.bounds.size.width-540)/2, imageScrollView.bounds.size.width)];
    imageScrollPaddingRight.backgroundColor = [AppColors tertiaryBackgroundColor];
    
    imageSubView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + imageScrollPaddingLeft.bounds.size.width, 0, 540, 360)];
    imageSubView2 = [[UIImageView alloc] initWithFrame:CGRectMake(540 + imageScrollPaddingLeft.bounds.size.width, 0, 540, 360)];
    imageSubView3 = [[UIImageView alloc] initWithFrame:CGRectMake(1080 + imageScrollPaddingLeft.bounds.size.width, 0, 540, 360)];
    
    [imageScrollView addSubview:imageScrollPaddingLeft];
    [imageScrollView addSubview:imageScrollPaddingRight];
    
    [imageScrollView addSubview:imageSubView];
    [imageScrollView addSubview:imageSubView2];
    [imageScrollView addSubview:imageSubView3];
    
    imageScrollView.contentSize = CGSizeMake(1620 + imageScrollPaddingLeft.bounds.size.width * 2, 300);
    
    descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 376, self.bounds.size.width - 40, self.bounds.size.height - 392)];
    descriptionTextView.backgroundColor = [UIColor clearColor];
    descriptionTextView.font = [UIFont systemFontOfSize: 17];
    descriptionTextView.textColor = [AppColors mainTextColor];
    descriptionTextView.textAlignment = NSTextAlignmentLeft;
    descriptionTextView.editable = false;
    descriptionTextView.contentInset = UIEdgeInsetsMake(-10, -7, 0, -7);
    
    [self addSubview:imageScrollView];
    [self addSubview:descriptionTextView];
}

- (void)setTripLocation:(TripLocation *)tripLocation
{
    if (!layoutDone) {
        [self layoutSubviews];
        //[self setNeedsLayout];
    }
    imageSubView.image = [UIImage imageNamed:@"summit-boots-hiking-rocks.jpg"];
    imageSubView2.image = [UIImage imageNamed:@"remote-luxury-hiking-canada.jpg"];
    imageSubView3.image = [UIImage imageNamed:@"mountains.jpeg"];
    descriptionTextView.text = [NSString stringWithFormat:@"Picture descriptions will go here: %@", tripLocation.description];
    imageScrollView.contentOffset = CGPointZero;
    descriptionTextView.contentOffset = CGPointMake(-descriptionTextView.contentInset.left, -descriptionTextView.contentInset.top);
}

@end
