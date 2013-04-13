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


@interface ProfileVC ()

@property IBOutlet UIImageView * profilePic;
@property IBOutlet UIImageView * banner;
@property IBOutlet UILabel * name;
@property IBOutlet UIButton * follow;
@property IBOutlet UIButton * edit;
@property TripService* tripService;
@property UserService* userService;
@property ImageService* imageService;
@property int userID;
@property (strong) TripBrowser* browser;
@property LocationService * locationService;


@property BOOL myProfile;

@property CommentService * commentService;


@end

@implementation ProfileVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tripService:(TripService *)myTripService userService:(UserService *)myUserService imageService:(ImageService*)myImageService isUser:(BOOL)isUser userID:(int)myUserID withLocationService:(LocationService*) locationService withCommentService:(CommentService*) commentService
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
        _commentService=commentService;

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
                UIImage * returnImage= items[0];
                self.profilePic.image = returnImage;
            }
            else {
                UIImage* defaultPic = [UIImage imageNamed:@"man.png"];
                self.profilePic.image = defaultPic;
            }
                [self.tripService getTripsWithUserID:self.userID forTarget:self withAction:@selector(tripsHaveLoaded:)];
        };
        [self.imageService getImageWithPhotoID:returnedUser.profilePictureID withReturnBlock:completion];

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

- (void)showTrip:(Trip*)trip
{
    TripViewVC* tripViewVC = [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil backTitle:self.title tripService:self.tripService tripID:trip.tripID LocationService:_locationService withCommentService:_commentService];
    [self.navigationController pushViewController:tripViewVC animated:YES];
}

- (void)updateUser:(int)myUserID{
    self.userID = myUserID;
}

- (IBAction)editProfile:(id)sender{
    EditProfileVC* editProfileVC = [[EditProfileVC alloc]initWithNibName:@"EditProfileVC" bundle:nil userService:self.userService];
    [self.navigationController pushViewController:editProfileVC animated:YES];
}

@end
