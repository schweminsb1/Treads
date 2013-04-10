////
////  CameraService.m
////  treads
////
////  Created by Anthony DeLeone on 4/10/13.
////  Copyright (c) 2013 Team Walking Stick. All rights reserved.
////
//
//#import "CameraService.h"
//#import "AppDelegate.h"
//
//@interface CameraService ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
//
//@property BOOL newMedia;
//@property (nonatomic, strong) UIPopoverController *popoverController;
//@property UIImagePickerController *imagePicker;
//
//@end
//
//@implementation CameraService
//BOOL doneTakingPictures;
//@synthesize popoverController;
//
//
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
//void (^done)(void) = ^{
//    // set the location that the block will complete to
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate.tabBarController setSelectedIndex:3];
//    doneTakingPictures = YES;
//};
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    done();
//    [self dismissViewControllerAnimated:YES completion: nil];
//    //[self.navigationController popViewControllerAnimated:YES];
//    
//}
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [self.popoverController dismissPopoverAnimated:true];
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    [self dismissViewControllerAnimated:YES completion: nil];
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
//    {
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        // write the saved photo to the photo library
//        if (_newMedia)
//        {
//            UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:finishedSavingWithError:contextInfo:),nil);
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//}
//-(void) showImagePicker: (UIImagePickerControllerSourceType *) sourceType
//{
////    imagePicker = [[UIImagePickerController alloc] init];
////    imagePicker.delegate = self;
////    popoverController = [[UIPopoverController alloc] initWithContentViewController: imagePicker];
////    imagePicker.sourceType = sourceType;
//    
//    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        
//        //popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
//        //[popoverController presentPopoverFromRect: inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        
//    }else {
//        //[self presentModalViewController: imagePickerController animated:YES];
//    }
//    //[self presentViewController:imagePicker animated: YES completion: nil];
//}
//@end
