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
    
    CGRect browserFrame;
    UITableView* browserTable;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        browserFrame.origin = CGPointMake(10, 10);
        browserFrame.size = frame.size;
        browserFrame.size.height -= 20;
        browserFrame.size.width -= 20;
        
        [self layoutSubviews];
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    [self setBackgroundColor:[UIColor redColor]];
    
    //set up table view
    browserTable = [[UITableView alloc] initWithFrame:browserFrame style:UITableViewStylePlain];
    [browserTable setDelegate:self];
    [browserTable setDataSource:self];
    [self addSubview:browserTable];
}

-(void) setBrowserData:(NSArray*)newSortedData
{
    sortedListData = newSortedData;
}

#pragma mark - UITableViewDataSource

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;//sortedListData.count;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sortedListData.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"CELL"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"CELL"];
    
    cell.textLabel.text = ((Trip*)sortedListData[indexPath.row]).name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

//-(CGFloat) tableView: tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
