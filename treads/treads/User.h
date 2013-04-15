//
//  User.h
//  treads
//
//  Created by Sam Schwemin on 4/4/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property int User_ID;
@property NSString * emailaddress;
@property NSString * fname;
@property NSString * lname;
@property int profilePhotoID;
@property int coverPhotoID;
@property NSString * password;

@property (strong) UIImage* profileImage;
@property (strong) UIImage* coverImage;

@end
