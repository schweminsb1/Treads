//
//  ImageScrollDisplayView.h
//  treads
//
//  Created by keavneyrj1 on 4/3/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageScrollDisplayView <NSObject>

@required
- (void)setDisplayItem:(NSObject*)displayItem index:(int)index;

@end
