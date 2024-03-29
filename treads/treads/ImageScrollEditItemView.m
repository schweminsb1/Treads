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
    BOOL showFavorite;
    UIButton* changeItemButton;
    UIButton* removeItemButton;
    UIButton* moveForwardButton;
    UIButton* moveBackwardButton;
    UIButton* addItemButton;
    UIButton* favoriteItemButton;
}

@synthesize requestChangeItem;
@synthesize requestRemoveItem;
@synthesize requestAddItem;
@synthesize requestFavoriteItem;
@synthesize requestMoveForward;
@synthesize requestMoveBackward;

- (id)initDisplaysHorizontally:(BOOL)horizontal showFavorite:(BOOL)favorite
{
    self = [super init];
    if (self) {
        layoutDone = NO;
        layoutHorizontal = horizontal;
        showFavorite = favorite;
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
    CGFloat multiplier = 1.0/(showFavorite?6.0:5.0);
    CGFloat xOffset = (layoutHorizontal?self.bounds.size.width:0);
    CGFloat yOffset = (layoutHorizontal?0:self.bounds.size.height);
    CGFloat scale = (layoutHorizontal?self.bounds.size.height:self.bounds.size.width);
    CGFloat xPadding = (layoutHorizontal?(self.bounds.size.width*multiplier - scale)*0.5:0);
    CGFloat yPadding = (layoutHorizontal?0:(self.bounds.size.width*multiplier - scale)*0.5);
    [removeItemButton setFrame:CGRectMake(xPadding, yPadding, scale, scale)];
    [addItemButton setFrame:CGRectMake(xPadding + xOffset*(multiplier), yPadding + yOffset*(multiplier), scale, scale)];
    [moveBackwardButton setFrame:CGRectMake(xPadding + xOffset*(2*multiplier), yPadding + yOffset*(2*multiplier), scale, scale)];
    [moveForwardButton setFrame:CGRectMake(xPadding + xOffset*(3*multiplier), yPadding + yOffset*(3*multiplier), scale, scale)];
    [changeItemButton setFrame:CGRectMake(xPadding + xOffset*(4*multiplier), yPadding + yOffset*(4*multiplier), scale, scale)];
    if (showFavorite) {
        [favoriteItemButton setFrame:CGRectMake(xPadding + xOffset*(5*multiplier), yPadding + yOffset*(5*multiplier), scale, scale)];
    }
}

- (void)createAndAddSubviews
{
    changeItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeItemButton setBackgroundImage:[UIImage imageNamed:@"button_blue_unselect.png"] forState:UIControlStateNormal];
    [changeItemButton setBackgroundImage:[UIImage imageNamed:@"button_blue_select.png"] forState:UIControlStateHighlighted];
    [changeItemButton setImage:[UIImage imageNamed:@"icon_pencil.png"] forState:UIControlStateNormal];
    [changeItemButton setImage:[UIImage imageNamed:@"icon_pencil.png"] forState:UIControlStateHighlighted];
    [changeItemButton addTarget:self action:@selector(tappedChangeItemButton:) forControlEvents:UIControlEventTouchUpInside];
    
    removeItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeItemButton setBackgroundImage:[UIImage imageNamed:@"button_blue_unselect.png"] forState:UIControlStateNormal];
    [removeItemButton setBackgroundImage:[UIImage imageNamed:@"button_blue_select.png"] forState:UIControlStateHighlighted];
    [removeItemButton setImage:[UIImage imageNamed:@"icon_minus.png"] forState:UIControlStateNormal];
    [removeItemButton setImage:[UIImage imageNamed:@"icon_minus.png"] forState:UIControlStateHighlighted];
    [removeItemButton addTarget:self action:@selector(tappedRemoveItemButton:) forControlEvents:UIControlEventTouchUpInside];
    
    moveForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moveForwardButton setBackgroundImage:[UIImage imageNamed:@"button_blue_unselect.png"] forState:UIControlStateNormal];
    [moveForwardButton setBackgroundImage:[UIImage imageNamed:@"button_blue_select.png"] forState:UIControlStateHighlighted];
    [moveForwardButton setImage:[UIImage imageNamed:@"icon_arrow.png"] forState:UIControlStateNormal];
    [moveForwardButton setImage:[UIImage imageNamed:@"icon_arrow.png"] forState:UIControlStateHighlighted];
    [moveForwardButton.imageView setTransform:CGAffineTransformMakeRotation(layoutHorizontal?M_PI_2:M_PI)];
    [moveForwardButton addTarget:self action:@selector(tappedMoveForwardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    moveBackwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moveBackwardButton setBackgroundImage:[UIImage imageNamed:@"button_blue_unselect.png"] forState:UIControlStateNormal];
    [moveBackwardButton setBackgroundImage:[UIImage imageNamed:@"button_blue_select.png"] forState:UIControlStateHighlighted];
    [moveBackwardButton setImage:[UIImage imageNamed:@"icon_arrow.png"] forState:UIControlStateNormal];
    [moveBackwardButton setImage:[UIImage imageNamed:@"icon_arrow.png"] forState:UIControlStateHighlighted];
    [moveBackwardButton.imageView setTransform:CGAffineTransformMakeRotation(layoutHorizontal?-M_PI_2:0)];
    [moveBackwardButton addTarget:self action:@selector(tappedMoveBackwardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    addItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addItemButton setBackgroundImage:[UIImage imageNamed:@"button_blue_unselect.png"] forState:UIControlStateNormal];
    [addItemButton setBackgroundImage:[UIImage imageNamed:@"button_blue_select.png"] forState:UIControlStateHighlighted];
    [addItemButton setImage:[UIImage imageNamed:@"icon_plus.png"] forState:UIControlStateNormal];
    [addItemButton setImage:[UIImage imageNamed:@"icon_plus.png"] forState:UIControlStateHighlighted];
    [addItemButton addTarget:self action:@selector(tappedAddItemButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:changeItemButton];
    [self addSubview:removeItemButton];
    [self addSubview:moveForwardButton];
    [self addSubview:moveBackwardButton];
    [self addSubview:addItemButton];
    
    if (showFavorite) {
        favoriteItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [favoriteItemButton setBackgroundImage:[UIImage imageNamed:@"button_blue_unselect.png"] forState:UIControlStateNormal];
        [favoriteItemButton setBackgroundImage:[UIImage imageNamed:@"button_blue_select.png"] forState:UIControlStateHighlighted];
        [favoriteItemButton setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
        [favoriteItemButton setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateHighlighted];
        [favoriteItemButton addTarget:self action:@selector(tappedFavoriteItemButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:favoriteItemButton];
    }
}

- (void)tappedChangeItemButton:(id)sender
{
    self.requestChangeItem();
}

- (void)tappedRemoveItemButton:(id)sender
{
    self.requestRemoveItem();
}

- (void)tappedAddItemButton:(id)sender
{
    self.requestAddItem();
}

- (void)tappedFavoriteItemButton:(id)sender
{
    self.requestFavoriteItem();
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
