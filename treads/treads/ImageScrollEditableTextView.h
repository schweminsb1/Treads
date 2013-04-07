//
//  ImageScrollEditableTextView.h
//  treads
//
//  Created by keavneyrj1 on 4/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageScrollDisplayView.h"

@interface ImageScrollEditableTextView : UIView<ImageScrollDisplayView> 

//editing
//-(void) setText:(NSString*)newText;
@property (copy) void(^textWasChanged)(NSString* newText, int index);

@property (copy) BOOL(^editingEnabled)();
@property (copy) void(^markChangeMade)();

@end
