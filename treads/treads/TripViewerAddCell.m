//
//  TripViewerAddCell.m
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewerAddCell.h"

@implementation TripViewerAddCell {
    BOOL layoutDone;
    UIImageView* subView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    
    //set frames of subviews
    [subView setFrame:CGRectMake(24, 8, self.bounds.size.width-48, 150)];
}

- (void)createAndAddSubviews
{
    subView = [[UIImageView alloc] init];
    subView.backgroundColor =  AppColors.toolbarColor;
    subView.image =[UIImage imageNamed:@"plus_unselect.png"];
    [self addSubview:subView];
}

@end
