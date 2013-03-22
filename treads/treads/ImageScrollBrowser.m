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
    
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 300)];
    //imageScrollView.backgroundColor = [AppColors toolbarColor];
    
    imageScrollView.delegate = self;
    
    imageSubView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 300)];
    imageSubView2 = [[UIImageView alloc] initWithFrame:CGRectMake(500, 0, 500, 300)];
    imageSubView3 = [[UIImageView alloc] initWithFrame:CGRectMake(1000, 0, 500, 300)];
    
    [imageScrollView addSubview:imageSubView];
    [imageScrollView addSubview:imageSubView2];
    [imageScrollView addSubview:imageSubView3];
    
    imageScrollView.contentSize = CGSizeMake(1500, 300);
    
    descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 316, self.bounds.size.width - 40, self.bounds.size.height - 332)];
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
    descriptionTextView.contentOffset = CGPointZero;
}

@end
