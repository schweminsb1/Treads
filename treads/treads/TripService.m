//
//  TripService.m
//  treads
//
//  Created by keavneyrj1 on 3/6/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "TripService.h"

#import "DataRepository.h"
#import "Trip.h"

#import "ImageService.h"

@interface TripService()

//@property DataRepository* dataRepository;

@end

@implementation TripService

static TripService* repo;
+(TripService*) instance {
    @synchronized(self) {
        if (!repo)
            repo = [[TripService alloc] initWithRepository:[DataRepository instance]];
        return repo;
    }
}

- (id)initWithRepository:(DataRepository*)repository {
    if ((self = [super init])) {
        self.dataRepository = repository;
        self.dataTableIdentifier = @"TripTable";
    }
    return self;
}

#pragma mark - Reading

- (void)getAllTripsForTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:nil usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (void)getTripWithID:(int)tripID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"id = '%d'", tripID] usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (void)getTripsWithUserID:(int)userID forTarget:(NSObject*)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"userID = '%d'", userID] usingService:self forRequestingObject:target withReturnAction:returnAction];
}

- (void)getHeaderImageForTrip:(Trip *)trip forTarget:(NSObject *)target withCompleteAction:(SEL)completeAction
{
    //banner picture
    if (trip.imageID == [TripLocationItem UNDEFINED_IMAGE_ID]) {
        trip.image = [self emptyImage];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:completeAction];
#pragma clang diagnostic pop
    }
    //send request for image
    else {
        [[ImageService instance] getImageWithPhotoID:trip.imageID withReturnBlock:^(NSArray *items) {
            if (items.count > 0) {
                trip.image = (UIImage*)(items[0]);
            }
            else {
                trip.image = [self imageNotFound];
            }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:completeAction];
#pragma clang diagnostic pop
        }];
    }
    
    //profile picture
    trip.profileImage = [self emptyImage];
    [[ImageService instance] getImageWithPhotoID:trip.profileImageID withReturnBlock:^(NSArray *items) {
        if (items.count > 0) {
            trip.profileImage = (UIImage*)(items[0]);
        }
        else {
            trip.profileImage = [self imageNotFound];
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:completeAction];
#pragma clang diagnostic pop
    }];
}


- (void)getImagesForTrip:(Trip*)trip forTarget:(NSObject*)target withRefreshAction:(SEL)refreshAction withCompleteAction:(SEL)completeAction
{
//    int requestsSent = 0;
//    int requestsReceived = 0;
    for (TripLocation* location in trip.tripLocations) {
        for (TripLocationItem* locationItem in location.tripLocationItems) {
            //ignore if no image is present
            if (locationItem.imageID == [TripLocationItem UNDEFINED_IMAGE_ID]) {
                locationItem.image = [self imageNotFound];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [target performSelector:refreshAction];
#pragma clang diagnostic pop
                continue;
            }
            //send request for image
            //        requestsSent++;
            [[ImageService instance] getImageWithPhotoID:locationItem.imageID withReturnBlock:^(NSArray *items) {
                if (items.count > 0) {
                    locationItem.image = (UIImage*)(items[0]);
                }
                else {
                    locationItem.image = [self imageNotFound];
                }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [target performSelector:refreshAction];
#pragma clang diagnostic pop
            }];
        }
    }
}

- (UIImage*)emptyImage
{
    return [UIImage imageNamed:@"empty_item.png"];
}

- (UIImage*)imageNotFound
{
    return [UIImage imageNamed:@"404.png"];
}

- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData
{
    NSMutableArray* convertedData = [[NSMutableArray alloc] init];
    for (NSDictionary* returnTrip in returnData) {
        Trip* trip = [[Trip alloc] init];
        @try {
            trip.tripID = [[returnTrip objectForKey:@"id"] intValue];
            trip.userID = [[returnTrip objectForKey:@"userID"] intValue];
            trip.username = [returnTrip objectForKey:@"username"];
            trip.profileImageID = [[returnTrip objectForKey:@"profileImageID"] intValue];
            trip.name = [returnTrip objectForKey:@"name"];
            trip.description = [returnTrip objectForKey:@"description"];
            trip.imageID = [[returnTrip objectForKey:@"imageID"] intValue];
            NSArray* tripLocationsDictionary = [returnTrip objectForKey:@"tripLocations"];
            NSMutableArray* tripLocations = [[NSMutableArray alloc] initWithCapacity:tripLocationsDictionary.count];
            for (NSDictionary* tripLocationDictionary in tripLocationsDictionary)
            {
                TripLocation* tripLocation = [[TripLocation alloc] init];
                tripLocation.tripLocationID = [[tripLocationDictionary objectForKey:@"id"] intValue];
                tripLocation.tripID = [[tripLocationDictionary objectForKey:@"tripID"] intValue];
                tripLocation.locationID = [[tripLocationDictionary objectForKey:@"locationID"] intValue];
                tripLocation.description = [tripLocationDictionary objectForKey:@"description"];
                tripLocation.index = [[tripLocationDictionary objectForKey:@"index"] intValue];
                tripLocation.locationName = [tripLocationDictionary objectForKey:@"locationName"];
                NSArray* tripLocationItemsDictionary = [tripLocationDictionary objectForKey:@"tripLocationItems"];
                NSMutableArray* tripLocationItems = [[NSMutableArray alloc] initWithCapacity:tripLocationItemsDictionary.count];
                for (NSDictionary* tripLocationItemDictionary in tripLocationItemsDictionary) {
                    TripLocationItem* tripLocationItem = [[TripLocationItem alloc] init];
                    tripLocationItem.tripLocationItemID = [[tripLocationItemDictionary objectForKey:@"id"] intValue];
                    tripLocationItem.tripLocationID = [[tripLocationItemDictionary objectForKey:@"tripLocationID"] intValue];
                    tripLocationItem.description = [tripLocationItemDictionary objectForKey:@"description"];
                    tripLocationItem.imageID = [[tripLocationItemDictionary objectForKey:@"imageID"] intValue];
                    tripLocationItem.image = [self emptyImage];
                    tripLocationItem.index = [[tripLocationItemDictionary objectForKey:@"index"] intValue];
                    [tripLocationItems addObject:tripLocationItem];
                }
                [tripLocationItems sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
                tripLocation.tripLocationItems = tripLocationItems;
                [tripLocations addObject:tripLocation];
            }
            [tripLocations sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
            trip.tripLocations = tripLocations;
            
            //[self addDebugItemsToTrip:trip];
            
            [convertedData addObject:trip];
        }
        @catch (NSException* exception) {
            //            NSLog(exception.reason);
            trip.name = @"Error - could not parse trip data";
            [convertedData addObject:trip];
        }
    }
    return [NSArray arrayWithArray:convertedData];
}

#pragma mark - Writing

- (void)updateTrip:(Trip*)trip forTarget:(NSObject*)target withAction:(SEL)returnAction
{
    NSMutableArray* tripLocations = [[NSMutableArray alloc] init];
    for (int i=0; i<trip.tripLocations.count; i++) {
        [tripLocations addObject:[self convertTripLocationToDictionary:trip.tripLocations[i] atStoredIndex:i]];
    }
    
    NSMutableDictionary* tripDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                           @"userID":@(trip.userID),
                                           @"name":trip.name,
                                           @"description":trip.description,
                                           @"tripLocations":[NSArray arrayWithArray:tripLocations],
                                           @"imageID":@(trip.imageID)
                                           }];
    
    if (trip.tripID == [Trip UNDEFINED_TRIP_ID]) {
        [self.dataRepository createDataItem:tripDictionary usingService:self forRequestingObject:target withReturnAction:returnAction];
    }
    else {
        [tripDictionary setObject:@(trip.tripID) forKey:@"id"];
        [self.dataRepository updateDataItem:tripDictionary usingService:self forRequestingObject:target withReturnAction:returnAction];
    }
    //[self.dataRepository updateTrip:[NSDictionary dictionaryWithDictionary:tripDictionary] forTarget:target withAction:returnAction];
}

- (void)updateNewImagesForTrip:(Trip*)trip forTarget:(NSObject*)target withCompleteAction:(SEL)completeAction
{
    int requestsSent = 0;
    int __block requestsReceived = 0;
    for (TripLocation* location in trip.tripLocations) {
        for (TripLocationItem* locationItem in location.tripLocationItems) {
            //calculate requests to send
            if (locationItem.imageID != [TripLocationItem UNDEFINED_IMAGE_ID] || !locationItem.image) {
                continue;
            }
            requestsSent++;
        }
    }
    for (TripLocation* location in trip.tripLocations) {
        for (TripLocationItem* locationItem in location.tripLocationItems) {
            //ignore if image already exists
            if (locationItem.imageID != [TripLocationItem UNDEFINED_IMAGE_ID] || !locationItem.image) {
                continue;
            }
            
            //upload image
            [[ImageService instance] insertImage:locationItem.image withCompletion:^(NSDictionary *item, NSError *error) {
//                @synchronize(requestsReceived) {
                requestsReceived++;
                locationItem.imageID = [[item objectForKey:@"id"] intValue];
                if (locationItem.image == trip.image) {
                    trip.imageID = locationItem.imageID;
                }
                if (requestsReceived == requestsSent) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [target performSelector:completeAction];
#pragma clang diagnostic pop
//                }
                }
            }];
        }
    }
    if (requestsSent == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:completeAction];
#pragma clang diagnostic pop
    }
}

- (NSDictionary*)convertTripLocationToDictionary:(TripLocation*)tripLocation atStoredIndex:(int)index
{
    NSMutableArray* tripLocationItems = [[NSMutableArray alloc] init];
    for (int i=0; i<tripLocation.tripLocationItems.count; i++) {
        [tripLocationItems addObject:[self convertTripLocationItemToDictionary:tripLocation.tripLocationItems[i] atStoredIndex:i]];
    }
    
    return @{
             //@"id":@(tripLocation.tripLocationID),
             @"tripID":@(tripLocation.tripID),
             @"locationID":@(tripLocation.locationID),
             @"description":tripLocation.description,
             @"tripLocationItems":[NSArray arrayWithArray:tripLocationItems],
             @"index":@(index)
             };
}

- (NSDictionary*)convertTripLocationItemToDictionary:(TripLocationItem*)tripLocationItem atStoredIndex:(int)index
{
    return @{
             //@"id":@(tripLocationItem.tripLocationItemID),
             @"tripLocationID":@(tripLocationItem.tripLocationID),
             //             @"image":@"",//tripLocationItem.image,
             @"imageID":@(tripLocationItem.imageID),
             @"description":tripLocationItem.description,
             @"index":@(index)
             };
}

#pragma mark - Debug Items

//- (void)addDebugItemsToTrip:(Trip*)trip
//{
//    //debug items - test models for items currently not implemented server-side
//    
//    //items are currently randomized using the tripID as a seed
//    srand(trip.tripID);
//    
//    //featured item
////    TripLocationItem* dummyFeaturedLocationItem = [[TripLocationItem alloc] init];
////    dummyFeaturedLocationItem.image = [self randomImage];
////    trip.featuredLocationItem = dummyFeaturedLocationItem;
//    
//    //locations
//    //    NSMutableArray* dummyLocationArray = [[NSMutableArray alloc] init];
//    //    int count = random()%8 + 1;
//    //    for (int i = 0; i < count; i++) {
//    for (int i = 0; i < trip.tripLocations.count; i++) {
//        //        TripLocation* dummyLocation = [[TripLocation alloc] init];
//        //        dummyLocation.tripLocationID = i;
//        //        dummyLocation.tripID = trip.tripID;
//        //        dummyLocation.locationID = i;
//        //        dummyLocation.description = [self loremIpsum];
//        
//        NSMutableArray* dummyLocationItemsArray = [[NSMutableArray alloc] init];
//        int cap = random()%6;
//        for (int j = 0; j < cap; j++) {
//            TripLocationItem* dummyLocationItem = [[TripLocationItem alloc] init];
////            dummyLocationItem.image = [self randomImage];
//            dummyLocationItem.description = [NSString stringWithFormat:@"%d [%ld] : %@", j, random()%1000, [self loremIpsum]];
//            [dummyLocationItemsArray addObject:dummyLocationItem];
//        }
//        ((TripLocation*)trip.tripLocations[i]).tripLocationItems = [NSArray arrayWithArray:dummyLocationItemsArray];
//        
//        //        [dummyLocationArray addObject:dummyLocation];
//    }
//    
//    //    trip.tripLocations = [NSArray arrayWithArray:dummyLocationArray];
//}

//- (UIImage*)randomImage
//{
//    int image = random()%5;
//    switch (image) {
//        case 0:
//            return [UIImage imageNamed:@"mountains.jpeg"];
//            break;
//        case 1:
//            return [UIImage imageNamed:@"helicopter-bouldering-crash-pad.jpg"];
//            break;
//        case 2:
//            return [UIImage imageNamed:@"remote-luxury-hiking-canada.jpg"];
//            break;
//        case 3:
//            return [UIImage imageNamed:@"summit-boots-hiking-rocks.jpg"];
//            break;
//        case 4:
//            return [UIImage imageNamed:@"virgin_river_hiking.jpg"];
//            break;
//        default:
//            break;
//    }
//    return nil;
//}

//- (NSString*)loremIpsum
//{
//    return @"Lorem ipsum dolor sit amet";//, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.";// Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.";// Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum.";
//}



@end
