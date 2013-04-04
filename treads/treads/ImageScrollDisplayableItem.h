//
//  ImageScrollDisplayableItem.h
//  treads
//
//  Created by keavneyrj1 on 4/3/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageScrollDisplayableItem <NSObject>

@required
- (UIImage*)displayImage;
- (NSObject*)displayItem;

@end
