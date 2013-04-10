//
//  ImageScrollEditItemView.m
//  treads
//
//  Created by keavneyrj1 on 4/9/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "ImageScrollEditItemView.h"

@implementation ImageScrollEditItemView {
    BOOL layoutDone;
    BOOL layoutHorizontal;
    UIButton* changeItemButton;
    UIButton* removeItemButton;
    UIButton* moveForwardButton;
    UIButton* moveBackwardButton;
}

@synthesize requestChangeItem;
@synthesize requestRemoveItem;
@synthesize requestMoveForward;
@synthesize requestMoveBackward;

- (id)initDisplaysHorizontally:(BOOL)horizontal
{
    self = [super init];
    if (self) {
        layoutDone = NO;
        layoutHorizontal = horizontal;
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
    CGFloat xOffset = (layoutHorizontal?self.bounds.size.width:0);
    CGFloat yOffset = (layoutHorizontal?0:self.bounds.size.height);
    CGFloat scale = (layoutHorizontal?self.bounds.size.height:self.bounds.size.width);
    CGFloat xPadding = (layoutHorizontal?(self.bounds.size.width*0.25 - scale)*0.5:0);
    CGFloat yPadding = (layoutHorizontal?0:(self.bounds.size.width*0.25 - scale)*0.5);
    [removeItemButton setFrame:CGRectMake(xPadding, yPadding, scale, scale)];
    [changeItemButton setFrame:CGRectMake(xPadding + xOffset*(0.25), yPadding + yOffset*(0.25), scale, scale)];
    [moveBackwardButton setFrame:CGRectMake(xPadding + xOffset*(0.5), yPadding + yOffset*(0.5), scale, scale)];
    [moveForwardButton setFrame:CGRectMake(xPadding + xOffset*(0.75), yPadding + yOffset*(0.75), scale, scale)];
}

- (void)createAndAddSubviews
{
    changeItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeItemButton setBackgroundImage:[UIImage imageNamed:@"plus_unselect.png"] forState:UIControlStateNormal];
    [changeItemButton setBackgroundImage:[UIImage imageNamed:@"plus_select.png"] forState:UIControlStateHighlighted];
    [changeItemButton addTarget:self action:@selector(tappedChangeItemButton:) forControlEvents:UIControlEventTouchUpInside];
    
    removeItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeItemButton setBackgroundImage:[UIImage imageNamed:@"minus_unselect.png"] forState:UIControlStateNormal];
    [removeItemButton setBackgroundImage:[UIImage imageNamed:@"minus_select.png"] forState:UIControlStateHighlighted];
    [removeItemButton addTarget:self action:@selector(tappedRemoveItemButton:) forControlEvents:UIControlEventTouchUpInside];
    
    moveForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moveForwardButton setBackgroundImage:[UIImage imageNamed:@"arrow_unselect.png"] forState:UIControlStateNormal];
    [moveForwardButton setBackgroundImage:[UIImage imageNamed:@"arrow_select.png"] forState:UIControlStateHighlighted];
    [moveForwardButton setTransform:CGAffineTransformMakeRotation(layoutHorizontal?M_PI_2:M_PI)];
    [moveForwardButton addTarget:self action:@selector(tappedMoveForwardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    moveBackwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moveBackwardButton setBackgroundImage:[UIImage imageNamed:@"arrow_unselect.png"] forState:UIControlStateNormal];
    [moveBackwardButton setBackgroundImage:[UIImage imageNamed:@"arrow_select.png"] forState:UIControlStateHighlighted];
    [moveBackwardButton setTransform:CGAffineTransformMakeRotation(layoutHorizontal?-M_PI_2:0)];
    [moveBackwardButton addTarget:self action:@selector(tappedMoveBackwardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:changeItemButton];
    [self addSubview:removeItemButton];
    [self addSubview:moveForwardButton];
    [self addSubview:moveBackwardButton];
}

- (void)tappedChangeItemButton:(id)sender
{
    self.requestChangeItem();
}

- (void)tappedRemoveItemButton:(id)sender
{
    self.requestRemoveItem();
}

- (void)tappedMoveForwardButton:(id)sender
{
    self.requestMoveForward();
}

- (void)tappedMoveBackwardButton:(id)sender
{
    self.requestMoveBackward();
}


@end
