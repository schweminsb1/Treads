//
//  LoginViewController.h
//  treads
//
//  Created by Sam Schwemin on 3/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface LoginViewController : UIViewController

@property (strong) IBOutlet UIActivityIndicatorView* activityIndicatorView;

-(IBAction) LoginClick:(id) sender;
-(IBAction) RegisterClick:(id) sender;
-(IBAction) ForgottenPassword:(id) sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil client:(MSClient *) client  AppDelegate: ( id) appdelegate;

-(NSString *) getPasswordHash:(NSString * )user_input;

@end
