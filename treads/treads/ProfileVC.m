//
//  ProfileVC.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "ProfileVC.h"
#import "TripViewVC.h"
#import "TreadsSession.h"
#import "TripBrowser.h"
#import "LocationService.h"
#import "EditProfileVC.h"
#import "FollowService.h"
#import "CameraService.h"
#import "ImageService.h"
#import "ImageScrollBrowser.h"
#import "ImageScrollEditableTextView.h"
#import "AppDelegate.h"

@interface ProfileVC ()

@property IBOutlet UIButton * profilePic;
@property IBOutlet UIButton * banner;
@property IBOutlet UILabel * name;
@property IBOutlet UIButton * follow;
@property UIImageView* profileImage;
@property UIImageView* coverImage;
//@property IBOutlet UIButton * edit;
//@property TripService* tripService;
@property UserService* userService;
@property ImageService* imageService;
@property FollowService* followService;
@property int userID;
@property (strong) TripBrowser* browser;
@property LocationService * locationService;
@property int followID;
@property User* returnedUser;
@property (strong) UIBarButtonItem* logoutButton;
@property (strong) UIBarButtonItem* settingsButton;
@property BOOL myProfile;

@property CommentService * commentService;


@end

@implementation ProfileVC {
    CameraService* cameraService;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tripService:(TripService *)myTripService userService:(UserService *)myUserService imageService:(ImageService*)myImageService isUser:(BOOL)isUser userID:(int)myUserID withLocationService:(LocationService*) locationService withCommentService:(CommentService*) commentService withFollowService:(FollowService*) myFollowService
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _activityIndicatorView.hidesWhenStopped= YES;
        _activityIndicatorView.hidden=YES;
        self.title = NSLocalizedString(@"Profile", @"Profile");
        self.tabBarItem.image = [UIImage imageNamed:(@"man.png")];
//        self.tripService = myTripService;
        self.userService = myUserService;
        self.imageService = myImageService;
        self.locationService = locationService;
        self.userID = myUserID;
        self.myProfile = isUser;
        self.commentService=commentService;
        self.followService = myFollowService;
        self.followID = -1;
        self.profilePic.enabled = false;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(editProfile)];
    
    if(self.myProfile) {
        self.navigationItem.leftBarButtonItem = self.logoutButton;
        self.navigationItem.rightBarButtonItem = self.settingsButton;
    }
//      self.edit.hidden = true;
    self.follow.hidden = true;
//    self.profilePic.adjustsImageWhenDisabled = NO;
//    self.profilePic.adjustsImageWhenHighlighted = NO;
    
    if(self.myProfile) {
        self.userID = [TreadsSession instance].treadsUserID;
        self.profilePic.enabled = true;
        self.banner.enabled = true;
    }
    else {
        self.profilePic.enabled = false;
        self.banner.enabled = false;
        [self.followService getPeopleIFollow:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(followDataHasLoaded:)];
    }
    
    //additional layout
    self.view.backgroundColor = [AppColors tertiaryBackgroundColor];
    self.nameHighlightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.banner setFrame:CGRectMake(self.view.bounds.size.width/2 - 330, 0, 660, 240)];
    [self.nameHighlightView setFrame:CGRectMake(0, 24, 660, 64)];
    [self.profilePic setFrame:CGRectMake(20, 16, 136, 136)];
    [self.banner setContentMode:UIViewContentModeScaleAspectFill];
    
    self.profileImage = [[UIImageView alloc] initWithFrame:self.profilePic.frame];
    [self.profileImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.profileImage setClipsToBounds:YES];
    [self.profileImage setBackgroundColor:[AppColors blankItemBackgroundColor]];
    
    self.coverImage = [[UIImageView alloc] initWithFrame:self.banner.bounds];
    [self.coverImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.coverImage setClipsToBounds:YES];
    [self.coverImage setBackgroundColor:[AppColors tertiaryBackgroundColor]];
    
    [self.name setFrame:CGRectMake(176, 33, 480, 46)];
    [self.name setFont:[UIFont boldSystemFontOfSize: 38]];
    [self.name setTextColor:[AppColors lightTextColor]];
    [self.name setTextAlignment:NSTextAlignmentLeft];
    [self.name setAdjustsFontSizeToFitWidth:YES];
    
    [self.nameHighlightView removeFromSuperview];
    [self.banner addSubview:self.coverImage];
    [self.banner addSubview:self.nameHighlightView];
    [self.profilePic removeFromSuperview];
    [self.banner addSubview:self.profilePic];
    [self.name removeFromSuperview];
    [self.banner addSubview:self.name];
    [self.banner addSubview:self.profileImage];
    
    [self.banner bringSubviewToFront:self.profileImage];
    [self.banner bringSubviewToFront:self.profilePic];
    
    [self.banner setUserInteractionEnabled:YES];
    
    [self.browserWindow setBackgroundColor:[AppColors secondaryBackgroundColor]];
}


-(void) logout {
    UIAlertView * alert= [[UIAlertView alloc]initWithTitle:@"Logout" message:[NSString stringWithFormat:@"Logout of Treads?"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)gotoLoginScreen
{
    [TreadsSession instance].treadsUser = @"";
    [TreadsSession instance].treadsUserID = -1;
    [TreadsSession instance].profilePhotoID = -1;
    [TreadsSession instance].coverPhotoID = -1;
    [TreadsSession instance].fName = @"";
    [TreadsSession instance].lName = @"";
    [[TreadsSession instance] Logout];
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate logout];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
    }
    else if (buttonIndex == 1)
    {
        [self gotoLoginScreen];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.activityIndicatorView startAnimating];
    [self.userService getUserbyID:self.userID forTarget:self withAction:@selector(dataHasLoaded:)];
    
}

- (void)dataHasLoaded:(NSArray*)newData{
    if(1 == newData.count) {
        self.returnedUser = (User*)newData[0];
        
        self.name.text = [NSString stringWithFormat:@"%@ %@", self.returnedUser.fname, self.returnedUser.lname];
        
        
        if (self.returnedUser.User_ID == [TreadsSession instance].treadsUserID) {
//            self.edit.hidden = false;
        }
        else {
            self.follow.hidden = false;
        }
      
        [[TripService instance] getTripsWithUserID:self.userID forTarget:self withAction:@selector(tripsHaveLoaded:)];
        
    }
}



- (void)tripsHaveLoaded:(NSArray*)newData {
    self.browser = [[TripBrowser alloc] initWithFrame:self.browserWindow.bounds];
//    self.browser.cellStyle = TripBrowserCell6x2;
    [self.browser setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.browserWindow addSubview: self.browser];
    [self.browser clearAndWait];
    [self.browser setBrowserData:newData withCellStyle:TripBrowserCell3x4 forTarget:self withAction:@selector(showTrip:)];
    for (Trip* trip in newData) {
        [[TripService instance] getHeaderImageForTrip:trip forTarget:self withCompleteAction:@selector(refreshWithNewHeader)];
    }
    CompletionWithItems completion= ^(NSArray* items) {
        [self.activityIndicatorView stopAnimating];
        if (items.count > 0) {
            UIImage *returnImage= items[0];
            [self.profileImage setImage:returnImage];//] forState:UIControlStateNormal];
        }
        else {
//            UIImage* defaultPic = [UIImage imageNamed:@"man.png"];
            [self.profileImage setImage:[ImageService emptyImage]];// forState:UIControlStateNormal];
        }
        
    };
    [self.imageService getImageWithPhotoID:self.returnedUser.profilePhotoID withReturnBlock:completion];
    [self.imageService getImageWithPhotoID:self.returnedUser.coverPhotoID withReturnBlock:^(NSArray *items) {
        if (items.count > 0) {
            UIImage *returnImage= items[0];
            [self.coverImage setImage:returnImage];
        }
        else {
            [self.coverImage setImage:[ImageService emptyImage]];
        }
    }];
}
- (IBAction)changeBanner:(id)sender {
    ProfileVC* __weak _self = self;
    [[CameraService instance]showImagePickerFromViewController:_self onSuccess:^(UIImage* image) {
        [self.coverImage setImage:image];
        [[ImageService instance] insertImage:image withCompletion:^(NSDictionary *item, NSError* error ) {
            if (error == nil) {
                self.returnedUser.coverPhotoID = [((NSString*)item[@"id"]) intValue];
                [TreadsSession instance].coverPhotoID = [((NSString*)item[@"id"]) intValue];
                [[UserService instance] updateUser:self.returnedUser forTarget:self withAction:@selector(photoUpdateSuccess)];
            }
            else {
                NSLog(@"%@", error);
            }
        }];
        
    }];
}

- (void)refreshWithNewHeader
{
    [self.browser refreshWithNewImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePic:(id)sender {
    
    ProfileVC* __weak _self = self;
    [[CameraService instance]showImagePickerFromViewController:_self onSuccess:^(UIImage* image) {
        [self.profileImage setImage:image];//forState:UIControlStateNormal];
        [[ImageService instance] insertImage:image withCompletion:^(NSDictionary *item, NSError* error ) {
            if (error == nil) {
                self.returnedUser.profilePhotoID = [((NSString*)item[@"id"]) intValue];
                [TreadsSession instance].profilePhotoID = [((NSString*)item[@"id"]) intValue];
                [[UserService instance] updateUser:self.returnedUser forTarget:self withAction:@selector(photoUpdateSuccess)];
            }
        }];
        
    }];
}

- (void)photoUpdateSuccess {
    
}

- (void)showTrip:(Trip*)trip
{
    TripViewVC* tripViewVC = [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil backTitle:self.title tripService:[TripService instance] tripID:trip.tripID LocationService:_locationService withCommentService:_commentService withUserService: _userService];
    [self.navigationController pushViewController:tripViewVC animated:YES];
}

- (void)updateUser:(int)myUserID{
    self.userID = myUserID;
    if(self.userID == [TreadsSession instance].treadsUserID) {
        self.myProfile = YES;
    }
    else {
        self.myProfile = NO;
    }
}

- (void)editProfile
{
    EditProfileVC* editProfileVC = [[EditProfileVC alloc]initWithNibName:@"EditProfileVC" bundle:nil userService:self.userService];
    [self.navigationController pushViewController:editProfileVC animated:YES];
}

- (void) followDataHasLoaded:(NSArray*)newData {
    [self.follow setTitle:@"Follow" forState:UIControlStateNormal];
    self.followID = -1;

    for (int x = 0; x < newData.count; x++) {
        if (self.userID == [((NSString*)newData[x][@"TheirID"])intValue]) {
            [self.follow setTitle:@"Unfollow" forState:UIControlStateNormal];
            self.followID = [((NSString*)newData[x][@"id"])intValue];
            break;
        }
    }
    self.follow.enabled = true;
}

- (IBAction)followUser:(id)sender {
    self.follow.enabled = false;
    if(self.followID < 0) {
        [self.followService addFollow:[TreadsSession instance].treadsUserID withTheirID:self.userID fromTarget:self withReturn:@selector(followSuccess)];
    }
    else {
        [self.followService deleteFollow:[NSString stringWithFormat:@"id = %i", self.followID] fromTarget:self withReturn:@selector(followSuccess)];
    }
}

- (void) followSuccess {
    [self.followService getPeopleIFollow:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(followDataHasLoaded:)];

}

@end
