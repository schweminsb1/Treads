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
        changesMade = NO;
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
    
    //reload table data
    [viewerTable reloadData];
    
    //scroll if at bottom of screen to show/hide add button
//    if (viewerTable.contentOffset.y == viewerTable.contentSize.height - self.bounds.size.height) {
//        [viewerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:trip.tripLocations.count+(editingEnabled?1:0) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
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

- (void)prepareForExit
{
    //resign all first responders
    //[self setEditingEnabled:NO];
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
        TripViewerLocationCell* __weak _cell = cell;
        cell.gotolocationpage=_gotolocationpage;
        cell.editingEnabled = ^BOOL(){return [_self editingEnabled];};
        cell.markChangeMade = ^(){[_self markChangeMade];};
        cell.tripLocation = trip.tripLocations[indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sendNewLocationRequest = ^(){
            self.sendNewLocationRequest(^(TripLocation* newTripLocation){
                [_cell changeLocation:newTripLocation.locationID];
            });
//            [_cell changeLocation:200];
        };
        cell.sendNewImageRequest = self.sendNewImageRequest;
        cell.sendDeleteLocationRequest = ^(){[_self removeLocationAtIndex:indexPath.row-1];};
        cell.sendMoveForwardRequest = ^(){[_self swapLocationItemsAtIndex:(indexPath.row-1) index:(indexPath.row)];};
        cell.sendMoveBackwardRequest = ^(){[_self swapLocationItemsAtIndex:(indexPath.row-1) index:(indexPath.row-2)];};
        return cell;
    }
    else if (editingEnabled) {
        //add cell
        TripViewerAddCell* cell = [tableView dequeueReusableCellWithIdentifier:[TripViewer addCellIdentifer]];
        if (!cell) {
            cell = [[TripViewerAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TripViewer addCellIdentifer]];
        }
        //fill out data
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)refreshWithNewImages
{
    [viewerTable reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingEnabled && indexPath.row == trip.tripLocations.count + 1) {
        //add new location
        //at some point this will need to be converted to an async call/request function
        TripLocation* dummyLocation = [[TripLocation alloc] init];
        dummyLocation.tripLocationID = trip.tripLocations.count;
        dummyLocation.tripID = trip.tripID;
        dummyLocation.locationID = trip.tripLocations.count;
        dummyLocation.description = @"New location";
        dummyLocation.tripLocationItems = [[NSArray alloc] init];
        [self addLocationToCurrentTrip:dummyLocation];
    }
    return;
}

- (void)addLocationToCurrentTrip:(TripLocation*)newLocation
{
    NSMutableArray* temp = [NSMutableArray arrayWithArray:trip.tripLocations];
    [temp addObject:newLocation];
    
    trip.tripLocations = temp;
    [self markChangeMade];
    [viewerTable reloadData];
    //[viewerTable setContentOffset:CGPointMake(0, viewerTable.contentOffset.y + 620) animated:YES];
    [viewerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:trip.tripLocations.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)removeLocationAtIndex:(int)index
{
    if (index >= 0 && index < trip.tripLocations.count) {
        NSMutableArray* temp = [NSMutableArray arrayWithArray:trip.tripLocations];
        [temp removeObjectAtIndex:index];
        trip.tripLocations = temp;
        [self markChangeMade];
        [viewerTable reloadData];
    }
}

- (void)swapLocationItemsAtIndex:(int)index1 index:(int)index2
{
    if (index1 >= 0 && index2 >= 0 && index1 < trip.tripLocations.count && index2 < trip.tripLocations.count) {
        NSMutableArray* temp = [NSMutableArray arrayWithArray:trip.tripLocations];
        [temp exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
        trip.tripLocations = temp;
        [self markChangeMade];
        [viewerTable reloadData];
        [viewerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(index2+1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

- (CGFloat)tableView: tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 480 + cellVerticalPadding;
    }
    else if (editingEnabled && indexPath.row == trip.tripLocations.count + 1) {
        return 150 + cellVerticalPadding;
    }
    return 620 + cellVerticalPadding;
}

@end
