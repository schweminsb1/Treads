//
//  TripLocationItem.h
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ImageScrollDisplayableItem.h"

@interface TripLocationItem : NSObject<ImageScrollDisplayableItem>

+ (int)UNDEFINED_IMAGE_ID;

//identifiers
@property int tripLocationItemID; //id
@property int tripLocationID;

//data
@property int imageID;
@property (strong) UIImage* image;
@property (copy) NSString* description;

//only used for importing
@property int index;

@end
