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
    
    if (!layoutDone) {
        [self setUpSubviews];
    }
    
    [activityIndicatorView setFrame:self.bounds];
    [activityIndicatorView setCenter:self.center];
}

- (void)setUpSubviews
{
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
    
    layoutDone = YES;
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
    if ([trip.name isEqual:@""]) {trip.name = @"My Trip";}
    [activityIndicatorView startAnimating];
}

- (void)didExit
{
    [activityIndicatorView stopAnimating];
}

- (void)clearAndWait
{
    [activityIndicatorView startAnimating];
    [self setViewerTrip:nil enableEditing:NO];
}

#pragma mark - UITableViewDataSource

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
        cell.markChangeMade = ^(){[_self markChangeMade]; _self.refreshTitle();};
        cell.sendViewProfileRequest = self.sendViewProfileRequest;
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
        cell.sendViewLocationRequest = self.sendViewLocationRequest;
        cell.editingEnabled = ^BOOL(){return [_self editingEnabled];};
        cell.markChangeMade = ^(){[_self markChangeMade];};
        cell.tripLocation = trip.tripLocations[indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sendNewLocationRequest = ^(){
            self.sendNewLocationRequest(^(TripLocation* newTripLocation){
                newTripLocation.description = @"";
                [_cell changeLocation:newTripLocation.locationID withName:newTripLocation.locationName];
            });
//            [_cell changeLocation:200];
        };
        cell.sendTripImageIDRequest = ^(TripLocationItem* locationItem) {
            trip.imageID = locationItem.imageID;
            trip.image = locationItem.image;
            [viewerTable reloadData];
            [self markChangeMade];
        };
        cell.sendAddLocationRequest = ^(){
            self.sendNewLocationRequest(^(TripLocation* newTripLocation) {
                [self addLocationToCurrentTrip:newTripLocation atIndex:indexPath.row];
            });
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
        cell.requestAddItem = ^(){
            if (editingEnabled) {
                [self requestNewLocationForIndex:trip.tripLocations.count];
            }
        };
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

- (void)refreshWithNewHeader
{
    [viewerTable reloadData];
}

- (void)refreshWithNewImages
{
    [viewerTable reloadData];
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingEnabled && indexPath.row == trip.tripLocations.count + 1) {
//        [self requestNewLocationForIndex:trip.tripLocations.count];
//    }
//    return;
//}

- (void)requestNewLocationForIndex:(int)index
{
    self.sendNewLocationRequest(^(TripLocation* newTripLocation){
        newTripLocation.description = @"";
        newTripLocation.tripLocationItems = [[NSArray alloc] init];
        [self addLocationToCurrentTrip:newTripLocation atIndex:index];
    });
}

- (void)addLocationToCurrentTrip:(TripLocation*)newLocation atIndex:(int)index
{
    NSMutableArray* temp = [NSMutableArray arrayWithArray:trip.tripLocations];
    if (index < temp.count) {
        [temp insertObject:newLocation atIndex:index];
    }
    else {
        [temp addObject:newLocation];
    }
    
    trip.tripLocations = temp;
    [self markChangeMade];
    [viewerTable reloadData];
    //[viewerTable setContentOffset:CGPointMake(0, viewerTable.contentOffset.y + 620) animated:YES];
    [viewerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
        return 90 + cellVerticalPadding;
    }
    return 620 + cellVerticalPadding;
}

@end
