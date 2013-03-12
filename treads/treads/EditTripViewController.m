//
//  EditTripViewController.m
//  treads
//
//  Created by Zachary Kanoff on 3/10/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "EditTripViewController.h"
#import "AppDelegate.h"
#import "TreadsSession.h"

@interface EditTripViewController ()

@property          MSClient    * client;
@property          AppDelegate * appDelegate;

@end

@implementation EditTripViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil client:(MSClient *) client  AppDelegate: ( id) appdelegate;
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
    MSTable * MyTripsTable=  [   _client getTable:@"MyTripsTable"];
    __block NSArray * returnedValues= nil;
    returnedValues= [[NSArray alloc] init];
    
    MSReadQueryBlock queryBlock=^(NSArray *items, NSInteger totalCount, NSError *error) {
        returnedValues = items;
        
        
        
        return;
        
        
    };
    
    __autoreleasing NSError * error= [[NSError alloc]init];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"tripID == 0"];
    
    MSQuery * query= [[MSQuery alloc]initWithTable:MyTripsTable withPredicate:predicate];
    [MyTripsTable readWithQueryString:[query queryStringOrError:&error] completion:queryBlock];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

