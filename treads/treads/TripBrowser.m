//
//  TripBrowser.m
//  treads
//
//  Created by keavneyrj1 on 3/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripBrowser.h"

#import "TripBrowserCell.h"
#import "ProfileBrowserCell.h"

#import "AppColors.h"

@interface TripBrowser()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation TripBrowser {
    BOOL layoutDone;
    NSArray* sortedListData;
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
        [self layoutSubviews];
        listSelectAction = nil;
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
    sortedListData = newSortedData;
    target = newTarget;
    listSelectAction = newListSelectAction;
    
    [browserTable reloadData];
    [browserTable setContentOffset:CGPointZero animated:NO];
    if (newSortedData != nil) {[activityIndicatorView stopAnimating];}
}

- (void)clearAndWait
{
    [activityIndicatorView startAnimating];
    [self setBrowserData:nil withCellStyle:self.cellStyle forTarget:nil withAction:nil];
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
    return sortedListData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripBrowserCell* cell = [tableView dequeueReusableCellWithIdentifier:[self getCellIdentifier]];
    if (!cell) {
        cell = [[TripBrowserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getCellIdentifier] cellStyle:self.cellStyle];
        //[cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        //[cell setAutoresizesSubviews:YES];
    }
    
    cell.displayTrip = (Trip*)sortedListData[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //listSelectAction((Trip*)sortedListData[indexPath.row]);
    if ([target respondsToSelector:listSelectAction]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:listSelectAction withObject:((Trip*)sortedListData[indexPath.row])];
        #pragma clang diagnostic pop
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

@end
