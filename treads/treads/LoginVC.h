//
//  LoginViewController.h
//  treads
//
//  Created by Sam Schwemin on 3/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@class UserService;
@interface LoginVC : UIViewController <UITextFieldDelegate>

@property (strong) IBOutlet UIActivityIndicatorView* activityIndicatorView;

-(IBAction) skipClick:(id)sender;
-(IBAction) LoginClick:(id) sender;
-(IBAction) RegisterClick:(id) sender;
-(IBAction) ForgottenPassword:(id) sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil client:(MSClient *) client  AppDelegate: ( id) appdelegate withUserService:(UserService*) userService;

-(NSString *) getPasswordHash:(NSString * )user_input;
@property IBOutlet UIButton * login;
@property IBOutlet UIButton * newuser;

@end
