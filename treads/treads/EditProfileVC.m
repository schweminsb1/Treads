//
//  EditProfileVC.m
//  treads
//
//  Created by Zachary Kanoff on 4/12/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "EditProfileVC.h"
#import "TripService.h"
#import "UserService.h"
#import "ImageService.h"
#import "LocationService.h"
#import "User.h"
#import "TreadsSession.h"


@interface EditProfileVC ()

@property IBOutlet UITextField * oldPassword;
@property IBOutlet UITextField * updatePassword;
@property IBOutlet UITextField * confirmPassword;
@property UserService * userService;

@end

@implementation EditProfileVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userService:(UserService *)myUserService
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.userService = myUserService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) changePassword :(id) sender {
    
    [self.userService getUserbyID:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(dataHasLoaded:)];    
}

- (void)dataHasLoaded:(NSArray*)user{
    User* returnedUser = (User*)user[0];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Woah!!"
                          message: @"Please fill all fields to change password"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    if([self.oldPassword.text isEqualToString:@""]|| [self.updatePassword.text isEqualToString:@""]|| [self.confirmPassword.text isEqualToString:@""])
    {
        [alert show];
    }
    else
    {
        if(self.updatePassword.text.length < 8)
        {
            alert.message = @"Passwords must be 8 or more characters long";
            self.oldPassword.text = @"";
            self.updatePassword.text =@"";
            self.confirmPassword.text = @"";
            [alert show];
            return;
        }
        else if(![self.updatePassword.text isEqualToString:self.confirmPassword.text])
        {
            alert.message = @"The Passwords do not match";
            self.oldPassword.text = @"";
            self.updatePassword.text = @"";
            self.confirmPassword.text = @"";
            [alert show];
            return;
        }
        else if (![[self getPasswordHash:self.oldPassword.text] isEqual: returnedUser.fname]) {
            alert.message = @"Old Password is incorrect";
            self.oldPassword.text = @"";
            self.updatePassword.text = @"";
            self.confirmPassword.text = @"";
            [alert show];
            return;
        }
    }
}

-(NSString *) getPasswordHash:(NSString *) user_input
{
    NSMutableString * salt = [NSMutableString stringWithString:@"saltValue"];
    NSMutableString * hash = [NSMutableString stringWithString:[NSString stringWithFormat:@"%lu",(unsigned long)[user_input hash]]];
    [hash appendString:salt];
    NSString * inputHash= [NSString stringWithFormat:@"%lu",(unsigned long)[hash hash]];
    return inputHash;
    
}

@end
