//
//  FollowVC.m
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "FollowVC.h"

#import "TripBrowser.h"

#import "TripService.h"
#import "Trip.h"
#import "User.h"

#import "TripViewVC.h"
#import "LocationService.h"
#import "FollowService.h"
#import "UserService.h"
#import "TreadsSession.h"
#import "ImageService.h"
#import "ProfileVC.h"

@interface FollowVC ()<UISearchBarDelegate> {
    NSArray* browserModeControlLabels;
    NSArray* browserModeControlActions;
    NSArray* browserModeSearchBars;
    NSArray* browserCellStyles;
}

@property (strong) TripService* tripService;
@property (strong) TripBrowser* browser;

@property (strong) UIView* titleView;
@property (strong) UISegmentedControl* browserModeControl;
@property (strong) UISearchBar* userSearchBar;
@property (strong) UISearchBar* tripFilterBar;

@property LocationService * locationService;
@property CommentService * commentService;
@property UserService * userService;

@end

@implementation FollowVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTripService:(TripService*)tripServiceHandle withLocationService:(LocationService*)locationservice withCommentService:(CommentService*) commentService withUserService:(UserService*) userService
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //toolbar
        _userService=userService;
        self.title = NSLocalizedString(@"Follow", @"Follow");
        self.tabBarItem.image = [UIImage imageNamed:@"compass.png"];
        _locationService=locationservice;
        //set up services
        self.tripService = tripServiceHandle;//[[TripService alloc] init];
        _commentService = commentService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set up segmented control
    browserModeControlLabels = @[
                                 @"Following",
                                 @"Feed",
                                 @"Favorites",
                                 @"All"
                                 ];
    browserModeControlActions = @[
                                  ^void(void) {[[FollowService instance] getPeopleIFollow:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(profileDataHasLoadedFromFollowService:)];},
                                   ^void(void) {[[TripService instance] getFeedItemsForUserID:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(tripDataHasLoaded:)];},
                                   ^void(void) {[[TripService instance] getFavoriteItemsForUserID:[TreadsSession instance].treadsUserID forTarget:self withAction:@selector(tripDataHasLoaded:)];},
                                   ^void(void) {[[TripService instance] getAllTripsForTarget:self withAction:@selector(tripDataHasLoaded:)];}
                      ];
    browserCellStyles = @[
                          [NSNumber numberWithInt:ProfileBrowserCell5x1],
                          [NSNumber numberWithInt:TripBrowserCell4x4],
                          [NSNumber numberWithInt:TripBrowserCell4x4],
                          [NSNumber numberWithInt:TripBrowserCell4x4]
                         ];
    
    //set up header
//    CGRect windowBounds = [[UIScreen mainScreen] bounds];)
    self.titleView = [[UIView alloc] init];
    
    [self.titleView setBounds:CGRectMake(0, 0, 550, 44)];
//    [self.titleView setBounds:CGRectMake(0, 0, windowBounds.size.width * 0.75, 44)];
//    [self.titleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    //browser mode control
    self.browserModeControl = [[UISegmentedControl alloc] initWithItems:browserModeControlLabels];
    self.browserModeControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.browserModeControl setFrame:CGRectMake(0, self.titleView.bounds.size.height / 2 - self.browserModeControl.bounds.size.height / 2, self.browserModeControl.bounds.size.width, self.browserModeControl.bounds.size.height)];
    [self.browserModeControl addTarget:self action:@selector(segmentControlChange:) forControlEvents:UIControlEventValueChanged];
    self.browserModeControl.tintColor = self.navigationController.navigationBar.tintColor;
    [self.titleView addSubview:self.browserModeControl];
    
    //user search bar
    self.userSearchBar = [[UISearchBar alloc] init];
    self.userSearchBar.hidden = YES;
    self.userSearchBar.placeholder = @"Find Users";
    self.userSearchBar.delegate = self;
    self.userSearchBar.barStyle = self.navigationController.navigationBar.barStyle;
    self.userSearchBar.tintColor = self.navigationController.navigationBar.tintColor;
    self.userSearchBar.frame = CGRectMake(self.browserModeControl.bounds.size.width + 12, 0, self.titleView.bounds.size.width - self.browserModeControl.bounds.size.width - 12, 42);
//    self.userSearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.titleView addSubview:self.userSearchBar];
    
    //trip filter bar
    self.tripFilterBar = [[UISearchBar alloc] init];
    self.tripFilterBar.hidden = YES;
    self.tripFilterBar.placeholder = @"Search";
    self.tripFilterBar.delegate = self;
    self.tripFilterBar.barStyle = self.navigationController.navigationBar.barStyle;
    self.tripFilterBar.tintColor = self.navigationController.navigationBar.tintColor;
    self.tripFilterBar.frame = CGRectMake(self.browserModeControl.bounds.size.width + 12, 0, self.titleView.bounds.size.width - self.browserModeControl.bounds.size.width - 12, 42);
//    self.tripFilterBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.titleView addSubview:self.tripFilterBar];
    
    [self.navigationController.navigationBar.topItem setTitleView:self.titleView];
    
    browserModeSearchBars = @[
                              self.userSearchBar,
                              self.tripFilterBar,
                              self.tripFilterBar,
                              self.tripFilterBar
                              ];
    
    //set up browser
    self.browser = [[TripBrowser alloc] initWithFrame:self.browserWindow.bounds];
    [self.browser setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    FollowVC* __weak _self = self;
    self.browser.sendToggleFollowRequestForUser = ^(User* user) {
        if(user.followID < 0) {
            [[FollowService instance] addFollow:[TreadsSession instance].treadsUserID withTheirID:user.User_ID fromTarget:_self withReturn:@selector(followSuccess)];
        }
        else {
            [[FollowService instance] deleteFollow:[NSString stringWithFormat:@"id = %i", user.followID] fromTarget:_self withReturn:@selector(followSuccess)];
        }
    };
    [self.browserWindow addSubview: self.browser];
    
    //initial display
    [self.browserModeControl setSelectedSegmentIndex:1];
}

- (void)followSuccess
{
    [self searchBar:self.userSearchBar textDidChange:self.userSearchBar.text];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self segmentControlChange:self.browserModeControl];
}

//-(void) viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar.topItem setTitleView:nil];
//}

- (void)segmentControlChange:(UISegmentedControl*)sender
{
    [self.browser clearAndWait];
    void(^fcn)(void) = browserModeControlActions[sender.selectedSegmentIndex]; fcn();
    for (int i = 0; i < browserModeSearchBars.count; i++) {
        ((UISearchBar*)browserModeSearchBars[i]).text = @"";
        [browserModeSearchBars[i] setHidden:YES];
        [browserModeSearchBars[i] resignFirstResponder];
    }
    [browserModeSearchBars[sender.selectedSegmentIndex] setHidden:NO];
    self.tripFilterBar.placeholder = [NSString stringWithFormat:@"Search %@", browserModeControlLabels[sender.selectedSegmentIndex]];
}

- (void)profileDataHasLoadedFromFollowService:(NSArray*)newData
{
    NSMutableArray* profileArray = [[NSMutableArray alloc] init];
    for (NSDictionary* dictionary in newData) {
        [profileArray addObject:dictionary[@"followProfile"]];
    }
    [self profileDataHasLoaded:profileArray];
}

- (void)profileDataHasLoadedFromUserService:(NSArray*)newData
{
    [self profileDataHasLoaded:[NSMutableArray arrayWithArray:newData]];
}

- (void)profileDataHasLoaded:(NSMutableArray*)profileArray
{
    if (self.browserModeControl.selectedSegmentIndex == 0) {
        [profileArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [((User*)obj1).fname compare:((User*)obj2).fname];
        }];
        [self.browser setBrowserData:profileArray withCellStyle:(TripBrowserCellStyle)[browserCellStyles[self.browserModeControl.selectedSegmentIndex] intValue] forTarget:self withAction:@selector(showProfile:)];
        for (User* user in profileArray) {
            [[ImageService instance] getImageWithPhotoID:user.profilePhotoID withReturnBlock:^(NSArray *items) {
                if (items.count > 0) {
                    user.profileImage = (UIImage*)items[0];
                }
                else {
                    user.profileImage = [ImageService imageNotFound];
                }
                [self refreshWithNewHeader];
            }];
            [[ImageService instance] getImageWithPhotoID:user.coverPhotoID withReturnBlock:^(NSArray *items) {
                if (items.count > 0) {
                    user.coverImage = (UIImage*)items[0];
                }
                else {
                    user.coverImage = [ImageService imageNotFound];
                }
                [self refreshWithNewHeader];
            }];
        }
    }
}

- (void)tripDataHasLoaded:(NSArray*)newData
{
    if (self.browserModeControl.selectedSegmentIndex > 0) {
        [self.browser setBrowserData:newData withCellStyle:(TripBrowserCellStyle)[browserCellStyles[self.browserModeControl.selectedSegmentIndex] intValue] forTarget:self withAction:@selector(showTrip:)];
        for (Trip* trip in newData) {
            [self.tripService getHeaderImageForTrip:trip forTarget:self withCompleteAction:@selector(refreshWithNewHeader)];
        }
    }
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

- (void)showTrip:(Trip*)trip
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:browserModeControlLabels[self.browserModeControl.selectedSegmentIndex] style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: newBackButton];
    
    TripViewVC* tripViewVC = [[TripViewVC alloc] initWithNibName:@"TripViewVC" bundle:nil backTitle:browserModeControlLabels[self.browserModeControl.selectedSegmentIndex] tripService:self.tripService tripID:trip.tripID LocationService:_locationService withCommentService:_commentService withUserService:_userService];
    [self.navigationController pushViewController:tripViewVC animated:YES];
}

- (void)showProfile:(User*)profile
{
    ProfileVC* profilevc= [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil tripService:_tripService userService:_userService imageService:[ImageService instance] isUser:NO userID:profile.User_ID withLocationService:_locationService withCommentService:_commentService withFollowService:[FollowService instance]];
    [self.navigationItem.backBarButtonItem setTitle:browserModeControlLabels[self.browserModeControl.selectedSegmentIndex]];
    [self.navigationController pushViewController:profilevc animated:YES];
}

#pragma mark - Search

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar == self.userSearchBar) {
        if ([searchText isEqual:@""]) {
            void(^fcn)(void) = browserModeControlActions[0]; fcn();
        }
        else {
            [[UserService instance] getUsersContainingSubstring:searchText forTarget:self withAction:@selector(profileDataHasLoadedFromUserService:)];
        }
    }
    
    if (searchBar == self.tripFilterBar) {
        [self.browser setFilterString:searchText];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == self.tripFilterBar) {
        
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar == self.tripFilterBar) {
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == self.tripFilterBar) {
        [self.tripFilterBar resignFirstResponder];
    }
}

@end
