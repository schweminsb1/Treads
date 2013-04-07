//
//  addCommentButton.m
//  treads
//
//  Created by Sam Schwemin on 4/7/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "addCommentButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation addCommentButton






- (id)initWithFrame:(CGRect)frame
//button created in code
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialise];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
//button created in Interface Builder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialise];
    }
    return self;
}

- (void)initialise
{
    self.layer.cornerRadius  = 10.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor  lightGrayColor] CGColor];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
