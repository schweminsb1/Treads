//
//  AddLocationViewController.m
//  treads
//
//  Created by Anthony DeLeone on 3/8/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "AddLocationViewController.h"
#import "TreadsSession.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>

@interface AddLocationViewController ()

@property IBOutlet UITextField  * locationText;
@property IBOutlet UITextView   * descriptionText;
@property IBOutlet UITextView   * attributeText;
@property          MSClient     * client;
@property          AppDelegate  * appDelegate;
@property double                 *latitude;
@property double                 *longitude;
@property CLGeocoder            *geocoder;
//@property        TreadsSession * treadsSession;

@end

@implementation AddLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil client:(MSClient *) client  AppDelegate: ( id) appdelegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _client=client;
        _appDelegate=(AppDelegate *)appdelegate;
        _latitude = nil;
        _longitude = nil;
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
-(IBAction)FinishClick:(id)sender
{
    // user clicks finish and pushes the new data to the database
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Woah!!"
                          message: @"We need the following fields to add the location."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    UIAlertView *nametooLong = [[UIAlertView alloc]
                                initWithTitle: @"Woah!!"
                                message: @"The location name is rescricted to 50 characters."
                                delegate: nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
    UIAlertView *descriptiontooLong = [[UIAlertView alloc]
                                initWithTitle: @"Woah!!"
                                message: @"The description and attributes are rescricted to 250 characters each."
                                delegate: nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
    
    MSTable * LocationTable=  [   _client getTable:@"LocationTable"];
    __block NSArray * returnedValues= nil;
    returnedValues= [[NSArray alloc] init];
    
    // check for empty fields
    if([_locationText.text isEqualToString:@""] || [_attributeText.text isEqualToString:@""] ||
       [_descriptionText.text isEqualToString:@""] || _latitude == nil || _longitude == nil )
    {
        [alert show];
    }
    // check for names that are too long
    else if(_locationText.text.length > 50)
    {
        [nametooLong show];
        
    }
    // check for descriptions/attribute lists that are too long
    else if(_descriptionText.text.length > 250 || _attributeText.text.length > 250)
    {
        [descriptiontooLong show];
    }
    else
    {
        // fields entered
        MSItemBlock itemBlock=^(NSDictionary *item, NSError *error)
        {
            if(error)
            {
                NSLog( [error localizedDescription]);
            }
            else
            {
                // root view controller is the tabBar
                _appDelegate.window.rootViewController= _appDelegate.tabBarController;
                
            }
        };
        // add the entry to the database
        MSReadQueryBlock LocationAddBlock = ^(NSArray *items, NSInteger totalCount, NSError *error)
        {
            int count= items.count;
            if(error)
            {
                
            }
            else
            {
                int newID= [[((NSDictionary *)items[count-1]) valueForKey:@"locationID"]integerValue] + 1;
                
                NSDictionary * newItem= @{@"locationID":[NSNumber numberWithInt:newID] ,
                                          @"name": [NSString stringWithString: _locationText.text],
                                          @"description": [NSString stringWithString: _descriptionText.text] ,
                                          @"latitude": [NSNumber numberWithDouble: *(_latitude)] ,
                                          @"longitude": [NSNumber numberWithDouble: *(_longitude)]
                                          };
                
                [LocationTable insert:newItem completion:itemBlock];
                
                
            }
        };
    }
    
    
}
-(IBAction)AddCoordinates:(id)sender
{
    UIButton *button = (UIButton*)sender;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Woah!!"
                          message: @"The coordintates for the location were not found."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
   // get the coordinates of the location typed into the location name field
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    NSString *location = [NSString stringWithFormat:@"%@",_locationText];
    button.enabled = NO;
    [self.geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            // store the coordinates
            _latitude  = &coordinate.latitude;
            _longitude = &coordinate.longitude;
        }
        else
        {
            [alert show];
        }
        button.enabled = YES;
    }];
}

@end
