//
//  ImageScrollBrowser.h
//  treads
//
//  Created by keavneyrj1 on 3/22/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageScrollDisplayView.h"

#import "ImageScrollDisplayableItem.h"

@interface ImageScrollBrowser : UIView

- (id)initWithImageSize:(CGSize)size displayView:(UIView<ImageScrollDisplayView>*)view addItemView:(UIView*)addView;

@property (assign, nonatomic) NSArray* displayItems;

//editing
//@property (strong) UIView* addItemView;
@property (copy) void(^sendNewItemRequest)();
- (void)addItemToDisplayView:(id<ImageScrollDisplayableItem>)item;
@property (copy) BOOL(^editingEnabled)();
@property (copy) void(^arrayWasChanged)(NSArray* newDisplayItems);

@end
