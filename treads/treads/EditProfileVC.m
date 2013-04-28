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
@property IBOutlet UIButton * save;
@property IBOutlet UITextField * fName;
@property IBOutlet UITextField * lName;
@property IBOutlet UITextField * email;
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fName.text = [TreadsSession instance].fName;
    self.lName.text = [TreadsSession instance].lName;
    self.email.text = [TreadsSession instance].treadsUser;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) changePassword :(id) sender {
    self.save.enabled = false;
    [self.userService getUserbyID:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(dataHasLoaded:)];    
}

- (void)dataHasLoaded:(NSArray*)user{
    User* returnedUser = (User*)user[0];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Woah!!"
                          message: @"Please enter your password to change your profile"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    if([self.oldPassword.text isEqualToString:@""])
    {
        [alert show];
        self.save.enabled = true;
    }
    else
    {
        if(![[self getPasswordHash:self.oldPassword.text] isEqual: returnedUser.password]) {
            alert.message = @"Password is incorrect";
            self.oldPassword.text = @"";
            self.updatePassword.text = @"";
            self.confirmPassword.text = @"";
            [alert show];
            self.save.enabled = true;
            return;
        }
        else if(![self.updatePassword.text isEqualToString:self.confirmPassword.text])
        {
            alert.message = @"The Passwords do not match";
            self.oldPassword.text = @"";
            self.updatePassword.text = @"";
            self.confirmPassword.text = @"";
            [alert show];
            self.save.enabled = true;
            return;
        }
        else if(self.updatePassword.text.length > 0 && self.updatePassword.text.length < 8)
        {
            alert.message = @"Passwords must be 8 or more characters long";
            self.oldPassword.text = @"";
            self.updatePassword.text =@"";
            self.confirmPassword.text = @"";
            [alert show];
            self.save.enabled = true;
            return;
        }
        else if(self.updatePassword.text.length > 50) {
            alert.message = @"Passwords may not be longer than 50 characters";
            self.oldPassword.text = @"";
            self.updatePassword.text =@"";
            self.confirmPassword.text = @"";
            [alert show];
            self.save.enabled = true;
            return;
        }
        else if(self.fName.text.length > 50) {
            alert.message = @"First name may not be longer than 50 characters";
            self.oldPassword.text = @"";
            self.updatePassword.text =@"";
            self.confirmPassword.text = @"";
            [alert show];
            self.save.enabled = true;
            return;
        }
        else if(self.lName.text.length > 50) {
            alert.message = @"Last name may not be longer than 50 characters";
            self.oldPassword.text = @"";
            self.updatePassword.text =@"";
            self.confirmPassword.text = @"";
            [alert show];
            self.save.enabled = true;
            return;
        }
        else if(self.email.text.length > 50) {
            alert.message = @"Email may not be longer than 50 characters";
            self.oldPassword.text = @"";
            self.updatePassword.text =@"";
            self.confirmPassword.text = @"";
            [alert show];
            self.save.enabled = true;
            return;
        }
        else {
            if(self.updatePassword.text.length > 0) {
                returnedUser.password = [self getPasswordHash:self.updatePassword.text];
            }
            if (self.fName.text.length > 0) {
                returnedUser.fname = self.fName.text;
            }
            if (self.lName.text.length > 0) {
                returnedUser.lname = self.lName.text;
            }
            if(self.email.text.length > 0) {
                returnedUser.emailaddress = self.email.text;
            }
            [self.userService updateUser:returnedUser forTarget:self withAction:@selector(success)];
        }
    }
}
             
-(void) success {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Success"
                          message: @"Profile updated"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    self.oldPassword.text = @"";
    self.updatePassword.text = @"";
    self.confirmPassword.text = @"";
    [alert show];
    self.save.enabled = true;
    [self.navigationController popViewControllerAnimated:YES];
    
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
