//
//  TripViewerLocationCell.m
//  treads
//
//  Created by keavneyrj1 on 3/19/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripViewerLocationCell.h"

#import "ImageScrollBrowser.h"
#import "ImageScrollTextView.h"
#import "ImageScrollEditableTextView.h"
#import "ImageScrollEditItemView.h"

#import "ImageScrollDisplayableItem.h"

#import "TripLocation.h"
#import "TripLocationItem.h"

@interface TripViewerLocationCell()<UIGestureRecognizerDelegate>

@end

@implementation TripViewerLocationCell {
    BOOL layoutDone;
    
    UIView* subView;
    UIButton *locationButton;
    UIView* locationBGRView;
    UILabel* locationNameLabel;
    UITextView* locationDescriptionTextView;
    UIImageView* locationMapView;
    UIView* locationTextBackgroundView;
    
    ImageScrollBrowser* imageScrollBrowser;
    ImageScrollEditableTextView* imageScrollEditableTextView;
    ImageScrollEditItemView* imageScrollEditItemView;
    UIImageView* imageScrollBrowserAddItemView;
    
    ImageScrollEditItemView* editItemView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        layoutDone = NO;
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
    [subView setFrame:CGRectMake(24, 8, self.bounds.size.width-48, 620)];
    
    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.hidden=NO;
    locationButton.frame = CGRectMake(0, 0, self.bounds.size.width-48, 70);
    [locationButton addTarget:self action:@selector(gotoLocationPage) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:locationButton];
    
    [locationBGRView setFrame:CGRectMake(0, 0, subView.bounds.size.width, 70)];
    [locationNameLabel setFrame:CGRectMake(20, 16, subView.bounds.size.width-32, 38)];
    CGSize sizeOfText=[locationNameLabel.text sizeWithFont:locationNameLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    [locationTextBackgroundView setFrame:CGRectMake(0, 0, 40 + sizeOfText.width, 70)];
    [locationMapView setFrame:CGRectMake(0, 0, subView.bounds.size.width, 70)];
    [imageScrollBrowser setFrame:CGRectMake(0, 70, subView.bounds.size.width, 550)];
    [imageScrollBrowser setNeedsLayout];
    
    //set editing-related properties
    BOOL __editingEnabled = self.editingEnabled();
    if (__editingEnabled) {
        locationBGRView.backgroundColor = [AppColors secondaryBackgroundColor];
        locationTextBackgroundView.backgroundColor = [AppColors secondaryBackgroundColor];
    }
    else {
        locationBGRView.backgroundColor = [UIColor clearColor];
        locationTextBackgroundView.backgroundColor = [AppColors mainBackgroundColor];
    }
    [editItemView setFrame:CGRectMake(10, 80, 40, 250)];
    [editItemView setHidden:!__editingEnabled];
    [subView bringSubviewToFront:locationButton];
}

- (void)createAndAddSubviews
{
    TripViewerLocationCell* __weak _self = self;
    

 
    
    //bgrView = [[UIView alloc] init];
    //bgrView.backgroundColor = [AppColors tertiaryBackgroundColor];
    //[self addSubview:bgrView];
    
    subView = [[UIView alloc] init];
    subView.backgroundColor = [AppColors mainBackgroundColor];
    [self addSubview:subView];
    
    locationBGRView = [[UIView alloc] init];
    [subView addSubview:locationBGRView];
    
    locationNameLabel = [[UILabel alloc] init];
    locationNameLabel.backgroundColor = [UIColor clearColor];
    locationNameLabel.font = [UIFont boldSystemFontOfSize: 32];
    locationNameLabel.textColor = [AppColors mainTextColor];
    locationNameLabel.textAlignment = NSTextAlignmentLeft;
    locationNameLabel.adjustsFontSizeToFitWidth = YES;
    
//    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
//    tapGestureRecognizer.delegate = self;
//    [self addGestureRecognizer:tapGestureRecognizer];
    
    locationTextBackgroundView = [[UIView alloc] init];
    
    locationMapView = [[UIImageView alloc] init];
    locationMapView.contentMode = UIViewContentModeRight;
    locationMapView.clipsToBounds = YES;
    
    imageScrollEditableTextView = [[ImageScrollEditableTextView alloc] init];
    imageScrollEditableTextView.editingEnabled = ^BOOL(){return _self.editingEnabled();};
    imageScrollEditableTextView.markChangeMade = ^(){_self.markChangeMade();};
    
    imageScrollBrowserAddItemView = [[UIImageView alloc] init];
    imageScrollBrowserAddItemView.image = [UIImage imageNamed:@"plus_unselect.png"];
    imageScrollBrowserAddItemView.backgroundColor = [AppColors toolbarColor];
    
    imageScrollEditItemView = [[ImageScrollEditItemView alloc] initDisplaysHorizontally:YES showFavorite:YES];
    
    imageScrollBrowser = [[ImageScrollBrowser alloc] initWithImageSize:CGSizeMake(540, 360) displayView:imageScrollEditableTextView addItemView:imageScrollBrowserAddItemView editItemView:imageScrollEditItemView];
    imageScrollBrowser.editingEnabled = ^BOOL(){return _self.editingEnabled();};
    ImageScrollBrowser* __weak _imageScrollBrowser = imageScrollBrowser;
    imageScrollBrowser.sendNewItemRequest = ^(int index, BOOL replaceItem) {
//        CameraService* cameraService = [[CameraService alloc] init];
//        [cameraService showImagePickerOnSuccess:^(UIImage* returnImage) {
        _self.sendNewImageRequest(^(UIImage* returnImage) {
            TripLocationItem* newItem = [[TripLocationItem alloc] init];
            newItem.tripLocationItemID = -1;
            newItem.tripLocationID = _self.tripLocation.tripLocationID;
            newItem.imageID = [TripLocationItem UNDEFINED_IMAGE_ID];
            newItem.image = returnImage;
            newItem.description = @"";
            [_imageScrollBrowser setDisplayViewItem:newItem atIndex:index replaceItem:replaceItem];
        });
    };
    imageScrollBrowser.sendFavoriteItemRequest = ^(id<ImageScrollDisplayableItem> item) {
        TripLocationItem* locationItem = (TripLocationItem*)item;
        _self.sendTripImageIDRequest(locationItem);
    };
    
    [subView addSubview:locationMapView];
    [subView addSubview:locationTextBackgroundView];
    [subView addSubview:locationNameLabel];
    [subView addSubview:imageScrollBrowser];
    
    editItemView = [[ImageScrollEditItemView alloc] initDisplaysHorizontally:NO showFavorite:NO];
    editItemView.requestChangeItem = ^(){[_self requestedChangeItem];};
    editItemView.requestRemoveItem = ^(){[_self requestedRemoveItem];};
    editItemView.requestAddItem = ^(){[_self requestedAddItem];};
    editItemView.requestMoveForward = ^(){[_self requestedMoveForward];};
    editItemView.requestMoveBackward = ^(){[_self requestedMoveBackward];};
    
    [self addSubview:editItemView];
    [self bringSubviewToFront:editItemView];
    [self bringSubviewToFront:locationButton];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    CGPoint touchLocation = [touch locationInView:locationBGRView];
//    if (self.editingEnabled() && CGRectContainsPoint(locationBGRView.bounds, touchLocation)) {
//        //return YES;
//        [self locationChangeWasTapped];
//    }
//    //return NO;
//    return YES;
//}

- (void)changeLocation:(int)newLocationID withName:(NSString*)name
{
    self.markChangeMade();
    self.tripLocation.locationID = newLocationID;
    self.tripLocation.locationName = name;
    [self setTripLocationHeader:self.tripLocation];
    [self setNeedsLayout];
}

- (void)requestedChangeItem
{
    self.sendNewLocationRequest();
}

- (void)requestedRemoveItem
{
    self.sendDeleteLocationRequest();
}

- (void)requestedMoveForward
{
    self.sendMoveForwardRequest();
}

- (void)requestedMoveBackward
{
    self.sendMoveBackwardRequest();
}

- (void)requestedAddItem
{
    self.sendAddLocationRequest();
}

- (void)setTripLocation:(TripLocation *)tripLocation
{
    _tripLocation = tripLocation;
    
    TripViewerLocationCell* __weak _self = self;
    
    if (!layoutDone) {
        [self layoutSubviews];
        //[self setNeedsLayout];
    }

    [self setTripLocationHeader:_tripLocation];
    
    imageScrollBrowser.displayItems = tripLocation.tripLocationItems;
    imageScrollBrowser.arrayWasChanged = ^(NSArray* newDisplayItems){
        _self.markChangeMade();
        tripLocation.tripLocationItems = newDisplayItems;
    };
    imageScrollEditableTextView.textWasChanged = ^(NSString* newText, int index){
        ((TripLocationItem*)tripLocation.tripLocationItems[index]).description = newText;
    };
}

- (void)setTripLocationHeader:(TripLocation*)tripLocation
{
    locationNameLabel.text = tripLocation.locationName;//[NSString stringWithFormat:@"Location: ID %d, LocationID: %d", tripLocation.tripLocationID, tripLocation.locationID];
    
    locationMapView.image = [UIImage imageNamed:@"map_preview.png"];
    
    locationDescriptionTextView.text = [NSString stringWithFormat:@"Description for Trip Location %d: %@", tripLocation.tripID, tripLocation.description];
    locationDescriptionTextView.contentOffset = CGPointZero;
}

-(void) gotoLocationPage  //connect the button, or make it active
{
    self.sendViewLocationRequest(_tripLocation);
}

@end
