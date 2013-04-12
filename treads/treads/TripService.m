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

@interface TripService()

//@property DataRepository* dataRepository;

@end

@implementation TripService

- (id)initWithRepository:(DataRepository*)repository {
    if ((self = [super init])) {
        self.dataRepository = repository;
        self.dataTableIdentifier = @"TripTable";
    }
    return self;
}

- (NSArray*)convertReturnDataToServiceModel:(NSArray*)returnData
{
    NSMutableArray* convertedData = [[NSMutableArray alloc] init];
    for (NSDictionary* returnTrip in returnData) {
        Trip* trip = [[Trip alloc] init];
        @try {
            trip.tripID = [[returnTrip objectForKey:@"id"] intValue];
            trip.userID = [[returnTrip objectForKey:@"userID"] intValue];
            trip.name = [returnTrip objectForKey:@"name"];
            trip.description = [returnTrip objectForKey:@"description"];
            NSArray* tripLocationsDictionary = [returnTrip objectForKey:@"tripLocations"];
            NSMutableArray* tripLocations = [[NSMutableArray alloc] init];
            for (NSDictionary* tripLocationDictionary in tripLocationsDictionary)
            {
                TripLocation* tripLocation = [[TripLocation alloc] init];
                tripLocation.tripLocationID = [[tripLocationDictionary objectForKey:@"id"] intValue];
                tripLocation.tripID = [[tripLocationDictionary objectForKey:@"tripID"] intValue];
                tripLocation.locationID = [[tripLocationDictionary objectForKey:@"locationID"] intValue];
                tripLocation.description = [tripLocationDictionary objectForKey:@"description"];
                [tripLocations addObject:tripLocation];
            }
            trip.tripLocations = tripLocations;
            
//            [self addDebugItemsToTrip:trip];
            
            [convertedData addObject:trip];
        }
        @catch (NSException* exception) {
            trip.name = @"Error - could not parse trip data";
            [convertedData addObject:trip];
        }
    }
    return [NSArray arrayWithArray:convertedData];
}

- (void)addDebugItemsToTrip:(Trip*)trip
{
    //debug items - test models for items currently not implemented server-side
    
    //items are currently randomized using the tripID as a seed
    srand(trip.tripID);
    
    //featured item
    TripLocationItem* dummyFeaturedLocationItem = [[TripLocationItem alloc] init];
    dummyFeaturedLocationItem.image = [self randomImage];
    trip.featuredLocationItem = dummyFeaturedLocationItem;
    
    //locations
    NSMutableArray* dummyLocationArray = [[NSMutableArray alloc] init];
    int count = random()%8 + 1;
    for (int i = 0; i < count; i++) {
        TripLocation* dummyLocation = [[TripLocation alloc] init];
        dummyLocation.tripLocationID = i;
        dummyLocation.tripID = trip.tripID;
        dummyLocation.locationID = i;
        dummyLocation.description = [self loremIpsum];
        
        NSMutableArray* dummyLocationItemsArray = [[NSMutableArray alloc] init];
        int cap = random()%6;
        for (int j = 0; j < cap; j++) {
            TripLocationItem* dummyLocationItem = [[TripLocationItem alloc] init];
            dummyLocationItem.image = [self randomImage];
            dummyLocationItem.description = [NSString stringWithFormat:@"%d [%ld] : %@", j, random()%1000, [self loremIpsum]];
            [dummyLocationItemsArray addObject:dummyLocationItem];
        }
        dummyLocation.tripLocationItems = [NSArray arrayWithArray:dummyLocationItemsArray];
        
        [dummyLocationArray addObject:dummyLocation];
    }
    
    trip.tripLocations = [NSArray arrayWithArray:dummyLocationArray];
}

- (UIImage*)randomImage
{
    int image = random()%5;
    switch (image) {
        case 0:
            return [UIImage imageNamed:@"mountains.jpeg"];
            break;
        case 1:
            return [UIImage imageNamed:@"helicopter-bouldering-crash-pad.jpg"];
            break;
        case 2:
            return [UIImage imageNamed:@"remote-luxury-hiking-canada.jpg"];
            break;
        case 3:
            return [UIImage imageNamed:@"summit-boots-hiking-rocks.jpg"];
            break;
        case 4:
            return [UIImage imageNamed:@"virgin_river_hiking.jpg"];
            break;
        default:
            break;
    }
    return nil;
}

- (NSString*)loremIpsum
{
    return @"Lorem ipsum dolor sit amet";//, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.";// Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.";// Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum.";
}

- (void)getAllTripsForTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:nil usingService:self forRequestingObject:target withReturnAction:returnAction];
    //[self.dataRepository getTripsMeetingCondition:@"" forTarget:target withAction:returnAction];
}

- (void)getTripWithID:(int)tripID forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"id = '%d'", tripID] usingService:self forRequestingObject:target withReturnAction:returnAction];
    //[self.dataRepository getTripsMeetingCondition:[NSString stringWithFormat:@"id = '%d'", tripID] forTarget:target withAction:returnAction];
}

- (void)updateTrip:(Trip*)trip forTarget:(NSObject *)target withAction:(SEL)returnAction
{
    NSMutableArray* tripLocations = [[NSMutableArray alloc] init];
    for(TripLocation* tripLocation in trip.tripLocations) {
        [tripLocations addObject:[self convertTripLocationToDictionary:tripLocation]];
    }
    
    NSMutableDictionary* tripDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                       @"userID":@(trip.userID),
                                       @"name":trip.name,
                                       @"description":trip.description,
                                       @"tripLocations":tripLocations
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

- (NSDictionary*)convertTripLocationToDictionary:(TripLocation*)tripLocation
{
    return @{
             //@"id":@(tripLocation.tripLocationID),
             @"tripID":@(tripLocation.tripID),
             @"locationID":@(tripLocation.locationID),
             @"description":tripLocation.description
             };
}

- (void)getTripsWithUserID:(int)userID forTarget:(NSObject*)target withAction:(SEL)returnAction{
    [self.dataRepository retrieveDataItemsMatching:[NSString stringWithFormat:@"userID = '%d'", userID] usingService:self forRequestingObject:target withReturnAction:returnAction];
}

@end
