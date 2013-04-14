//
//  CameraVC.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "CameraVC.h"
#import "AppDelegate.h"

@interface CameraVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property BOOL newMedia;

@property (nonatomic, strong) UIPopoverController *popoverController;
@property UIImagePickerController *imagePicker;

@end

@implementation CameraVC
BOOL doneTakingPictures;
BOOL previousDoneHit;
@synthesize popoverController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Camera", @"Camera");
        self.tabBarItem.image = [UIImage imageNamed:@"camera.png"];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    //[super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.popoverController isPopoverVisible])
    {
        [self.popoverController dismissPopoverAnimated:YES];
    }
    // setup the Camera
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker =[[UIImagePickerController alloc] init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.navigationBar.opaque = true;
        self.imagePicker.delegate = self;
        doneTakingPictures = NO;
        
        if(!doneTakingPictures)
        {
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
        _newMedia = YES;
    }
}
void (^done)(void) = ^{
        // set the location that the block will complete to
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate.tabBarController setSelectedIndex:3];
        doneTakingPictures = YES;
    };
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    done();
    [self dismissViewControllerAnimated:YES completion: nil];
    //[self.navigationController popViewControllerAnimated:YES];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion: nil];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // write the saved photo to the photo library
        if (_newMedia)
        {
            UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:finishedSavingWithError:contextInfo:),nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
- (void)viewDidUnload {
    self.popoverController = nil;
    self.imagePicker = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
