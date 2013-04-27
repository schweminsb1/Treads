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
#import "EditControlsView.h"

@interface ImageScrollBrowser : UIView

- (id)initWithImageSize:(CGSize)size displayView:(UIView<ImageScrollDisplayView>*)initializedDisplayView addItemView:(UIView*)addView emptySetView:(UIView*) emptyView editItemView:(UIView<EditControlsView>*)editView;

@property (assign, nonatomic) NSArray* displayItems;

//editing
//@property (strong) UIView* addItemView;
@property (copy) void(^sendNewItemRequest)(int index, BOOL replaceItem);
//@property (copy) void(^sendAddItemRequest)(int index);
@property (copy) void(^sendFavoriteItemRequest)(id<ImageScrollDisplayableItem>);
- (void)setDisplayViewItem:(id<ImageScrollDisplayableItem>)item atIndex:(int)index replaceItem:(BOOL)replaceItem;
@property (copy) BOOL(^editingEnabled)();
@property (copy) void(^arrayWasChanged)(NSArray* newDisplayItems);

@end
