//
//  TripBrowser.m
//  treads
//
//  Created by keavneyrj1 on 3/5/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripBrowser.h"

#import "Trip.h"

@interface TripBrowser()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation TripBrowser {
    NSArray* sortedListData;    
    //CGRect browserFrame;
    UITableView* browserTable;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self layoutSubviews];
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
}

#pragma mark - Data Setting/Interaction

- (void)setBrowserData:(NSArray*)newSortedData
{
    sortedListData = newSortedData;
    
    [browserTable reloadData];
    [browserTable setContentOffset:CGPointZero animated:NO];
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
