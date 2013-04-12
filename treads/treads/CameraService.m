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


- (void)showImagePickerFromViewController:(UIViewController*)viewController onSuccess:(void(^)(UIImage*))onSuccess
{
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ([popover isPopoverVisible])
        {
            //[popover dismissPopoverAnimated:YES];
        }
        else
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                imagePicker.delegate = self;
                imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
                popover = [[UIPopoverController alloc] initWithContentViewController: imagePicker];
                popover.delegate = self;
                [popover presentPopoverFromRect:CGRectMake(0,0,300,300)inView:viewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        }
    }
    else
    {
       // [imagePicker presentViewController: imagePicker animated:YES completion:nil];
    }
    //showImagePicker();
    //[viewController presentViewController:popover animated:(YES) completion:nil];
    self.onSuccessImage = onSuccess;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [popover dismissPopoverAnimated:YES];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    self.onSuccessImage(selectedImage);

}
UIImage*(^returnSelectedImage)(void) =^
{
    return selectedImage;
};
//- (void)viewDidAppear:(BOOL)animated
//{
//    //[super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    
//    // setup the Camera
//    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
//    {
//        imagePicker =[[UIImagePickerController alloc] init];
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
//        imagePicker.allowsEditing = NO;
//        imagePicker.delegate = self;
//        doneTakingPictures = NO;
//        
//        if(!doneTakingPictures)
//        {
//            //[self presentViewController: imagePicker animated:YES completion:nil];
//        }
//        newMedia = YES;
//    }
//}
//-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//{
//    if (error)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle: @"Save failed"
//                              message: @"Failed to save image"
//                              delegate: nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//    }
//}
//void (^dismissCamera)(void) = ^{
//    // set the location that the block will complete to
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate.tabBarController setSelectedIndex:3];
//    doneTakingPictures = YES;
//};
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    dismissCamera();
////    [self dismissViewControllerAnimated:YES completion: nil];
////    [self.navigationController popViewControllerAnimated:YES];
//    
//}

@end
