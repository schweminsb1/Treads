//
//  ImageCache.m
//  treads
//
//  Created by keavneyrj1 on 4/14/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache {
    NSMutableArray* images;
    int insertCacheIndex;
    int maxCacheItems;
}

- (id)init {
    if (self = [super init])
    {
        images = [[NSMutableArray alloc] init];
        insertCacheIndex = 0;
        maxCacheItems = 50;
    }
    return self;
}

static ImageCache* cache;
+ (ImageCache*) sharedCache {
    @synchronized(self) {
        if (!cache)
            cache = [[ImageCache alloc] init];
        return cache;
    }
}

- (void)cacheImage:(UIImage *)image withID:(int)index
{
    @synchronized(self) {
        if (images.count < maxCacheItems) {
            [images addObject:@{@"image":image, @"index":@(index)}];
        }
        else {
            images[insertCacheIndex] = @{@"image":image, @"index":@(index)};
        }
        insertCacheIndex++;
        if (insertCacheIndex >= maxCacheItems) {
            insertCacheIndex = 0;
        }
    }
}

- (UIImage*)tryReadImageFromCacheWithID:(int)index
{
    @synchronized(self) {
        for (NSDictionary* entry in images) {
            if ([entry[@"index"] intValue] == index) {
                return entry[@"image"];
            }
        }
    }
    return nil;
}

@end
