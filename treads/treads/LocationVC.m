//
//  LocationVC.m
//  treads
//
//  Created by Sam Schwemin on 4/3/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "LocationVC.h"
#import "Comment.h"
#import "CommentCell.h"
#import "TreadsSession.h"
#import "CommentEnterCell.h"
#import "TripLocation.h"
#import "ProfileVC.h"
#import "CommentService.h"
#import "ImageService.h"
#import "FollowService.h"
#import "LocationService.h"
#import "UserService.h"
#import "TripService.h"
#import "TripLocationService.h"
#import "TripViewVC.h"
#import "Trip.h"
#import "TripService.h"
#import "TripBrowser.h"

@interface LocationVC ()
@property NSMutableArray * commentModels;
@property NSMutableArray * triplocationModels;
@property NSMutableArray * tripModels;
@property TripBrowser    * browser;
//@property UIView* browserWindow;
@end

@implementation LocationVC
//class contains service and model and fills fields on page

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withModel: (Location *) model withTripService: (TripService*) tripService withUserService:(UserService*) userService imageService:(ImageService*)imageService  withLocationService:(LocationService*)locationService withCommentService:(CommentService*)commentService withFollowService:(FollowService*)followService
{
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _commentService = commentService;
        _userService=userService;
        _imageService=imageService;
        _locationService=locationService;
        _followService=followService;
        _triplocationModels= [[NSMutableArray alloc] init];
        _tripModels = [[NSMutableArray alloc]init];
        _commentModels = [[NSMutableArray alloc]init];
        _model=model;
        [_commentService getCommentInLocation:[model.idField intValue] forTarget:self withAction:@selector(getModels:)];
       
        [[TripLocationService instance] getTripLocationWithLocation:model withCompletion:^(NSArray *items, Location *location)
        {
            _triplocationModels=[NSMutableArray arrayWithArray:items];
            if(_triplocationModels.count>0)
            {
                [[TripService instance] getTripWithID:((TripLocation*)_triplocationModels[0]).tripID forTarget:self withAction:@selector(addTrip:)];
                
            }
            
        }];
        
        [[TripService instance] getTripsContainingLocationID:[_model.idField intValue]forTarget:self withAction:@selector(addTrips:)];
        
        [self.browser clearAndWait];
        CGRect commentEnterRect = CGRectMake(_commentTable.frame.origin.x, _commentTable.frame.origin.y -50, _commentTable.frame.size.width, 50);
        _commentEnterCell = [[CommentEnterBox alloc] initWithFrame:commentEnterRect];
        [self.view addSubview:_commentEnterCell];
               
        [_segmentControl addTarget:self action:@selector(didChangeSegmentControl:) forControlEvents:UIControlEventValueChanged];
    }
    else
    {
        NSLog(@"error in LocationVC");
        
    }
    return self;
}
-(void)addTrips:(NSArray*)items
{
   /* if(items.count==1)
    {
        [_tripModels addObject:items[0]];
        
    }
    if(_tripModels.count == _triplocationModels.count)
    {
        
        [self.browser setBrowserData:_tripModels withCellStyle:TripBrowserCell4x4 forTarget:self withAction:@selector(returnTrip:)];
        
        [_commentTable reloadData];
        
    }*/
    _tripModels=[NSMutableArray arrayWithArray:items];
    [self.browser setBrowserData:_tripModels withCellStyle:TripBrowserCell4x4 forTarget:self withAction:@selector(returnTrip:)];
    for (Trip* trip in items) {
        [[TripService instance] getHeaderImageForTrip:trip forTarget:self withCompleteAction:@selector(refreshWithNewHeader)];
    }
}

- (void)refreshWithNewHeader
{
    [self.browser refreshWithNewImages];
}

-(void)returnTrip:(Trip*)trip
{
    //gototrip
    TripViewVC * tripView= [[TripViewVC alloc]initWithNibName:@"TripViewVC" bundle:nil backTitle:_model.title tripService:[TripService instance] tripID:trip.tripID LocationService:[LocationService instance] withCommentService:[CommentService instance] withUserService:[UserService instance]];
    [self.navigationController pushViewController:tripView animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[AppColors tertiaryBackgroundColor]];
    self.name.text = _model.title;
    
    self.nameHighlightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
//    self.lon.text = [NSString stringWithFormat:@"%f", _model.longitude ];
//     self.lat.text = [NSString stringWithFormat:@"%f", _model.latitude ];
    
    self.description.text= _model.description;
     
    _browser= [[TripBrowser alloc] initWithFrame:self.commentTable.bounds];
    [self.browser setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [self.tableContainerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
//    [self.name setFrame:CGRectMake(176, 33, 480, 46)];
    [self.name setFont:[UIFont boldSystemFontOfSize: 38]];
    [self.name setTextColor:[AppColors lightTextColor]];
    [self.name setTextAlignment:NSTextAlignmentCenter];
    [self.name setAdjustsFontSizeToFitWidth:YES];
    
//    [self.lat setHidden:YES];
//    [self.lon setHidden:YES];
    
    [self.imageView setClipsToBounds:YES];
    
//    [self.segmentControl removeFromSuperview];
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Comments", @"Trips"]];
    [self.segmentControl addTarget:self action:@selector(didChangeSegmentControl:) forControlEvents:UIControlEventValueChanged];
    self.segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.navigationItem setTitleView:self.segmentControl];
//    [self.navigationController.navigationBar.topItem setTitleView:self.segmentControl];
    [self.segmentControl setSelectedSegmentIndex:0];
    
//    [self.browserWindow addSubview:_browser];
//    [self.view addSubview:self.browserWindow];
    
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.view setBackgroundColor:[AppColors secondaryBackgroundColor]];

    /*
    self.name.text = _model.title;
    
    self.lon.text = [NSString stringWithFormat:@"%f", _model.longitude ];
    self.lat.text = [NSString stringWithFormat:@"%f", _model.latitude ];
    
    self.description.text= _model.description;
    
*/
    
}

-(void)getModels: (NSArray*) items
{
    _commentModels=[NSMutableArray arrayWithArray:items];
    //get users, and fill comentModel
    
    [_commentTable reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_segmentControl selectedSegmentIndex]==0)
    {
        return _commentModels.count + 1;
    }
    else
    {
        return _tripModels.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    UITableViewCell * ccell;
    
    if([_segmentControl selectedSegmentIndex]==0)
    {
        if(indexPath.row == 0)
        {
            ccell= [tableView dequeueReusableCellWithIdentifier:@"CCELL"];
            if (!ccell)
            {
                ccell = [[CommentEnterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CCELL" ];
                CommentEnterCell * cell=(CommentEnterCell *)ccell;
                cell.cellOwner=self;
                cell.buttonCallBack= @selector(addCommentToTableFromUserWithComment:);
            
            //[cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            //[cell setAutoresizesSubviews:YES];
            }
        }
        else if(indexPath.row >0)
        {
            //ccell= [tableView dequeueReusableCellWithIdentifier:@"CELL"];
            if (!ccell)
            {
                    ccell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL" withCommentModel: ((Comment *)_commentModels[(_commentModels.count)-(indexPath.row)])withTripService:_tripService withUserService:_userService imageService:_imageService withLocationService:_locationService withCommentService:_commentService withFollowService:_followService withLocationDelegate:self];
                //[cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
                //[cell setAutoresizesSubviews:YES];
            }
        }
    }
    else
    {
        ccell = [tableView dequeueReusableCellWithIdentifier:@"trips"];
        if(!ccell)
        {
            ccell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"trips"];
        }
        ccell.textLabel.text=[NSString stringWithFormat:@"%@",((Trip*)_tripModels[indexPath.row]).name];
       
    }
    return ccell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    if([_segmentControl selectedSegmentIndex]==1)
    {
        //goto trip view
        TripViewVC * newvc= [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil backTitle:_model.title tripService:[TripService instance] tripID:((Trip*)_tripModels[indexPath.row]).tripID LocationService:[LocationService instance] withCommentService:[CommentService instance] withUserService:[UserService instance]];
        [self.navigationController pushViewController:newvc animated:YES];
    }
    
}

-(void) addCommentToTableFromUserWithComment: (NSString *) comment
{
    Comment* newComment= [[Comment alloc]init];
    newComment.comment=comment;
    newComment.CommentID=[NSString stringWithFormat:@"'%d'",-1 ];
    newComment.LocationID= _model.idField;
    int userID= [TreadsSession instance].treadsUserID;
    newComment.UserID= [NSString stringWithFormat:@"%d",userID ];
    //Change to Correct User ID
    [_commentModels addObject:newComment];
    
    [_commentTable reloadData];
    [  _commentService insertNewComment:newComment fromTarget:self withReturn:@selector(addCommentReturnAction:wasSuccessful:)];
    
    
}
-(void) addCommentReturnAction:(NSNumber *) idNum wasSuccessful:(NSNumber *) worked
{
    
    
}
- (void)didChangeSegmentControl:(UISegmentedControl *)control {
    [_commentTable reloadData];
    if(control.selectedSegmentIndex==0)
    {
        //remove trip browser
        [_browser removeFromSuperview ];
        [_tableContainerView addSubview:_commentTable];
        [_commentTable reloadData];
    }
    else if(control.selectedSegmentIndex==1 && _tripModels != nil)
    {
       [_tableContainerView addSubview:_browser]; //place trip browser
        [self.browser clearAndWait];
        [self.browser setBrowserData:_tripModels withCellStyle:TripBrowserCell4x4 forTarget:self withAction:@selector(returnTrip:)];
        [_tableContainerView bringSubviewToFront:_browser];
        [_browser setHidden:NO];
        [_commentTable removeFromSuperview];
    }
    else
    {
        [control setSelectedSegmentIndex:0];
        
    }
}
-(void)addTrip:(NSArray*)item
{
    if(item.count>0)
    {
        Trip* trip=item[0];
        if (trip.tripLocations.count>0)
        {
            TripLocation * triplocation=(trip.tripLocations[0]);
            if(triplocation.tripLocationItems.count>0)
            {
                TripLocationItem * triplocationitem= triplocation.tripLocationItems[0];
                int imageid= triplocationitem.imageID;
                [[ImageService instance] getImageWithPhotoID:imageid withReturnBlock:^(NSArray *items) {
                if(items.count>0)
                    
                    _imageView.image=items[0];
                }];
            }
       
        }
    }

    
}

@end
