//
//  EditControlsView.h
//  treads
//
//  Created by keavneyrj1 on 4/9/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditControlsView <NSObject>

@required
@property (copy) void(^requestChangeItem)();
@property (copy) void(^requestRemoveItem)();
@property (copy) void(^requestMoveBackward)();
@property (copy) void(^requestMoveForward)();

@end
