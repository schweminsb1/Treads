//
//  ImageScrollBrowser.m
//  treads
//
//  Created by keavneyrj1 on 3/22/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "ImageScrollBrowser.h"

#import "ImageScrollDisplayableItem.h"
#import "ImageScrollDisplayView.h"

#import "AppColors.h"

@interface ImageScrollBrowser() <UIScrollViewDelegate>

@end

@implementation ImageScrollBrowser {
    BOOL layoutDone;
    BOOL resetOnDisplay;
    BOOL gotoLastItem;
    BOOL isAnimatingItemRemove;
    BOOL isAnimatingItemSwap;
    UIScrollView* imageScrollView;
    UIImageView* imageScrollPaddingLeft;
    UIImageView* imageScrollPaddingRight;
    UIImageView* imageScrollPaddingRemoval;
    
    NSMutableArray* imageSubViews;
    int imageSubViewCount;
    CGSize imageSubViewSize;
    
    UIView<ImageScrollDisplayView>* displayView;
    UIView* addItemView;
    UIView* emptySetView;
    UIView<EditControlsView>* editItemView;
    int displayedTextIndex;
}

- (id)initWithImageSize:(CGSize)size displayView:(UIView<ImageScrollDisplayView>*)initializedDisplayView addItemView:(UIView*)addView emptySetView:(UIView*) emptyView editItemView:(UIView<EditControlsView>*)editView
{
    self = [super init];
    if (self) {
        layoutDone = NO;
        resetOnDisplay = YES;
        gotoLastItem = NO;
        isAnimatingItemRemove = NO;
        isAnimatingItemSwap = NO;
        imageSubViewSize = size;
        displayView = initializedDisplayView;
        addItemView = addView;
        emptySetView = emptyView;
        editItemView = editView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //set up subviews if layout has not been set
    if (!layoutDone) {
        [self createAndAddSubviews];
        layoutDone = YES;
    }
    
    BOOL __editingEnabled = self.editingEnabled();
    int additionalCells = (__editingEnabled&&addItemView!=nil)?1:0;
    
    CGPoint offset = imageScrollView.contentOffset;
    
    //set frames of subviews
    [imageScrollView setFrame:CGRectMake(0, 0, self.bounds.size.width, imageSubViewSize.height)];
    [imageScrollPaddingLeft setFrame:CGRectMake(0, 0, (self.bounds.size.width-imageSubViewSize.width)/2, imageScrollView.bounds.size.height)];
    [imageScrollPaddingRight setFrame:CGRectMake((imageSubViewCount+additionalCells)*imageSubViewSize.width + (self.bounds.size.width-imageSubViewSize.width)/2, 0, (self.bounds.size.width-imageSubViewSize.width)/2, imageScrollView.bounds.size.height)];
    
    for (int i=0; i<imageSubViews.count; i++) {
        UIImageView* imageSubView = (UIImageView*)imageSubViews[i];
        [imageSubView setFrame:CGRectMake(i*imageSubViewSize.width + imageScrollPaddingLeft.bounds.size.width, 0, imageSubViewSize.width, imageSubViewSize.height)];
    }
    
    //if editing is enabled and the views exist, set frames
    //of add item view and edit item view
    if (addItemView) {
        [addItemView setHidden:!__editingEnabled];
        if (__editingEnabled) {
            [addItemView setFrame:CGRectMake(imageSubViews.count*imageSubViewSize.width + imageScrollPaddingLeft.bounds.size.width, 0, imageSubViewSize.width, imageSubViewSize.height)];
        }
    }
    if (editItemView) {
        BOOL showEditItemView = __editingEnabled && (!emptySetView || imageSubViewCount > 0);
        [editItemView setHidden:!showEditItemView];
        if (showEditItemView) {
            [editItemView setFrame:CGRectMake(self.bounds.size.width/2 - 156, imageSubViewSize.height - 60, 318, 50)];
        }
    }
    if (emptySetView) {
        BOOL showEmptySetView = __editingEnabled && imageSubViewCount == 0;
        [emptySetView setHidden:!showEmptySetView];
        if (showEmptySetView) {
            [emptySetView setFrame:CGRectMake(self.bounds.size.width/2 - emptySetView.bounds.size.width/2, imageSubViewSize.height - emptySetView.bounds.size.height - 10, emptySetView.bounds.size.width, emptySetView.bounds.size.height)];
        }
    }

    //resize the scroll view and display view
    [imageScrollView setContentSize:CGSizeMake((imageSubViewCount+additionalCells)*imageSubViewSize.width + imageScrollPaddingLeft.bounds.size.width + imageScrollPaddingRight.bounds.size.width + (isAnimatingItemRemove?imageScrollPaddingRemoval.bounds.size.width:0), imageScrollView.bounds.size.height)];
    [displayView setFrame:CGRectMake(0, imageSubViewSize.height, self.bounds.size.width, self.bounds.size.height - imageSubViewSize.height)];
    [displayView setNeedsLayout];
    
    int contentSize = imageScrollView.contentSize.width - imageScrollView.bounds.size.width;
    if (offset.x > contentSize && contentSize >= 0) {
        offset = CGPointMake(contentSize, offset.y);
    }
    [imageScrollView setContentOffset:offset];
}

- (void)createAndAddSubviews
{
    //scroll view
    imageScrollView = [[UIScrollView alloc] init];
    imageScrollView.backgroundColor = [AppColors blankItemBackgroundColor];
    imageScrollView.delegate = self;
    UITapGestureRecognizer* moveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewItemWasTapped:)];
    [imageScrollView addGestureRecognizer:moveTap];
    [self addSubview:imageScrollView];
    
    //padding
    imageScrollPaddingLeft = [[UIImageView alloc] init];
    imageScrollPaddingLeft.backgroundColor = [AppColors blankItemBackgroundColor];
    imageScrollPaddingRight = [[UIImageView alloc] init];
    imageScrollPaddingRight.backgroundColor = [AppColors blankItemBackgroundColor];
    imageScrollPaddingRemoval = [[UIImageView alloc] init];
    imageScrollPaddingRemoval.backgroundColor = [AppColors blankItemBackgroundColor];
    [imageScrollPaddingRemoval setHidden:YES];
    [imageScrollPaddingRemoval setFrame:CGRectZero];
    
    [imageScrollView addSubview:imageScrollPaddingLeft];
    [imageScrollView addSubview:imageScrollPaddingRight];
    [imageScrollView addSubview:imageScrollPaddingRemoval];
    
    //add item view
    if (addItemView != nil) {
        [imageScrollView addSubview:addItemView];
    }
    
    //image subviews
    imageSubViews = [[NSMutableArray alloc] init];
    imageSubViewCount = 0;
    displayedTextIndex = -1;
    
    //display view
    [self addSubview:displayView];
    
    ImageScrollBrowser* __weak _self = self;
    
    //edit item view
    if (editItemView) {
        editItemView.requestChangeItem = ^(){[_self requestedChangeItem];};
        editItemView.requestRemoveItem = ^(){[_self requestedRemoveItem];};
        editItemView.requestAddItem = ^(){[_self requestedAddItem];};
        editItemView.requestFavoriteItem = ^(){[_self requestedFavoriteItem];};
        editItemView.requestMoveForward = ^(){[_self requestedMoveForward];};
        editItemView.requestMoveBackward = ^(){[_self requestedMoveBackward];};
        
        [self addSubview:editItemView];
        [self bringSubviewToFront:editItemView];
    }
    
    //empty set view
    if (emptySetView) {
        [self addSubview:emptySetView];
    }
}

- (void)setDisplayItems:(NSArray *)displayItems
{
    if (_displayItems == displayItems) {
        resetOnDisplay = NO;
    }
    _displayItems = displayItems;
    
    if (!layoutDone) {
        [self layoutSubviews];
    }
    
    //assign new trip location items to existing subviews
    for (int i=0; i<imageSubViews.count; i++) {
        //break if there are no more items to be added
        if (i >= displayItems.count) {break;}
        //copy image to image view
        id<ImageScrollDisplayableItem> displayItem = (id<ImageScrollDisplayableItem>)displayItems[i];
        UIImageView* imageSubView = (UIImageView*)imageSubViews[i];
        imageSubView.image = [displayItem displayImage];
    }
    
    //expand the subview array if needed
    for (int i=imageSubViews.count; i<displayItems.count; i++) {
        id<ImageScrollDisplayableItem> displayItem = (id<ImageScrollDisplayableItem>)displayItems[i];
        UIImageView* imageSubView = [[UIImageView alloc] init];
        imageSubView.contentMode = UIViewContentModeScaleAspectFit;
        imageSubView.clipsToBounds = YES;
        imageSubView.image = [displayItem displayImage];
        [imageSubViews addObject:imageSubView];
        [imageScrollView addSubview:imageSubView];
    }
    
    //remove extra unused subviews
    for (int i=((NSInteger)imageSubViews.count)-1; i>=(NSInteger)displayItems.count; i--) {
        [((UIImageView*)imageSubViews[i]) removeFromSuperview];
        [imageSubViews removeObjectAtIndex:i];
    }
    imageSubViewCount = imageSubViews.count;
    
    if (resetOnDisplay) {
        imageScrollView.contentOffset = CGPointZero;
        displayedTextIndex = -1;
        [self setDescriptionDisplayToIndex:0];
    }
    else {
        if (gotoLastItem || imageScrollView.contentOffset.x / imageSubViewSize.width == displayedTextIndex) {
            displayedTextIndex--;
            [self setDescriptionDisplayToIndex:displayedTextIndex+1];
        }
    }
    
    resetOnDisplay = YES;
    gotoLastItem = NO;
    
    [imageScrollView bringSubviewToFront:imageScrollPaddingRemoval];
    
    [self setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int scrollCenter = scrollView.contentOffset.x + imageScrollView.bounds.size.width / 2 - imageScrollPaddingLeft.bounds.size.width;
    scrollCenter /= imageSubViewSize.width;
    if (scrollCenter != displayedTextIndex) {
        [self setDescriptionDisplayToIndex:scrollCenter];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //move scrollview to nearest image center
    int scrollCenter = targetContentOffset->x + imageScrollView.bounds.size.width / 2 - imageScrollPaddingLeft.bounds.size.width;
    scrollCenter /= imageSubViewSize.width;
    targetContentOffset->x = scrollCenter*imageSubViewSize.width;
}

- (void)setDescriptionDisplayToIndex:(int)index
{
    if (displayView != nil && !isAnimatingItemSwap) {
        if (displayedTextIndex != index && index >= 0 && index < self.displayItems.count) {
            id<ImageScrollDisplayableItem> displayItem = (id<ImageScrollDisplayableItem>)self.displayItems[index];
            displayedTextIndex = index;
            [displayView setDisplayItem:[displayItem displayItem] index:index];
            [self setNeedsLayout];
        }
        else if (self.displayItems.count == 0 /*|| (self.editingEnabled()&&index==self.displayItems.count)*/) {
            displayedTextIndex = -1;
            [displayView setDisplayItem:nil index:-1];
            [self setNeedsLayout];
        }
        else if (self.editingEnabled()&&index==self.displayItems.count) {
            displayedTextIndex = index;
            [displayView setDisplayItem:nil index:index];
            [self setNeedsLayout];
        }
    }
}

- (void)viewItemWasTapped:(UITapGestureRecognizer *)recognizer
{
    //scrolls to item
    CGPoint tapLocation = [recognizer locationInView:imageScrollView];
    int relativeXLocation = tapLocation.x - imageScrollPaddingLeft.bounds.size.width;
    int tappedIndex = relativeXLocation / imageSubViewSize.width;
    
    BOOL canScrollToAddItemView = addItemView && !addItemView.hidden;
    
    if (tappedIndex >= 0 && (tappedIndex < imageSubViewCount || (tappedIndex == imageSubViewCount && canScrollToAddItemView))) {
        [imageScrollView setContentOffset:CGPointMake(tappedIndex*imageSubViewSize.width, 0) animated:YES];
    }
        
    //sends item request if appropriate
    if (tappedIndex == imageSubViewCount && canScrollToAddItemView) {
        self.sendNewItemRequest(imageSubViewCount, YES);
    }
}

- (void)setDisplayViewItem:(id<ImageScrollDisplayableItem>)item atIndex:(int)index replaceItem:(BOOL)replaceItem
{
    if (index >= imageSubViewCount || index < 0) {
        if (index > imageSubViewCount) {index = imageSubViewCount;}
        [self addItemToDisplayView:item];
    }
    else {
        //replace item
        NSMutableArray* temp = [NSMutableArray arrayWithArray:self.displayItems];
        if (replaceItem) {
            temp[index] = item;
        }
        else {
            [temp insertObject:item atIndex:index];
        }
        resetOnDisplay = NO;
        self.arrayWasChanged(temp);
        self.displayItems = temp;
    }
    [imageScrollView setContentOffset:CGPointMake(index*imageSubViewSize.width, 0) animated:YES];
}

- (void)addItemToDisplayView:(id<ImageScrollDisplayableItem>)item
{
    NSMutableArray* temp = [NSMutableArray arrayWithArray:self.displayItems];
    [temp addObject:item];
    resetOnDisplay = NO;
    gotoLastItem = YES;
    displayedTextIndex = self.displayItems.count;
    self.arrayWasChanged(temp);
    self.displayItems = temp;
}

- (void)requestedChangeItem
{
    self.sendNewItemRequest(displayedTextIndex, YES);
}

- (void)requestedRemoveItem
{
    if (displayedTextIndex < imageSubViewCount && imageSubViewCount > 0) {
        //remove item from list
        id<ImageScrollDisplayableItem>item = self.displayItems[displayedTextIndex];
        NSMutableArray* temp = [NSMutableArray arrayWithArray:self.displayItems];
        [temp removeObject:item];
        BOOL showHideAnimation = YES;
        if (displayedTextIndex >= temp.count) {
            displayedTextIndex = temp.count - 1;
            showHideAnimation = NO;
            gotoLastItem = YES;
        }
        resetOnDisplay = NO;
        self.arrayWasChanged(temp);
        self.displayItems = temp;
        if (showHideAnimation) {
            [self startHideAnimation];
        }
    }
}

- (void)requestedAddItem
{
    self.sendNewItemRequest(displayedTextIndex+1, NO);
}

- (void)requestedFavoriteItem
{
    if (displayedTextIndex >= 0 && displayedTextIndex < self.displayItems.count) {
        self.sendFavoriteItemRequest(self.displayItems[displayedTextIndex]);
    }
}

- (void)requestedMoveForward
{
    if (!isAnimatingItemSwap && displayedTextIndex < imageSubViewCount - 1) {
        NSMutableArray* temp = [NSMutableArray arrayWithArray:self.displayItems];
        [temp exchangeObjectAtIndex:displayedTextIndex withObjectAtIndex:displayedTextIndex+1];
        resetOnDisplay = NO;
        displayedTextIndex++;
        self.arrayWasChanged(temp);
        self.displayItems = temp;
        [self performSelectorOnMainThread:@selector(startSwapAnimationWithIndices:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:displayedTextIndex], [NSNumber numberWithInt:(displayedTextIndex-1)], nil] waitUntilDone:NO];
    }
}

- (void)requestedMoveBackward
{
    if (!isAnimatingItemSwap && displayedTextIndex > 0 && displayedTextIndex < imageSubViewCount) {
        NSMutableArray* temp = [NSMutableArray arrayWithArray:self.displayItems];
        [temp exchangeObjectAtIndex:displayedTextIndex withObjectAtIndex:displayedTextIndex-1];
        resetOnDisplay = NO;
        displayedTextIndex--;
        self.arrayWasChanged(temp);
        self.displayItems = temp;
        [self performSelectorOnMainThread:@selector(startSwapAnimationWithIndices:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:displayedTextIndex], [NSNumber numberWithInt:(displayedTextIndex+1)], nil] waitUntilDone:NO];
    }
}

- (void)startHideAnimation
{
    //show placeholder and animate
    [imageScrollPaddingRemoval setFrame:CGRectMake(imageScrollPaddingLeft.bounds.size.width + imageSubViewSize.width * displayedTextIndex, 0, imageSubViewSize.width, imageSubViewSize.height)];
    [imageScrollPaddingRemoval setHidden:NO];
    isAnimatingItemRemove = YES;
    for (int i=displayedTextIndex; i<imageSubViews.count; i++) {
        UIImageView* imageSubView = (UIImageView*)imageSubViews[i];
        [imageSubView setFrame:CGRectMake((i+1)*imageSubViewSize.width + imageScrollPaddingLeft.bounds.size.width, 0, imageSubViewSize.width, imageSubViewSize.height)];
    }
    BOOL __editingEnabled = self.editingEnabled();
    if (addItemView!=nil) {
        [addItemView setHidden:!__editingEnabled];
        if (__editingEnabled) {
            [addItemView setFrame:CGRectMake((imageSubViews.count+2)*imageSubViewSize.width + imageScrollPaddingLeft.bounds.size.width, 0, imageSubViewSize.width, imageSubViewSize.height)];
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        [imageScrollPaddingRemoval setFrame:CGRectMake(imageScrollPaddingLeft.bounds.size.width + imageSubViewSize.width * displayedTextIndex, 0, 0, imageSubViewSize.height)];
        for (int i=displayedTextIndex; i<imageSubViews.count; i++) {
            UIImageView* imageSubView = (UIImageView*)imageSubViews[i];
            [imageSubView setFrame:CGRectMake(i*imageSubViewSize.width + imageScrollPaddingLeft.bounds.size.width, 0, imageSubViewSize.width, imageSubViewSize.height)];
        }
        if (addItemView!=nil) {
            [addItemView setHidden:!__editingEnabled];
            if (__editingEnabled) {
                [addItemView setFrame:CGRectMake((imageSubViews.count+1)*imageSubViewSize.width + imageScrollPaddingLeft.bounds.size.width, 0, imageSubViewSize.width, imageSubViewSize.height)];
            }
        }
    } completion:^(BOOL finished) {
        [imageScrollPaddingRemoval setHidden:YES];
        isAnimatingItemRemove = NO;
    }];
}

- (void)startSwapAnimationWithIndices:(NSArray*)indices
{
    UIImageView* imageSubView1 = (UIImageView*)imageSubViews[[indices[0] intValue]];
    UIImageView* imageSubView2 = (UIImageView*)imageSubViews[[indices[1] intValue]];
    [imageScrollView bringSubviewToFront:imageSubView1];
    CGRect frame1 = imageSubView1.frame;
    CGRect frame2 = imageSubView2.frame;
    [imageSubView1 setFrame:frame2];
    [imageSubView2 setFrame:frame1];
    isAnimatingItemSwap = YES;
    [imageScrollView setContentOffset:CGPointMake(displayedTextIndex*imageSubViewSize.width, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [imageSubView1 setFrame:frame1];
        [imageSubView2 setFrame:frame2];
    } completion:^(BOOL finished) {
        isAnimatingItemSwap = NO;
    }];
}

@end
