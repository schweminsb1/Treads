//
//  RegisterViewController.m
//  treads
//
//  Created by Sam Schwemin on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "RegisterVC.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AppDelegate.h"
#import "UserService.h"
#import "TreadsSession.h"
@interface RegisterVC ()
@property IBOutlet UIImageView * background;
@property IBOutlet UITextField * emailAdress;
@property IBOutlet UITextField * firstName;
@property IBOutlet UITextField * lastName;
@property IBOutlet UITextField * confirmEmail;
@property IBOutlet UITextField * password;
@property IBOutlet UITextField * confirmPassword;
@property UserService * userService;


@property  MSClient * client;
@property AppDelegate *appDelegate;

@end

@implementation RegisterVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil client:(MSClient *) client  AppDelegate: ( id) appdelegate withUserService:(UserService *)userService
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _activityIndicatorView.hidden = YES;
        _activityIndicatorView.hidesWhenStopped = YES;
        _client=client;
        _appDelegate=(AppDelegate *)appdelegate;
        _userService= userService;
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

-(IBAction) RegisterNewUser :(id) sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Woah!!"
                          message: @"Please fill all fields for registration"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
   if( [_emailAdress.text isEqualToString:@""] || [_password.text isEqualToString:@""]|| [_confirmEmail.text isEqualToString:@""]|| [_confirmPassword.text isEqualToString:@""]|| [_lastName.text isEqualToString:@""]|| [_firstName.text isEqualToString:@""])
   {
       
       [alert show];
   
   }
    else
    {
        if(_password.text.length < 8)
        {
            alert.message = @"Passwords must be 8 or more characters long";
            _password.text =@"";
            _confirmPassword.text = @"";
            [alert show];
            return;
        }
        else if(![_password.text isEqualToString:_confirmPassword.text])
        {
            alert.message = @"The Passwords do not match";
            _password.text = @"";
            _confirmPassword.text = @"";
            [alert show];
            return;
        }
        else if(![_emailAdress.text isEqualToString:_confirmEmail.text])
        {
            alert.message = @"The Email addresses do not match";
            _emailAdress.text = @"";
            _confirmEmail.text = @"";
            [alert show];
            return;
        }
        else
        {

                        
            [_userService getUserbyEmail:_emailAdress.text forTarget:self withAction:@selector(getRequestedEmail:)];
        
            [_activityIndicatorView startAnimating];
            //All fields are filled
            //use one way hash to send the encrypted password

                
            
        }
        

        //All fields are filled
        //use one way hash to send the encrypted password
   
        //insert new user into the database
        
        //Log the user in...
        
        
       // _appDelegate.window.rootViewController= _appDelegate.tabBarController;
        
    }
   
    
    
}
-(void) getRequestedEmail:(NSArray*) items
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Woah!!"
                          message: @"This email already exists in the Treads Server"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    int count= items.count;

        if(count==0)
        {
            //continue with registration, noone has this email address
            //sets a predicate to get all from table
            NSString * hashedPassword= [ self getPasswordHash:_password.text];
            NSDictionary * newItem= @{
                                      @"emailAddress": [NSString stringWithString:[_emailAdress.text lowercaseString]],
                                      @"password": [NSString stringWithString:hashedPassword] ,
                                      @"Fname": [NSString stringWithString:_firstName.text] ,
                                      @"Lname": [NSString stringWithString:_lastName.text],
                                      @"profilePhotoID": @-1,
                                      @"coverPhotoID" : @-1
                                      };
            [_userService addUser:newItem forTarget:self withAction:@selector(addUserSuccess:withSuccess:)];
            
        }
        else{
            _password.text = @"";
            _confirmPassword.text= @"";
            [_activityIndicatorView stopAnimating];
            [alert show];
            return;
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
-(void) addUserSuccess:(NSNumber*)item withSuccess:(NSNumber*)val
{
    [TreadsSession instance].treadsUser=[NSString stringWithString:[_emailAdress.text lowercaseString]];
   // [TreadsSession instance].treadsUser=[((User*)items[0]).emailaddress lowercaseString];
    [TreadsSession instance].treadsUserID  = [item intValue];
    [TreadsSession instance].fName= [NSString stringWithString:_firstName.text];
    [TreadsSession instance].lName= [NSString stringWithString:_lastName.text];
    [TreadsSession instance].profilePhotoID=-1;
    [TreadsSession instance].coverPhotoID=-1;
    
    [_activityIndicatorView stopAnimating];
    _appDelegate.window.rootViewController= _appDelegate.tabBarController;
    
}
@end
