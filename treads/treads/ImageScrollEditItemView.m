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
    UIButton* changeItemButton;
    UIButton* removeItemButton;
    UIButton* moveForwardButton;
    UIButton* moveBackwardButton;
}

@synthesize requestChangeItem;
@synthesize requestRemoveItem;
@synthesize requestMoveForward;
@synthesize requestMoveBackward;

- (id)init
{
    self = [super init];
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
    [moveBackwardButton setFrame:CGRectMake(0, 0, self.bounds.size.width/4, self.bounds.size.height)];
    [moveForwardButton setFrame:CGRectMake(self.bounds.size.width*(0.25), 0, self.bounds.size.width/4, self.bounds.size.height)];
    [changeItemButton setFrame:CGRectMake(self.bounds.size.width*(0.5), 0, self.bounds.size.width/4, self.bounds.size.height)];
    [removeItemButton setFrame:CGRectMake(self.bounds.size.width*(0.75), 0, self.bounds.size.width/4, self.bounds.size.height)];
}

- (void)createAndAddSubviews
{
    changeItemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [changeItemButton setTitle:@"C" forState:UIControlStateNormal];
    [changeItemButton addTarget:self action:@selector(tappedChangeItemButton:) forControlEvents:UIControlEventTouchUpInside];
    
    removeItemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [removeItemButton setTitle:@"-" forState:UIControlStateNormal];
    [removeItemButton addTarget:self action:@selector(tappedRemoveItemButton:) forControlEvents:UIControlEventTouchUpInside];
    
    moveForwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [moveForwardButton setTitle:@">" forState:UIControlStateNormal];
    [moveForwardButton addTarget:self action:@selector(tappedMoveForwardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    moveBackwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [moveBackwardButton setTitle:@"<" forState:UIControlStateNormal];
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
