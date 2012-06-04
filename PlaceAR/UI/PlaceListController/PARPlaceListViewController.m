//
//  PARPlaceListViewController.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARPlaceListViewController.h"
#import "GooglePlaceClient.h"
#import "PARPlaceDetailViewController.h"

@interface PARPlaceListViewController ()

@property (nonatomic, retain) NSIndexPath* selectedIndex;

@end

@implementation PARPlaceListViewController

@synthesize placeList = _placeList;
@synthesize tableView = _tableView;
@synthesize selectedIndex = _selectedIndex;

-(void)dealloc{
    self.placeList = nil;
    self.tableView = nil;
    self.selectedIndex = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.tableView deselectRowAtIndexPath:self.selectedIndex animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.placeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    
    GPSearchResult* place = [self.placeList objectAtIndex:indexPath.row];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.vicinity;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
    GPSearchResult* place = [self.placeList objectAtIndex:indexPath.row
                             ];
    PARPlaceDetailViewController* detailViewController = [[[PARPlaceDetailViewController alloc] initWithNibName:@"PARPlaceDetailViewController" bundle:nil] autorelease];
    detailViewController.place = place;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - getter/setter
-(void)setPlaceList:(NSArray *)placeList{
    if (_placeList != placeList){
        [_placeList release];
        _placeList = [placeList retain];
        [self.tableView reloadData];
    }
}

@end
