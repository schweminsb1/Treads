//
//  TripBrowser.m
//  treads
//
//  Created by keavneyrj1 on 3/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripBrowser.h"

@interface TripBrowser()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation TripBrowser {
    NSArray* sortedListData;
    SEL listSelectAction;
    NSObject* target;
    UITableView* browserTable;
    UIActivityIndicatorView* activityIndicatorView;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self layoutSubviews];
        listSelectAction = nil;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //set up table view
    browserTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [browserTable setDelegate:self];
    [browserTable setDataSource:self];
    [self addSubview:browserTable];
    
    //set up activity view
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    [activityIndicatorView stopAnimating];
    [activityIndicatorView setHidesWhenStopped:YES];
    activityIndicatorView.alpha = 1.0;
    activityIndicatorView.center = self.center;
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicatorView.color = [UIColor colorWithRed:0 green:105/255 blue:19/255 alpha:1];
    [self addSubview:activityIndicatorView];
    [self bringSubviewToFront:activityIndicatorView];
}

#pragma mark - Data Setting/Interaction

//- (void)setBrowserData:(NSArray*)newSortedData withAction: (void(^)(Trip*))newListSelectAction
- (void)setBrowserData:(NSArray*)newSortedData forTarget:(NSObject*)newTarget withAction:(SEL)newListSelectAction
{
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
    [self setBrowserData:nil forTarget:nil withAction:nil];
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
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"CELL"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"CELL"];
    
    cell.textLabel.text = ((Trip*)sortedListData[indexPath.row]).name;
    
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

//- (CGFloat) tableView: tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 200;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
