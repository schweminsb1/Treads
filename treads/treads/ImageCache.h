//
//  ImageCache.h
//  treads
//
//  Created by keavneyrj1 on 4/14/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCache : NSObject

+ (ImageCache*) sharedCache;

- (void)cacheImage:(UIImage*)image withID:(int)index;
- (UIImage*)tryReadImageFromCacheWithID:(int)index;

@end
