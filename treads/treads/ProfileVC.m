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
#import "ImageScrollBrowser.h"

#import "ImageScrollEditableTextView.h"

@interface ProfileVC ()

@property IBOutlet UIButton * profilePic;
@property IBOutlet UIImageView * banner;
@property IBOutlet UILabel * name;
@property IBOutlet UIButton * follow;
@property IBOutlet UIButton * edit;
@property TripService* tripService;
@property UserService* userService;
@property ImageService* imageService;
@property FollowService* followService;
@property int userID;
@property (strong) TripBrowser* browser;
@property LocationService * locationService;
@property int followID;

@property BOOL myProfile;

@property CommentService * commentService;


@end

@implementation ProfileVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tripService:(TripService *)myTripService userService:(UserService *)myUserService imageService:(ImageService*)myImageService isUser:(BOOL)isUser userID:(int)myUserID withLocationService:(LocationService*) locationService withCommentService:(CommentService*) commentService withFollowService:(FollowService*) myFollowService
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Profile", @"Profile");
        self.tabBarItem.image = [UIImage imageNamed:(@"man.png")];
        self.tripService = myTripService;
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
    

    
    self.edit.hidden = true;
    self.follow.hidden = true;
    
    if(self.myProfile) {
        self.userID = [TreadsSession instance].treadsUserID;
        self.profilePic.enabled = true;
    }
    else {
        [self.followService getPeopleIFollow:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(followDataHasLoaded:)];
    }
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self.userService getUserbyID:self.userID forTarget:self withAction:@selector(dataHasLoaded:)];
    
}

- (void)dataHasLoaded:(NSArray*)newData{
    if(1 == newData.count) {
        User* returnedUser = (User*)newData[0];
        
        self.name.text = [NSString stringWithFormat:@"%@ %@", returnedUser.fname, returnedUser.lname];
        
        
        if (returnedUser.User_ID == [TreadsSession instance].treadsUserID) {
            self.edit.hidden = false;
        }
        else {
            self.follow.hidden = false;
        }
      
        CompletionWithItems completion= ^(NSArray* items) {
            if (items.count > 0) {
                UIImage *returnImage= items[0];
                [self.profilePic setImage:returnImage forState:UIControlStateNormal];
            }
            else {
                UIImage* defaultPic = [UIImage imageNamed:@"man.png"];
                [self.profilePic setImage:defaultPic forState:UIControlStateNormal];
            }
                [self.tripService getTripsWithUserID:self.userID forTarget:self withAction:@selector(tripsHaveLoaded:)];
        };
        [self.imageService getImageWithPhotoID:returnedUser.profilePhotoID withReturnBlock:completion];

    }
}



- (void)tripsHaveLoaded:(NSArray*)newData {
    self.browser = [[TripBrowser alloc] initWithFrame:self.browserWindow.bounds];
    self.browser.cellStyle = TripBrowserCell6x2;
    [self.browser setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.browserWindow addSubview: self.browser];
    [self.browser clearAndWait];
    [self.browser setBrowserData:newData forTarget:self withAction:@selector(showTrip:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePic:(id)sender {
    
}

- (void)showTrip:(Trip*)trip
{
    TripViewVC* tripViewVC = [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil backTitle:self.title tripService:self.tripService tripID:trip.tripID LocationService:_locationService withCommentService:_commentService withUserService: _userService];
    [self.navigationController pushViewController:tripViewVC animated:YES];
}

- (void)updateUser:(int)myUserID{
    self.userID = myUserID;
}

- (IBAction)editProfile:(id)sender{
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
