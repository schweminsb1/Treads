//
//  RegisterViewController.m
//  treads
//
//  Created by Sam Schwemin on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "RegisterViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AppDelegate.h"

@interface RegisterViewController ()
@property IBOutlet UIImageView * background;
@property IBOutlet UITextField * emailAdress;
@property IBOutlet UITextField * firstName;
@property IBOutlet UITextField * lastName;
@property IBOutlet UITextField * confirmEmail;
@property IBOutlet UITextField * password;
@property IBOutlet UITextField * confirmPassword;



@property  MSClient * client;
@property AppDelegate *appDelegate;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil client:(MSClient *) client  AppDelegate: ( id) appdelegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _client=client;
        _appDelegate=(AppDelegate *)appdelegate;
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
    MSTable * UserTable=  [   _client getTable:@"UserTable"];
   if( [_emailAdress.text isEqualToString:@""] || [_password.text isEqualToString:@""]|| [_confirmEmail.text isEqualToString:@""]|| [_confirmPassword.text isEqualToString:@""]|| [_lastName.text isEqualToString:@""]|| [_firstName.text isEqualToString:@""])
   {
       
       [alert show];
   
   }
    else
    {
        if(![_password.text isEqualToString:_confirmPassword.text])
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
            //passwords and emails match
            MSItemBlock itemBlock=^(NSDictionary *item, NSError *error)
            {
                if(error)
                {
                    NSLog( [error localizedDescription]);
                }
                else
                {
                    //Login
                     _appDelegate.window.rootViewController= _appDelegate.tabBarController;
                    
                }
            };
            MSReadQueryBlock getAll = ^(NSArray *items, NSInteger totalCount, NSError *error)
            {
                int count= items.count;
                if(error)
                {
                    
                }
                else
                {
                    int newID= [[((NSDictionary *)items[count-1]) valueForKey:@"userID"]integerValue] + 1;
                    
                    NSString * test= [self getPasswordHash:@"password"];
                    NSString * hashedPassword= [ self getPasswordHash:_password.text];
                    NSDictionary * newItem= @{@"userID":[NSNumber numberWithInt:newID] ,
                                              @"emailAddress": [NSString stringWithString:_emailAdress.text],
                                              @"password": [NSString stringWithString:hashedPassword] ,
                                              @"Fname": [NSString stringWithString:_firstName.text] ,
                                              @"Lname": [NSString stringWithString:_lastName.text]
                                              };
                    
                    [UserTable insert:newItem completion:itemBlock];
                    
                   
                }
                
            };
            MSReadQueryBlock checkEmail = ^(NSArray *items, NSInteger totalCount, NSError *error)
            {
                int count= items.count;
                if(error)
                {
                    
                }
                else
                {
                    if(count==0)
                    {
                        //continue with registration, noone has this email address
                        //sets a predicate to get all from table
                        NSPredicate * predicategetALL = [NSPredicate predicateWithValue:YES];
                        //sets the predicate to return an ordered set value based on the UserID
                        [predicategetALL mutableOrderedSetValueForKey:@"UserID"];
                        MSQuery * queryGetAll = [[MSQuery alloc]initWithTable:UserTable withPredicate:predicategetALL];
                        [UserTable readWithQueryString:[queryGetAll queryStringOrError:nil]completion:getAll ];

                        
                        
                    }
                    else{
                        alert.message = @"This email already exists in the Treads Server";
                        _emailAdress.text = @"";
                        _confirmEmail.text= @"";
                        _password.text    = @"";
                        _firstName.text   = @"";
                        _lastName.text    = @"";
                        _confirmPassword.text = @"";
                        [alert show];
                        return;
                    }
                }
                
            };
 
                        
            
            NSPredicate * predicateEmail = [NSPredicate predicateWithFormat:@"emailAddress == %@", _emailAdress.text ];
            MSQuery * queryEmail= [[MSQuery alloc]initWithTable:UserTable withPredicate:predicateEmail];
            [UserTable readWithQueryString:[queryEmail queryStringOrError:nil] completion:checkEmail];
            
            //All fields are filled
            //use one way hash to send the encrypted password

                
            
        }
        
        MSItemBlock itemBlock=^(NSDictionary *item, NSError *error)
        {
            if(error)
            {
                
            }
            else
            {
                
            }
        };
        //All fields are filled
        //use one way hash to send the encrypted password
        
        NSDictionary * newItem= @{@"userID": @"",  @"emailAddress": @"",  @"password": @"" , @"Fname": @"" , @"Lname": @"" };
        [UserTable insert:newItem completion:itemBlock];
        //insert new user into the database
        
        //Log the user in...
        
        
       // _appDelegate.window.rootViewController= _appDelegate.tabBarController;
        
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
