//
//  EditableTextView.m
//  treads
//
//  Created by keavneyrj1 on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "EditableTextView.h"

@interface EditableTextView()<UITextViewDelegate>

@end

@implementation EditableTextView  {
    BOOL layoutDone;
    UITextView* descriptionTextView;
    UIFont* textFont;
    UIEdgeInsets textEdgeInset;
    BOOL textSingleLine;
    int textMaxLength;
}

- (id)initWithFont:(UIFont*)font edgeInset:(UIEdgeInsets)edgeInset restrictSingleLine:(BOOL)singleLine maxTextLength:(int)maxTextLength
{
    self = [super init];
    if (self) {
        layoutDone = NO;
        textFont = font;
        textEdgeInset = edgeInset;
        textSingleLine = singleLine;
        textMaxLength = maxTextLength;
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
    BOOL __editingEnabled = self.editingEnabled();
    [descriptionTextView setEditable:__editingEnabled];
    if (__editingEnabled) {
        self.backgroundColor = self.editingEnabledBackgroundColor;
        descriptionTextView.textColor = self.editingEnabledTextColor;
    }
    else {
        self.backgroundColor = self.editingDisabledBackgroundColor;
        descriptionTextView.textColor = self.editingDisabledTextColor;
    }
    //[descriptionTextView setNeedsLayout];
}

- (void)createAndAddSubviews
{
    descriptionTextView = [[UITextView alloc] init];
    descriptionTextView.backgroundColor = [UIColor clearColor];
    descriptionTextView.font = textFont;
    descriptionTextView.textAlignment = NSTextAlignmentLeft;
    descriptionTextView.contentInset = textEdgeInset; //UIEdgeInsetsMake(-10, -7, 0, -7);
    descriptionTextView.scrollEnabled = NO;
    descriptionTextView.delegate = self;
    
    [self addSubview:descriptionTextView];
}

- (void)setText:(NSString *)newText
{
    if (!layoutDone) {
        [self layoutSubviews];
    }
    descriptionTextView.text = newText;
    descriptionTextView.contentOffset = CGPointMake(-descriptionTextView.contentInset.left, -descriptionTextView.contentInset.top);
    [self setNeedsLayout];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.textWasChanged(textView.text);
    self.markChangeMade();
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //end on newline if not allowered
    if (textSingleLine && [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    //don't allow users to go past the length limit
    NSString* combinedString = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (combinedString.length > textMaxLength) {
        return NO;
    }
    
    return YES;
}

@end
