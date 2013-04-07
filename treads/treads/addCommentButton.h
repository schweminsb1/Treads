//
//  addCommentButton.h
//  treads
//
//  Created by Sam Schwemin on 4/7/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addCommentButton : UIButton

- (void)initialise;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithFrame:(CGRect)frame;

@property NSString * commentText;

@end
