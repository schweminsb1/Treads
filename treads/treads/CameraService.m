//
//  CameraService.m
//  treads
//
//  Created by Anthony DeLeone on 4/10/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.


#import "CameraService.h"
#import "AppDelegate.h"

@interface CameraService ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, copy)void(^onSuccessImage)(UIImage*);
@end

@implementation CameraService
BOOL doneTakingPictures;
BOOL newMedia;
UIImagePickerController *imagePicker;
UIPopoverController* popover;
UIImage* selectedImage;

static CameraService* repo;
+(CameraService*) instance {
    @synchronized(self) {
        if (!repo)
            repo = [[CameraService alloc] init];
        return repo;
    }
}

- (void)showImagePickerFromViewController:(UIViewController*)viewController onSuccess:(void(^)(UIImage*))onSuccess
{
      [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    // check if the device is an iPad and use a popover controller to display the image picker
   if([[UIDevice currentDevice]userInterfaceIdiom]== UIUserInterfaceIdiomPad)
    {
        if ([popover isPopoverVisible])
        {
            [popover dismissPopoverAnimated:YES];
        }
        else
        {
            // if the photo album is available use that as the source for photo selection
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                imagePicker.delegate = self;
                imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
                popover = [[UIPopoverController alloc] initWithContentViewController: imagePicker];
                popover.delegate = self;
                [popover presentPopoverFromRect:CGRectMake(0,0,300,300)inView:viewController.view permittedArrowDirections:0 animated:YES];
            }
        }
    }
    // if the device is not an iPad
    else
    {
        [imagePicker presentViewController: imagePicker animated:YES completion:nil];
    }
    self.onSuccessImage = onSuccess;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // when the user has selected the image save that image and return that image via a block
    // to be user in the location picture cells
    [popover dismissPopoverAnimated:YES];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    popover = nil;
    imagePicker = nil;
    self.onSuccessImage(selectedImage);

}
- (void)viewDidUnload {
    popover = nil;
    imagePicker = nil;
    [popover dismissPopoverAnimated:YES];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}
@end
