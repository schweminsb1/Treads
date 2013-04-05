//
//  LocationSmallViewController.m
//  treads
//
//  Created by Sam Schwemin on 4/2/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "LocationSmallViewController.h"
#import "LocationVC.h"
#import "ImageScrollDisplayView.h"
#import "ImageScrollBrowser.h"
#import "TripLocationItem.h"

@interface LocationSmallViewController ()

@end

@implementation LocationSmallViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil location: (Location *) location homeController: (MapsVC *) root Service: (LocationService *)service
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.location=location;
        self.homepage = root;
        self.service = service;
        
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.name.text = _location.title;
    // Do any additional setup after loading the view from its nib.
    CGSize  size= _scrollView.frame.size;
    //add subView
    ImageScrollBrowser * scrollbrowse= [[ImageScrollBrowser alloc]initWithImageSize: size displayView:nil];
    [scrollbrowse setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 200 , self.view.bounds.size.width, 550)];
    [scrollbrowse setNeedsLayout];
    
    NSMutableArray * triplocationItems= [[NSMutableArray alloc] init];
    TripLocationItem * triplocationitem= [[TripLocationItem alloc]init];
    triplocationitem.image= [UIImage imageNamed:@"mountains"];
    
    [ triplocationItems addObject:triplocationitem];
    
    scrollbrowse.displayItems= triplocationItems;
    [_scrollView addSubview: scrollbrowse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goToLocationPage:(id)sender
{
    [self.homepage pushLocation];
}
@end
