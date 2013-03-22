//
//  ImageScrollBrowser.m
//  treads
//
//  Created by keavneyrj1 on 3/22/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "ImageScrollBrowser.h"

#import "AppColors.h"

@implementation ImageScrollBrowser {
    UIScrollView* imageScrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [AppColors toolbarColor];
    }
    return self;
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
