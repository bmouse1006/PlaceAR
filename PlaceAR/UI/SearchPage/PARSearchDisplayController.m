//
//  PARSearchDisplayController.m
//  PlaceAR
//
//  Created by Jin Jin on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARSearchDisplayController.h"

#define kSearchHistory @"PAR_kSearchHistory"

@interface PARSearchDisplayController ()

@property (nonatomic, retain) NSArray* types;

@property (nonatomic, retain) NSMutableArray* searchedHistoryItems;
@property (nonatomic, retain) NSMutableArray* searchedTypeItems;

@property (nonatomic, retain) NSMutableArray* tableViewItems;

@property (nonatomic, retain) UISearchBar* searchBar;
@property (nonatomic, assign) UIViewController* contentController;

@end

@implementation PARSearchDisplayController

@synthesize types = _types;
@synthesize searchedTypeItems = _searchedTypeItems;
@synthesize searchedHistoryItems = _searchedHistoryItems;
@synthesize tableViewItems = _tableViewItems;

@synthesize searchBar = _searchBar, contentController;

-(void)dealloc{
    self.types = nil;
    self.searchedHistoryItems = nil;
    self.searchedTypeItems = nil;
    self.tableViewItems = nil;
    self.searchBar = nil;
    self.contentController = nil;
    [super dealloc];
}

-(id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController{
    self = [super init];
    if (self){
        searchBar.delegate = self;
        self.searchBar = searchBar;
        self.contentController = viewController;
        [self setupSearchHistoryItems];
    }
    
    return self;
}

-(void)setAllTypes:(NSArray *)types{
    self.types = types;
}

#pragma init search history items
-(void)setupSearchHistoryItems{
    NSArray* savedHistory = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchHistory];
    if (!savedHistory){
        self.searchedHistoryItems = [NSMutableArray arrayWithArray:savedHistory];
    }else{
        self.searchedHistoryItems = [NSMutableArray array];
    }
}

#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}// return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //
}// called when text starts editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}// return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}// called when text ends editing
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}// called when text changes (including clear)
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
    return YES;
}// called before text changes

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}// called when keyboard search button pressed
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    
}// called when bookmark button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
}// called when cancel button pressed
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_2){
    
}// called when search results button pressed

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
    
}

#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
