//
//  DataRepository.h
//  treads
//
//  Created by keavneyrj1 on 3/12/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AppDelegate.h"

@interface DataRepository : NSObject

@property MSClient* client;

- (void)getTripsMeetingCondition:(NSString*)predicateBody forTarget:(NSObject*)target withAction:(SEL) returnAction;

- (void)updateTrip:(NSDictionary*)tripDictionary forTarget:(NSObject*)target withAction:(SEL)returnAction;

- (int)getNewTripID;

@end
