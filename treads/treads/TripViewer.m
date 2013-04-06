//
//  TripViewer.m
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewer.h"

#import "Trip.h"

#import "TripViewerHeaderCell.h"
#import "TripViewerLocationCell.h"
#import "TripViewerAddCell.h"

#import "AppColors.h"

@interface TripViewer()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation TripViewer {
    BOOL layoutDone;
    BOOL editingEnabled;
    BOOL changesMade;
    Trip* trip;
    UITableView* viewerTable;
    UIActivityIndicatorView* activityIndicatorView;
    int cellVerticalPadding;
}

+ (NSString*)headerCellIdentifier {return @"HEADER_CELL";}
+ (NSString*)locationCellIdentifier {return @"LOCATION_CELL";}
+ (NSString*)addCellIdentifer {return @"ADD_CELL";}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        layoutDone = NO;
        changesMade = YES;
        [self layoutSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (layoutDone) {
        return;
    }
    
    layoutDone = YES;
    
    //set up table view
    viewerTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [viewerTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [viewerTable setDelegate:self];
    [viewerTable setDataSource:self];
    [viewerTable setBackgroundColor:[AppColors secondaryBackgroundColor]];
    [viewerTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:viewerTable];
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
}

#pragma mark - Data Setting/Interaction

- (void)setViewerTrip:(Trip*)newTrip enableEditing:(BOOL)canEditTrip;
{
    trip = newTrip;
    [self setEditingEnabled:canEditTrip];
    
    [viewerTable reloadData];
    [viewerTable setContentOffset:CGPointZero animated:NO];
    if (newTrip != nil) {[activityIndicatorView stopAnimating];}
    else {[self setEditingEnabled:NO];}
}

- (Trip*)viewerTrip
{
    return trip;
}

- (BOOL)editingEnabled
{
    return editingEnabled;
}

- (void)setEditingEnabled:(BOOL)canEditTrip
{
    editingEnabled = canEditTrip;
    if (editingEnabled) {[viewerTable setBackgroundColor:[AppColors tertiaryBackgroundColor]];}
    else {[viewerTable setBackgroundColor:[AppColors secondaryBackgroundColor]];}
    
    //change cells' editing status
    [self setNeedsDisplay];
}

- (void)displayTripLoadFailure
{
    [activityIndicatorView stopAnimating];
    /* put a modal dialog here to show that the trip could not load */
}

- (Trip*)getViewerTrip
{
    return trip;
}

- (void)clearAndWait
{
    [activityIndicatorView startAnimating];
    [self setViewerTrip:nil enableEditing:NO];
}

#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;//sortedListData.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (trip == nil) {return 0;}
    //1 overview cell, 1 location cell per location, and 1 add location cell (if editable)
    return 1 + trip.tripLocations.count + (editingEnabled ? 1 : 0);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell* cell;
    if (indexPath.row == 0) {
        //header cell
        TripViewerHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:[TripViewer headerCellIdentifier]];
        if (!cell) {
            cell = [[TripViewerHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TripViewer headerCellIdentifier]];
        }
        //fill out data
        TripViewer* __weak _self = self;
        cell.editingEnabled = ^BOOL(){return [_self editingEnabled];};
        cell.markChangeMade = ^(){[_self markChangeMade];};
        cell.trip = trip;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row <= trip.tripLocations.count) {
        //location cell
        TripViewerLocationCell* cell = [tableView dequeueReusableCellWithIdentifier:[TripViewer locationCellIdentifier]];
        if (!cell) {
            cell = [[TripViewerLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TripViewer locationCellIdentifier]];
        }
        //fill out data
        TripViewer* __weak _self = self;
        cell.editingEnabled = ^BOOL(){return [_self editingEnabled];};
        cell.markChangeMade = ^(){[_self markChangeMade];};
        cell.tripLocation = trip.tripLocations[indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (editingEnabled) {
        //add cell
        TripViewerAddCell* cell = [tableView dequeueReusableCellWithIdentifier:[TripViewer addCellIdentifer]];
        if (!cell) {
            cell = [[TripViewerAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TripViewer addCellIdentifer]];
        }
        //fill out data
        
        return cell;
    }
    else {
        //error: invalid index
        [NSException raise:@"Error: invalid cell index for TripViewer" format:@"Invalid cell load attempt at: %i",indexPath.row];
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)markChangeMade
{
    changesMade = YES;
}

- (void)clearChangesFlag
{
    changesMade = NO;
}

- (BOOL)changesWereMade
{
    return changesMade;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
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

- (CGFloat)tableView: tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 480 + cellVerticalPadding;
    }
    return 620 + cellVerticalPadding;
    //return [self tableView:tableView cellForRowAtIndexPath:indexPath].bounds.size.height + cellVerticalPadding;
}

@end
