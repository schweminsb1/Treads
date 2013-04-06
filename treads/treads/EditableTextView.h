//
//  EditableTextView.h
//  treads
//
//  Created by keavneyrj1 on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableTextView : UIView

- (id)initWithFont:(UIFont*)font edgeInset:(UIEdgeInsets)edgeInset restrictSingleLine:(BOOL)singleLine maxTextLength:(int)maxTextLength;

-(void) setText:(NSString*)newText;
@property (copy) void(^textWasChanged)(NSString* newText);

@property (copy) BOOL(^editingEnabled)();
@property (copy) void(^markChangeMade)();

@property (strong) UIColor* editingDisabledBackgroundColor;
@property (strong) UIColor* editingEnabledBackgroundColor;

@property (strong) UIColor* editingDisabledTextColor;
@property (strong) UIColor* editingEnabledTextColor;

@end
