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
#import "ProfileVC.h"

@interface LoginVC ()

@property IBOutlet UIImageView * background;
@property IBOutlet UITextField * usernameText;
@property IBOutlet UITextField * passwordText;
@property          MSClient    * client;
@property          AppDelegate * appDelegate;
@property        TreadsSession * treadsSession;
@property        UserService * userService;
@property         CGRect rectangle;
@end

@implementation LoginVC
{
    NSMutableArray * pictures;
   
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil client:(MSClient *) client  AppDelegate: ( id) appdelegate withUserService:(UserService*) userService
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _rectangle= self.view.bounds;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        
        _activityIndicatorView.hidesWhenStopped= YES;
        _activityIndicatorView.hidden=YES;
        
        _client=client;
        _appDelegate=(AppDelegate *)appdelegate;
        _userService=userService;
        pictures = [[NSMutableArray alloc]init];
        //[pictures addObject:[UIImage imageNamed:@"mountains.jpg"]];
        [pictures addObject:[UIImage imageNamed:@"remote-luxury-hiking-canada.jpg"]];
        [pictures addObject:[UIImage imageNamed:@"summit-boots-hiking-rocks.jpg"]];
        [pictures addObject:[UIImage imageNamed:@"helicopter-bouldering-crash-pad.jpg"]];
       _background = [[UIImageView alloc]initWithImage:pictures[1]];

        [self.view setAutoresizesSubviews:YES];
        [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight
             ];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _usernameText.delegate=self;
    _passwordText.delegate=self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipClick:(id)sender
{
    _appDelegate.window.rootViewController= _appDelegate.tabBarController;
}

-(IBAction) LoginClick:(id) sender
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Woah!!"
                          message: @"If you are logging in, be sure to enter your username and password"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];

    _login.userInteractionEnabled=NO;
    _newuser.userInteractionEnabled=NO;

    
    if ([_usernameText.text isEqualToString:@""] || [_passwordText.text isEqualToString:@""]) {
       
        [alert show];        
    }
    else
    {
       //there is something in both of the required text fields
        //[UserTable readWithQueryString:[query queryStringOrError:&error] completion:queryBlock];
        [_userService getUserbyEmail:_usernameText.text forTarget:self withAction:@selector(log:)];
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
    RegisterVC * registerView= [[RegisterVC alloc]initWithNibName:@"RegisterVC" bundle:nil client:_client AppDelegate:_appDelegate withUserService:_userService];
    [self.navigationController pushViewController:registerView animated:YES];

}

-(IBAction) ForgottenPassword:(id) sender
{
    //open view or alert to 
    
}
-(void)log: (NSArray*)items
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Woah!!"
                          message: @"If you are logging in, be sure to enter your username and password"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    if(items.count==1)
    {
        //NSArray * returnedValues = [items mutableCopy];
        
        if([[_usernameText.text lowercaseString]isEqual: [((User*)items[0]).emailaddress lowercaseString]]&& [[self getPasswordHash:_passwordText.text] isEqual: ((User*)items[0]).password])
        {
            int userID= ((User*)items[0]).User_ID ;
            @try
            {
                //This inits a treadssession
                [TreadsSession instance].treadsUser=[((User*)items[0]).emailaddress lowercaseString];
                [TreadsSession instance].treadsUserID  = userID;
                [TreadsSession instance].fName= ((User*)items[0]).fname;
                [TreadsSession instance].lName= ((User*)items[0]).lname;
                [TreadsSession instance].profilePhotoID=((User*)items[0]).profilePhotoID;
                [TreadsSession instance].coverPhotoID=((User*)items[0]).coverPhotoID;
                
                // _treadsSession = [[TreadsSession new]initWithAuthenticatedUser: [NSString stringWithString:(NSString *)[items[0][@"emailAddress"] lowercaseString]]];
                if([TreadsSession Login])
                {
                    //    [self.appDelegate.tabBarController.viewControllers[4] updateUser: [TreadsSession instance].treadsUserID];
                    [_login setUserInteractionEnabled:YES];
                    [_newuser setUserInteractionEnabled:YES];
                    _appDelegate.window.rootViewController= _appDelegate.tabBarController;
                   // [self.navigationController pushViewController:self.appDelegate.tabBarController animated:YES];
                }
                else
                {
                    alert.message= @"Your drive may be full too full to use Treads";
                    [alert show];
                    [self.activityIndicatorView stopAnimating];
                    [_login setUserInteractionEnabled:YES];
                    [_newuser setUserInteractionEnabled:YES];
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
            [self.activityIndicatorView stopAnimating];
            [_login setUserInteractionEnabled:YES];
            [_newuser setUserInteractionEnabled:YES];
            return;
        }
    }
    else if(items.count == 0)
    {
        alert.message=@"The email does not match an account, please register a new one with this email";
        _usernameText.text=@"";
        _passwordText.text=@"";
        [alert show];
        [self.activityIndicatorView stopAnimating];
        [_login setUserInteractionEnabled:YES];
        [_newuser setUserInteractionEnabled:YES];
        
        return;
    }
    else
    {
        //theres more than one item
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   
    if(textField == _usernameText)
   {
       [textField resignFirstResponder];
       [_passwordText becomeFirstResponder];
       
   }
    else if( textField == _passwordText)
    {
        [textField resignFirstResponder];
        [self LoginClick:self];
    }
    
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *) textField{
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // enter closes the keyboard
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [UIView beginAnimations:nil context:NULL]; // animate the following:
    // move to new location
    
    if(orientation == 0)
    {
        [self.view setFrame:CGRectMake(0,-60,_rectangle.size.width,_rectangle.size.height)];
    }
    else if(orientation == UIInterfaceOrientationPortrait)
    {
        [self.view setFrame:CGRectMake(0,-60,_rectangle.size.width,_rectangle.size.height)];
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft)
    {
        [self.view setFrame:CGRectMake(0,-150,_rectangle.size.height,_rectangle.size.width)];
    }
    else if(orientation == UIInterfaceOrientationLandscapeRight)
    {
        [self.view setFrame:CGRectMake(0,-150,_rectangle.size.height,_rectangle.size.width)];
    }
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [UIView beginAnimations:nil context:NULL];
    if(orientation == 0)
    {
        [self.view setFrame:CGRectMake(0,0,_rectangle.size.width,_rectangle.size.height)];
    }
    else if(orientation == UIInterfaceOrientationPortrait)
    {
        [self.view setFrame:CGRectMake(0,0,_rectangle.size.width,_rectangle.size.height)];
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft)
    {
        [self.view setFrame:CGRectMake(0,0,_rectangle.size.height,_rectangle.size.width)];
    }
    else if(orientation == UIInterfaceOrientationLandscapeRight)
    {
        [self.view setFrame:CGRectMake(0,0,_rectangle.size.height,_rectangle.size.width)];
    }
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    
}


@end
