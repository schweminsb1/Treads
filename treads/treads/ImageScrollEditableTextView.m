//
//  ImageScrollEditableTextView.m
//  treads
//
//  Created by keavneyrj1 on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "ImageScrollEditableTextView.h"

#import "EditableTextView.h"

@implementation ImageScrollEditableTextView {
    BOOL layoutDone;
    EditableTextView* descriptionTextView;
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
    [descriptionTextView setNeedsLayout];
}

- (void)createAndAddSubviews
{
    descriptionTextView = [[EditableTextView alloc] initWithFont:[UIFont systemFontOfSize:17]  edgeInset:UIEdgeInsetsMake(-10, -7, 0, -7) restrictSingleLine:NO maxTextLength:5000];
    descriptionTextView.editingDisabledBackgroundColor = [UIColor clearColor];
    descriptionTextView.editingEnabledBackgroundColor = [AppColors secondaryBackgroundColor];
    descriptionTextView.editingDisabledTextColor = [AppColors mainTextColor];
    descriptionTextView.editingEnabledTextColor = [AppColors mainTextColor];
    descriptionTextView.editingEnabled = self.editingEnabled;
    descriptionTextView.markChangeMade = self.markChangeMade;
    
    [self addSubview:descriptionTextView];
}

- (void)setDisplayItem:(NSObject *)displayItem index:(int)index
{
    displayIndex = index;
    if (!layoutDone) {
        [self layoutSubviews];
    }
    
    [descriptionTextView loseFocus];
    
    ImageScrollEditableTextView* __weak _self = self;
    
    if (displayItem) {
        descriptionTextView.text = (NSString*)displayItem;
        descriptionTextView.textWasChanged = ^(NSString* newText){_self.textWasChanged(newText, index);};
    }
    else {
        descriptionTextView.text = @"";
        descriptionTextView.textWasChanged = ^(NSString* newText){_self.textWasChanged(@"", 0);};
    }
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)newText
{
    [descriptionTextView setText:newText];
}

@end