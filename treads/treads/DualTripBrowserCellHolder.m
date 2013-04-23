//
//  DualTripBrowserCellHolder.m
//  treads
//
//  Created by keavneyrj1 on 4/23/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "DualTripBrowserCellHolder.h"

#import "TripBrowserCell.h"

#import "Trip.h"

#import "AppColors.h"
#import "TripService.h"

@interface DualTripBrowserCellHolder()

@property (readwrite) TripBrowserCellStyle cellStyle;

@end

@implementation DualTripBrowserCellHolder {
    BOOL layoutDone;
    NSArray* browserCells;
    UIView* subView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(TripBrowserCellStyle)cellStyle
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self layoutSubviews];
        layoutDone = NO;
        self.cellStyle = cellStyle;
        browserCells = @[
//                         [[TripBrowserCell alloc] initWithStyle:style reuseIdentifier:[NSString stringWithFormat:@"%@_A", reuseIdentifier] cellStyle:cellStyle],
//                         [[TripBrowserCell alloc] initWithStyle:style reuseIdentifier:[NSString stringWithFormat:@"%@_B", reuseIdentifier] cellStyle:cellStyle]
                         [[TripBrowserCell alloc] initWithCellStyle:cellStyle],
                         [[TripBrowserCell alloc] initWithCellStyle:cellStyle]
                         ];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!layoutDone) {
        //add subviews if layout has not been set
        [self createAndAddSubviews];
        layoutDone = YES;
    }
    
    if (self.cellStyle == TripBrowserCell3x4) {
        [subView setFrame:CGRectMake(self.bounds.size.width/2-340, 8, 680, 344)];
        [browserCells[0] setFrame:CGRectMake(0, 0, 330, 344)];
        [browserCells[1] setFrame:CGRectMake(350, 0, 330, 344)];
    }
}

- (void)createAndAddSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    subView = [[UIView alloc] init];
    subView.backgroundColor = [UIColor clearColor];
    [self addSubview:subView];
        
    [subView addSubview:browserCells[0]];
    [subView addSubview:browserCells[1]];
        
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setDisplayTripArray:(NSArray *)displayTripArray
{
    [browserCells[0] setDisplayTrip:displayTripArray[0]];
    if (displayTripArray.count > 1) {
        [browserCells[1] setHidden:NO];
        [browserCells[1] setDisplayTrip:displayTripArray[1]];
    }
    else {
        [browserCells[1] setHidden:YES];
    }
}

- (void)setDelegate:(TripBrowser *)delegate
{
    [browserCells[0] setDelegate:delegate];
    [browserCells[1] setDelegate:delegate];
}

- (void)setRow:(int)row
{
    [browserCells[0] setRow:row*2];
    [browserCells[1] setRow:row*2+1];
}

- (void)setDeletefrom:(SEL)deletefrom
{
    [browserCells[0] setDeletefrom:deletefrom];
    [browserCells[1] setDeletefrom:deletefrom];
}

@end
