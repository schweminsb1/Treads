//
//  EditableTextView.h
//  treads
//
//  Created by keavneyrj1 on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableTextView : UIView

@property (nonatomic) NSString* editableText;

@property (copy) BOOL(^editingEnabled)();
@property (copy) void(^markChangeMade)();

@end
