//
//  ImageScrollBrowser.h
//  treads
//
//  Created by keavneyrj1 on 3/22/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageScrollDisplayView.h"

@interface ImageScrollBrowser : UIView

- (id)initWithImageSize:(CGSize)size displayView:(UIView<ImageScrollDisplayView>*)view;

@property (assign, nonatomic) NSArray* displayItems;

@end
