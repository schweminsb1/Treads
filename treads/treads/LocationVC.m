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

#import "ProfileVC.h"
#import "CommentService.h"
#import "ImageService.h"
#import "FollowService.h"
#import "LocationService.h"
#import "UserService.h"
@interface LocationVC ()
@property NSMutableArray * commentModels;

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
        
        _model=model;
        [_commentService getCommentInLocation:[model.idField intValue] forTarget:self withAction:@selector(getModels:)];
        
        CGRect commentEnterRect = CGRectMake(_commentTable.frame.origin.x, _commentTable.frame.origin.y -50, _commentTable.frame.size.width, 50);
        _commentEnterCell = [[CommentEnterBox alloc] initWithFrame:commentEnterRect];
        [self.view addSubview:_commentEnterCell];
               
        
    }
    else
    {
        NSLog(@"error in LocationVC");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[AppColors mainBackgroundColor]];
    self.name.text = _model.title;
    
    self.lon.text = [NSString stringWithFormat:@"%f", _model.longitude ];
     self.lat.text = [NSString stringWithFormat:@"%f", _model.latitude ];
    
    self.description.text= _model.description;
     
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view setBackgroundColor:[AppColors secondaryBackgroundColor]];

    /*
    self.name.text = _model.title;
    
    self.lon.text = [NSString stringWithFormat:@"%f", _model.longitude ];
    self.lat.text = [NSString stringWithFormat:@"%f", _model.latitude ];
    
    self.description.text= _model.description;
    
*/
    
}

-(void)getModels: (NSArray*) items
{
    _commentModels=(NSMutableArray *)items;
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
    return _commentModels.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    UITableViewCell * ccell;
    
    
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
       return ccell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    
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


@end
