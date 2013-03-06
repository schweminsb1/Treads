//
//  FollowVC.h
//  Treads
//
//  Created by Zachary Kanoff on 2/11/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowVC : UIViewController

@property (strong) IBOutlet UILabel* label;

@property (strong) IBOutlet UIView* browserWindow;

-(IBAction)segmentControlChange:(UISegmentedControl*)sender;

@end
