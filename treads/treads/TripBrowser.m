//
//  TripBrowser.m
//  treads
//
//  Created by keavneyrj1 on 3/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripBrowser.h"
#import "TripService.h"
#import "TripBrowserCell.h"
#import "ProfileBrowserCell.h"
#import "DualTripBrowserCellHolder.h"
#import "TripBrowser.h"
#import "User.h"

#import "AppColors.h"

@interface TripBrowser()<UITableViewDataSource, UITableViewDelegate>

@property TripBrowserCellStyle cellStyle;
@property Trip * recentlySelectedTripForDeletion;
@end

@implementation TripBrowser {
    BOOL layoutDone;
    BOOL headerCell;
    NSMutableArray* sortedListData;
    SEL listSelectAction;
    NSObject* target;
    UITableView* browserTable;
    UIActivityIndicatorView* activityIndicatorView;
    int cellVerticalPadding;
}

- (NSString*)getCellIdentifier
{
    return [NSString stringWithFormat:@"CELL_STYLE_%d", self.cellStyle];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        layoutDone = NO;
        headerCell = NO;
        [self layoutSubviews];
        listSelectAction = nil;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!layoutDone) {
        [self setUpSubviews];
    }
    
    [activityIndicatorView setFrame:self.bounds];
    [activityIndicatorView setCenter:self.center];
}

- (void)setUpSubviews
{
    //set up table view
    browserTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [browserTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [browserTable setDelegate:self];
    [browserTable setDataSource:self];
    [browserTable setBackgroundColor:[AppColors secondaryBackgroundColor]];
    [browserTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:browserTable];
    cellVerticalPadding = 16;
    
    //set up activity view
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    [activityIndicatorView stopAnimating];
    [activityIndicatorView setHidesWhenStopped:YES];
    activityIndicatorView.alpha = 1.0;
    activityIndicatorView.center = self.center;
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicatorView.color = [AppColors activityIndicatorColor];
    [self addSubview:activityIndicatorView];
    [self bringSubviewToFront:activityIndicatorView];
    
    layoutDone = YES;
}

//- (void)setCellStyle:(TripBrowserCellStyle)cellStyle
//{
//    _cellStyle = cellStyle;
//    [browserTable reloadData];
//}

#pragma mark - Data Setting/Interaction

- (void)setBrowserData:(NSArray*)newSortedData withCellStyle:(TripBrowserCellStyle)cellStyle forTarget:(NSObject*)newTarget withAction:(SEL)newListSelectAction
{
    _cellStyle = cellStyle;
    sortedListData =[NSMutableArray arrayWithArray: newSortedData];
    target = newTarget;
    listSelectAction = newListSelectAction;
    
    [browserTable reloadData];
    [browserTable setContentOffset:CGPointZero animated:NO];
    [activityIndicatorView stopAnimating];
//    if (newSortedData != nil) {[activityIndicatorView stopAnimating];}
}

- (void)clearAndWait
{
    [self setBrowserData:nil withCellStyle:self.cellStyle forTarget:nil withAction:nil];
    [activityIndicatorView startAnimating];
}

- (void)refreshWithNewImages
{
    [browserTable reloadData];
}

#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;//sortedListData.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.cellStyle == TripBrowserCell3x4) {return (sortedListData.count+1)/2;}
    return sortedListData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.cellStyle) {
        case TripBrowserCell3x4: {
            DualTripBrowserCellHolder* cell = [tableView dequeueReusableCellWithIdentifier:[self getCellIdentifier]];
            if (!cell) {
                cell = [[DualTripBrowserCellHolder alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getCellIdentifier] cellStyle:self.cellStyle];
            }
            cell.deletefrom = @selector(deleteTrip:);
            if (2*indexPath.row+1 < sortedListData.count) {
                cell.displayTripArray = @[(Trip*)sortedListData[2*indexPath.row], (Trip*)sortedListData[2*indexPath.row+1]];
            }
            else {
                cell.displayTripArray = @[(Trip*)sortedListData[2*indexPath.row]];
            }
            cell.delegate = self;
            cell.row = indexPath.row;
            return cell;
        }
        case TripBrowserCell4x4:
        case TripBrowserCell4x1:
        case TripBrowserCell5x1:
        case TripBrowserCell6x2: {
            TripBrowserCell* cell = [tableView dequeueReusableCellWithIdentifier:[self getCellIdentifier]];
            if (!cell) {
                cell = [[TripBrowserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getCellIdentifier] cellStyle:self.cellStyle];
            }
            cell.deletefrom = @selector(deleteTrip:);
            cell.displayTrip = (Trip*)sortedListData[indexPath.row];
            cell.delegate = self;
            cell.row = indexPath.row;
            return cell;
        }
        case ProfileBrowserCell5x1: {
            ProfileBrowserCell* cell = [tableView dequeueReusableCellWithIdentifier:[self getCellIdentifier]];
            if (!cell) {
                cell = [[ProfileBrowserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getCellIdentifier] cellStyle:self.cellStyle];
            }
            cell.displayProfile = (User*)sortedListData[indexPath.row];
            cell.delegate = self;
            cell.row = indexPath.row;
            
            return cell;
        }
        default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
- (void)respondToSelectAtRow:(int)row
{
    //listSelectAction((Trip*)sortedListData[indexPath.row]);
    if ([target respondsToSelector:listSelectAction]) {
        switch (self.cellStyle) {
            case TripBrowserCell3x4:
            case TripBrowserCell4x4:
            case TripBrowserCell4x1:
            case TripBrowserCell5x1:
            case TripBrowserCell6x2: {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [target performSelector:listSelectAction withObject:((Trip*)sortedListData[row])];
                #pragma clang diagnostic pop
                break;
            }
            case ProfileBrowserCell5x1: {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [target performSelector:listSelectAction withObject:((User*)sortedListData[row])];
                #pragma clang diagnostic pop
                break;
            }
        }
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return cellVerticalPadding / 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return cellVerticalPadding / 2;
}

- (CGFloat)tableView:tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [self tableView:tableView cellForRowAtIndexPath:indexPath].bounds.size.height + cellVerticalPadding;
    return [TripBrowserCell heightForCellStyle:self.cellStyle] + cellVerticalPadding;
}

- (void)deleteTrip:(Trip*)trip
{
    self.recentlySelectedTripForDeletion = trip;
    UIAlertView * alert= [[UIAlertView alloc]initWithTitle:@"Delete Trip?" message:[NSString stringWithFormat:@"You are about to delete Trip '%@' ", trip.name] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [alert show];
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[TripService instance]deleteTripWithID:self.recentlySelectedTripForDeletion.tripID forTarget:self withAction:@selector(didDeleteTripWithID:)];
    }
}

- (void)didDeleteTripWithID:(NSNumber*)index
{
    for (int i = 0; i < sortedListData.count; i++)
    {
        if (((Trip*)sortedListData[i]).tripID == [index intValue])
        {
            [sortedListData removeObjectAtIndex:i];
        }
    }
    [browserTable reloadData];
}

@end
