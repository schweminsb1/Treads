//
//  CameraService.m
//  treads
//
//  Created by Anthony DeLeone on 4/10/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.


#import "CameraService.h"
#import "AppDelegate.h"

@interface CameraService ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>


@end

@implementation CameraService
BOOL doneTakingPictures;
BOOL newMedia;
UIImagePickerController *imagePicker;
UIImage* selectedImage;
UIViewController* vc;
UIPopoverController* popover;

- (void)showImagePickerFromViewController:(UIViewController*)viewController onSuccess:(void(^)(UIImage*))onSuccess
{
    void (^showImagePicker)(void) = ^
    {
        
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            
            popover = [[UIPopoverController alloc] initWithContentViewController: imagePicker];
            popover.delegate = self;
            [popover presentPopoverFromRect:CGRectMake
             ((viewController.view.frame.size.height/2),
              (viewController.view.frame.size.width/2),
              500,
              100) inView:viewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        else
        {
            [imagePicker presentViewController: imagePicker animated:YES completion:nil];
        }
    };
    showImagePicker();
    //[viewController presentViewController:popover animated:(YES) completion:nil];
    onSuccess([UIImage imageNamed: selectedImage]);
}

- (void)viewDidAppear:(BOOL)animated
{
    //[super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // setup the Camera
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker =[[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        doneTakingPictures = NO;
        
        if(!doneTakingPictures)
        {
            //[self presentViewController: imagePicker animated:YES completion:nil];
        }
        newMedia = YES;
    }
}
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
void (^dismissCamera)(void) = ^{
    // set the location that the block will complete to
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.tabBarController setSelectedIndex:3];
    doneTakingPictures = YES;
};
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dismissCamera();
//    [self dismissViewControllerAnimated:YES completion: nil];
//    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [popover dismissPopoverAnimated:YES];
    [imagePicker dismissViewControllerAnimated:YES completion:^{
       selectedImage  = [info objectForKey:UIImagePickerControllerOriginalImage];
    }];
    
}
UIImage*(^returnSelectedImage)(void) =^
{
    return selectedImage;
};
@end
