//
//  LocationPickerVC.m
//  treads
//
//  Created by Sam Schwemin on 4/10/13.
//  Copyright (c) 2013 Team Walking Stick. All rights reserved.
//

#import "LocationPickerVC.h"
#import "Location.h"
#import "LocationService.h"
#import "TripViewVC.h"
#import "AddLocationVC.h"
#import "LocationMapVC.h"

@interface LocationPickerVC ()
@property LocationService * service;
@property NSMutableArray * locations;

@end

@implementation LocationPickerVC
@synthesize locations;
@synthesize locationsFilteredArray;
@synthesize locationSearchBar;

- (id)initWithStyle:(UITableViewStyle)style withLocationService:(LocationService*)service
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _service=service;
    
  
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     //[self.navigationController.navigationBar.topItem setTitleView: locationSearchBar];
    //[_service getLocationsforTarget:self withAction:@selector(fillLocations:)];
      locationSearchBar.tintColor=[AppColors toolbarColor];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_service getLocationsforTarget:self withAction:@selector(fillLocations:)];
  
   // [self.navigationController.navigationBar.topItem setTitleView: locationSearchBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
            return locationsFilteredArray.count+1;
    } else {
           return locations.count+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"NewCell";
    UITableViewCell *cell;

    if(indexPath.row==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        cell.textLabel.text=@"Create New";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        Location * location;
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            location = [locationsFilteredArray objectAtIndex:indexPath.row-1];
        } else {
            location = [locations objectAtIndex:indexPath.row-1];
        }
 
        cell.textLabel.text=location.title;
    }
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0)
    {
        
        //AddLocationVC * addLocVC= [[AddLocationVC alloc] init];
        LocationMapVC *addLocMapVC = [[LocationMapVC alloc]init];
        [self.navigationController pushViewController:addLocMapVC animated:YES];
    }
    else
    {
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            self.returnLocationToTripView(locationsFilteredArray[indexPath.row-1]);
            [self.navigationController popViewControllerAnimated:YES];

        }
        else
        {
            self.returnLocationToTripView(locations[indexPath.row-1]);
           [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)fillLocations:(NSArray*) items
{
    locations= (NSMutableArray*)items;
    locationsFilteredArray= [NSMutableArray arrayWithCapacity:locations.count];
    
    [self.tableView reloadData];
    
}
#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.locationsFilteredArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    locationsFilteredArray = [NSMutableArray arrayWithArray:[locations filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
@end
