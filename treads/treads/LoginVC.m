//
//  LoginViewController.m
//  treads
//
//  Created by Sam Schwemin on 3/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "RegisterVC.h"
#import "TreadsSession.h"

@interface LoginVC ()

@property IBOutlet UIImageView * background;
@property IBOutlet UITextField * usernameText;
@property IBOutlet UITextField * passwordText;
@property          MSClient    * client;
@property          AppDelegate * appDelegate;
@property        TreadsSession * treadsSession;


@end

@implementation LoginVC
{
    NSMutableArray * pictures;
   
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil client:(MSClient *) client  AppDelegate: ( id) appdelegate
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _activityIndicatorView.hidesWhenStopped= YES;
        _activityIndicatorView.hidden=YES;
        
        _client=client;
        _appDelegate=(AppDelegate *)appdelegate;
        
        pictures = [[NSMutableArray alloc]init];
        //[pictures addObject:[UIImage imageNamed:@"mountains.jpg"]];
        [pictures addObject:[UIImage imageNamed:@"remote-luxury-hiking-canada.jpg"]];
        [pictures addObject:[UIImage imageNamed:@"summit-boots-hiking-rocks.jpg"]];
        [pictures addObject:[UIImage imageNamed:@"helicopter-bouldering-crash-pad.jpg"]];
       _background = [[UIImageView alloc]initWithImage:pictures[1]];
        
        // Custom initialization
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


-(IBAction) LoginClick:(id) sender
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Woah!!"
                          message: @"If you are logging in, be sure to enter your username and password"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
   MSTable * UserTable=  [   _client getTable:@"UserTable"];
    __block NSArray * returnedValues= nil;
    returnedValues= [[NSArray alloc] init];
    

    
    if ([_usernameText.text isEqualToString:@""] || [_passwordText.text isEqualToString:@""]) {
       
        [alert show];        
    }
    else
    {
       //there is something in both of the required text fields
              MSReadQueryBlock queryBlock=^(NSArray *items, NSInteger totalCount, NSError *error) {
                  
            int count= [items count];
            [_activityIndicatorView stopAnimating];
            if(error)
            {
               
                
            }
            else
            {
                if(items.count==1)
                {
                    
                    returnedValues = [items mutableCopy];
                    
                    if([[_usernameText.text lowercaseString]isEqual: [items[0][@"emailAddress"] lowercaseString]]&& [[self getPasswordHash:_passwordText.text] isEqual: items[0][@"password"]])
                    {
                        
                        @try
                        {
                            //This inits a treadssession
                             _treadsSession = [[TreadsSession new]initWithAuthenticatedUser: [NSString stringWithString:(NSString *)[items[0][@"emailAddress"] lowercaseString]]];
                           if([_treadsSession Login])
                           {
                               _appDelegate.window.rootViewController= _appDelegate.tabBarController;
                           }
                            else
                            {
                                alert.message= @"Your drive may be full too full to use Treads";
                                [alert show];
                                return;
                                
                            }
                          
                             
                            
                        }
                        @catch (id exception)
                        {
                            NSLog(@"%@", exception);
                        }
                                               
                        //login treads session object
                    }
                    else
                    {
                        alert.message= @"The Email address and password do not match in the Treads server";
                        [alert show];
                        return;
                    }

                }
                else if(count == 0)
                {
                   alert.message=@"The email does not match an account, please register a new one with this email";
                    _usernameText.text=@"";
                    _passwordText.text=@"";
                    [alert show];
                    return;
                    
                }
                else
                {
                   //theres more than one item
                }
                
            }
        };


        __autoreleasing NSError * error= [[NSError alloc]init];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"emailAddress == %@", _usernameText.text ];
        
        
        MSQuery * query= [[MSQuery alloc]initWithTable:UserTable withPredicate:predicate];
        
        [UserTable readWithQueryString:[query queryStringOrError:&error] completion:queryBlock];
        [_activityIndicatorView startAnimating];
        
        //retrieve the username if it exists in the database
        //if it doesn't exist  then say wrong username and password
        //if it does exist see if our hashed value matches the value stored in the database
        //if it matches then go to the logged in screen
        
      
        
        //condition will change to match above

        
        
        
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
-(IBAction) RegisterClick:(id) sender;
{
    RegisterVC * registerView= [[RegisterVC alloc]initWithNibName:@"RegisterVC" bundle:nil client:_client AppDelegate:_appDelegate];
    
    [self.navigationController pushViewController:registerView animated:YES];
    
    
}

-(IBAction) ForgottenPassword:(id) sender
{
    //open view or alert to 
    
    
}


@end
