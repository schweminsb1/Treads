//
//  ImageScrollBrowser.m
//  treads
//
//  Created by keavneyrj1 on 3/22/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "ImageScrollBrowser.h"

//#import "TripLocation.h"
//#import "TripLocationItem.h"

#import "ImageScrollDisplayableItem.h"

#import "AppColors.h"

@interface ImageScrollBrowser() <UIScrollViewDelegate>

@end

@implementation ImageScrollBrowser {
    BOOL layoutDone;
    UIScrollView* imageScrollView;
    UIImageView* imageScrollPaddingLeft;
    UIImageView* imageScrollPaddingRight;
    
    NSMutableArray* imageSubViews;
    int imageSubViewCount;
    CGSize imageSubViewSize;
    
    UITextView* descriptionTextView;
    int displayedTextIndex;
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
    [imageScrollView setFrame:CGRectMake(0, 0, self.bounds.size.width, imageSubViewSize.height)];
    [imageScrollPaddingLeft setFrame:CGRectMake(0, 0, (self.bounds.size.width-imageSubViewSize.width)/2, imageScrollView.bounds.size.height)];
    [imageScrollPaddingRight setFrame:CGRectMake(imageSubViewCount*imageSubViewSize.width + imageScrollPaddingLeft.bounds.size.width, 0, (self.bounds.size.width-imageSubViewSize.width)/2, imageScrollView.bounds.size.height)];
    
    for (int i=0; i<imageSubViews.count; i++) {
        UIImageView* imageSubView = (UIImageView*)imageSubViews[i];
        [imageSubView setFrame:CGRectMake(i*imageSubViewSize.width + imageScrollPaddingLeft.bounds.size.width, 0, imageSubViewSize.width, imageSubViewSize.height)];
    }
    
    [descriptionTextView setFrame:CGRectMake(20, 376, self.bounds.size.width - 40, self.bounds.size.height - 392)];
    [imageScrollView setContentSize:CGSizeMake(imageSubViewCount*imageSubViewSize.width + imageScrollPaddingLeft.bounds.size.width*2, imageScrollView.bounds.size.height)];
}

- (void)createAndAddSubviews
{
    imageSubViewCount = 0;
    imageSubViewSize = CGSizeMake(540, 360);
    
    imageScrollView = [[UIScrollView alloc] init];
    imageScrollView.backgroundColor = [AppColors blankItemBackgroundColor];
    
    imageScrollView.delegate = self;
    
    imageScrollPaddingLeft = [[UIImageView alloc] init];
    imageScrollPaddingLeft.backgroundColor = [AppColors blankItemBackgroundColor];
    
    imageScrollPaddingRight = [[UIImageView alloc] init];
    imageScrollPaddingRight.backgroundColor = [AppColors blankItemBackgroundColor];
    
    [imageScrollView addSubview:imageScrollPaddingLeft];
    [imageScrollView addSubview:imageScrollPaddingRight];
    
    imageSubViews = [[NSMutableArray alloc] init];
    
    descriptionTextView = [[UITextView alloc] init];
    descriptionTextView.backgroundColor = [UIColor clearColor];
    descriptionTextView.font = [UIFont systemFontOfSize: 17];
    descriptionTextView.textColor = [AppColors mainTextColor];
    descriptionTextView.textAlignment = NSTextAlignmentLeft;
    descriptionTextView.editable = false;
    descriptionTextView.contentInset = UIEdgeInsetsMake(-10, -7, 0, -7);
    
    displayedTextIndex = -1;
    
    [self addSubview:imageScrollView];
    [self addSubview:descriptionTextView];
}

- (void)setDisplayItems:(NSArray *)displayItems
{
    _displayItems = displayItems;
    
    if (!layoutDone) {
        [self layoutSubviews];
        //[self setNeedsLayout];
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
        imageSubView.contentMode = UIViewContentModeScaleAspectFill;
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
    
    //descriptionTextView.text = [NSString stringWithFormat:@"SubViewCount: %d || Picture descriptions will go here: %@", imageSubViewCount, tripLocation.description];
    imageScrollView.contentOffset = CGPointZero;
    descriptionTextView.contentOffset = CGPointMake(-descriptionTextView.contentInset.left, -descriptionTextView.contentInset.top);
    
    displayedTextIndex = -1;
    [self setDescriptionDisplayToIndex:0];
    
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
    if (displayedTextIndex != index && index >= 0 && index < self.displayItems.count) {
        id<ImageScrollDisplayableItem> displayItem = (id<ImageScrollDisplayableItem>)self.displayItems[index];
        displayedTextIndex = index;
        descriptionTextView.text = (NSString*)[displayItem displayItem];
        descriptionTextView.contentOffset = CGPointMake(-descriptionTextView.contentInset.left, -descriptionTextView.contentInset.top);
        
        //[descriptionTextView setNeedsDisplay];
        [self setNeedsLayout];
    }
    else if (self.displayItems.count == 0) {
        displayedTextIndex = -1;
        descriptionTextView.text = @"";
        descriptionTextView.contentOffset = CGPointMake(-descriptionTextView.contentInset.left, -descriptionTextView.contentInset.top);
        
        //[descriptionTextView setNeedsDisplay];
        [self setNeedsLayout];
    }
}

@end
