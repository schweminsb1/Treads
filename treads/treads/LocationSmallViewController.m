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
#import "TripLocationService.h"

@interface LocationSmallViewController ()
@property MapPinAnnotation * pin;
@end

@implementation LocationSmallViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil location: (MapPinAnnotation *) location homeController: (MapsVC *) root Service: (LocationService *) service;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.location=location.location;
        self.homepage = root;
        self.service = service;
        _pin=location;

         _CommentsInLocations=@"";
        
        // Custom initialization  
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.name.text = _location.title;
    self.view.backgroundColor = [AppColors secondaryBackgroundColor];
    // Do any additional setup after loading the view from its nib.
    CGRect  size= CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 200 , self.view.bounds.size.width, 550) ;
    //add subView
    _CommentsInLocationsLabel.text=_CommentsInLocations;
    [[CommentService instance]getCommentInLocation:[_location.idField intValue] forTarget:self withAction:@selector(getCommentCount:)];
        
        _IncludedInTripsLabel.text=[NSString stringWithFormat:@"%d" , _pin.tripCount];
        
    _latLabel.text=[NSString stringWithFormat:@"%f",_pin.location.latitude];
    _lonLabel.text=[NSString stringWithFormat:@"%f",_pin.location.longitude];
    ImageScrollBrowser * scrollbrowse= [[ImageScrollBrowser alloc] initWithImageSize:size.size displayView:nil addItemView:nil editItemView:nil];

    /*
    NSMutableArray * triplocationItems= [[NSMutableArray alloc] init];
    TripLocationItem * triplocationitem= [[TripLocationItem alloc]init];
    triplocationitem.image= [UIImage imageNamed:@"mountains"];
    
    [ triplocationItems addObject:triplocationitem];
    
    scrollbrowse.displayItems= triplocationItems; */
    [self.view addSubview: scrollbrowse];
     
    
}
-(void)getCommentCount:(NSArray*)items
{
    _CommentsInLocations= [NSString stringWithFormat:@"%d",items.count];
    _CommentsInLocationsLabel.text=_CommentsInLocations;
    
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
