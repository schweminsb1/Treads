//
//  TripViewVC.m
//  treads
//
//  Created by Anthony DeLeone on 3/8/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewVC.h"
#import "AppDelegate.h"
#import "EditTripViewController.h"

@interface TripViewVC ()
@property          MSClient     * client;
@property          AppDelegate  * appDelegate;

@end

@implementation TripViewVC

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
- (IBAction)EditClick:(id)sender
{
    // calls edit trips page
    EditTripViewController *EditTripVC = [[EditTripViewController alloc]initWithNibName:@"EditTripViewController" bundle:nil client: _client AppDelegate: _appDelegate];
    [self.navigationController pushViewController:EditTripVC animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
