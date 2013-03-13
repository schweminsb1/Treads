//
//  RegisterViewController.h
//  treads
//
//  Created by Sam Schwemin on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AppDelegate.h"

@interface RegisterViewController : UIViewController

@property (strong) IBOutlet UIActivityIndicatorView* activityIndicatorView;
-(IBAction) RegisterNewUser :(id) sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil client:(MSClient *) client  AppDelegate: ( id) appdelegate;

-(NSString *) getPasswordHash:(NSString *) user_input;

@end
