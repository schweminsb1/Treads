//
//  TripLocationItem.h
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TripLocationItem : NSObject

//identifiers
@property int tripLocationItemID; //id
@property int tripLocationID;

//data
@property (strong) UIImage* image;
@property (copy) NSString* description;

@end
