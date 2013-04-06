//
//  EditableTextView.m
//  treads
//
//  Created by keavneyrj1 on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "EditableTextView.h"

@implementation EditableTextView  {
    BOOL layoutDone;
    UITextView* descriptionTextView;
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
    [descriptionTextView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [descriptionTextView setEditable:self.editingEnabled()];
}

- (void)createAndAddSubviews
{
    descriptionTextView = [[UITextView alloc] init];
    descriptionTextView.backgroundColor = [UIColor clearColor];
    descriptionTextView.font = [UIFont systemFontOfSize: 17];
    descriptionTextView.textColor = [AppColors mainTextColor];
    descriptionTextView.textAlignment = NSTextAlignmentLeft;
    descriptionTextView.contentInset = UIEdgeInsetsMake(-10, -7, 0, -7);
    
    [self addSubview:descriptionTextView];
}

@end
