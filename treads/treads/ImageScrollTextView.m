//
//  ImageScrollTextView.m
//  treads
//
//  Created by keavneyrj1 on 4/3/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "ImageScrollTextView.h"

@implementation ImageScrollTextView {
    BOOL layoutDone;
    UITextView* descriptionTextView;
    int displayIndex;
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
    
    if (!layoutDone) {
        //add subviews if layout has not been set
        [self createAndAddSubviews];
        layoutDone = YES;
    }
    
    //set frames of subviews
    [descriptionTextView setFrame:CGRectMake(20, 16, self.bounds.size.width - 40, self.bounds.size.height - 32)];
}

- (void)createAndAddSubviews
{
    descriptionTextView = [[UITextView alloc] init];
    descriptionTextView.backgroundColor = [UIColor clearColor];
    descriptionTextView.font = [UIFont systemFontOfSize: 17];
    descriptionTextView.textColor = [AppColors mainTextColor];
    descriptionTextView.textAlignment = NSTextAlignmentLeft;
    descriptionTextView.editable = false;
    descriptionTextView.contentInset = UIEdgeInsetsMake(-10, -7, 0, -7);
    
    [self addSubview:descriptionTextView];
}

- (void)setDisplayItem:(NSObject *)displayItem index:(int)index
{
    displayIndex = index;
    if (!layoutDone) {
        [self layoutSubviews];
    }
    
    if (displayItem) {
        descriptionTextView.text = (NSString*)displayItem;
    }
    else {
        descriptionTextView.text = @"";
    }
    descriptionTextView.contentOffset = CGPointMake(-descriptionTextView.contentInset.left, -descriptionTextView.contentInset.top);
    [self setNeedsDisplay];
}

@end
