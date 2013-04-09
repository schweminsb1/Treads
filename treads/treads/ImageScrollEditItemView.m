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
}

- (void)createAndAddSubviews
{
////    ImageScrollEditItemView* __weak _self = self;
//    descriptionTextView = [[EditableTextView alloc] initWithFont:[UIFont systemFontOfSize:17]  edgeInset:UIEdgeInsetsMake(-10, -7, 0, -7) restrictSingleLine:NO maxTextLength:5000];
//    descriptionTextView.editingDisabledBackgroundColor = [UIColor clearColor];
//    descriptionTextView.editingEnabledBackgroundColor = [AppColors secondaryBackgroundColor];
//    descriptionTextView.editingDisabledTextColor = [AppColors mainTextColor];
//    descriptionTextView.editingEnabledTextColor = [AppColors mainTextColor];
//    descriptionTextView.editingEnabled = ^BOOL(){return _self.editingEnabled() && [_self getDisplayItemIsValid];};
//    descriptionTextView.markChangeMade = self.markChangeMade;
//    
//    [self addSubview:descriptionTextView];
}


@end
