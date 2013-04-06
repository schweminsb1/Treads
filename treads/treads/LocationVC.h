//
//  LocationVC.h
//  treads
//
//  Created by Sam Schwemin on 4/3/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LocationService.h"
#import "CommentService.h"
#import "Location.h"
#import "CommentEnterBox.h"

@interface LocationVC : UIViewController 

@property CommentService * commentService;
@property Location * model;

//UI
@property (strong, atomic) IBOutlet  UILabel * name;
@property (strong, atomic) IBOutlet  UILabel * lat;
@property (strong, atomic) IBOutlet  UILabel * lon;
@property (strong, atomic) IBOutlet  UITextView * description;
@property IBOutlet UITableView * commentTable;
@property CommentEnterBox * commentEnterCell;




-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withModel: (Location *) model withCommentService: (CommentService *) service;


@end
