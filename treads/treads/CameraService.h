//
//  CameraService.h
//  treads
//
//  Created by Anthony DeLeone on 4/10/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface CameraService : NSObject

//- (void) showImagePicker;
//- (UIImage *) returnSelectedImage;

- (void)showImagePickerFromViewController:(UIViewController*)viewController onSuccess:(void(^)(UIImage*))onSuccess;

@end
