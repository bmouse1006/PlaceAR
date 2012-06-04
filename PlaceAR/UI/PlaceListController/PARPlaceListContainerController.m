//
//  PARPlaceListContainerController.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARPlaceListContainerController.h"
#import "PARPlaceListViewController.h"
#import "PARPlacesMapViewController.h"

@interface PARPlaceListContainerController ()

@property (nonatomic, retain) UIButton* switchToMapButton;
@property (nonatomic, retain) UIButton* switchToListButton;

@property (nonatomic, retain) PARPlaceListViewController* placeListController;
@property (nonatomic, retain) PARPlacesMapViewController* mapViewController;

@end

@implementation PARPlaceListContainerController

@synthesize switchToMapButton = _switchToMapButton, switchToListButton = _switchToListButton;
@synthesize placeListController = _placeListController;
@synthesize mapViewController = _mapViewController;
@synthesize placeList = _placeList;

static double transationDuration = 0.4f;

-(id)init{
    self = [super init];
    if (self){
    }
    
    return self;
}

-(void)dealloc{
    self.switchToListButton = nil;
    self.switchToMapButton = nil;
    self.placeListController = nil;
    self.mapViewController = nil;
    self.placeList = nil;
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.placeListController = [[[PARPlaceListViewController alloc] initWithNibName:@"PARPlaceListViewController" bundle:nil] autorelease];
    self.placeListController.placeList = self.placeList;
    self.mapViewController = [[[PARPlacesMapViewController alloc] initWithNibName:@"PARPlacesMapViewController" bundle:nil] autorelease];
    self.mapViewController.placeList = self.placeList;
    [self addChildViewController:self.placeListController];
    [self addChildViewController:self.mapViewController];
    
    [self.view addSubview:self.placeListController.view];
    
    CGRect rect = CGRectMake(0, 0, 40, 20);
    self.switchToMapButton = [[[UIButton alloc] initWithFrame:rect] autorelease];
    [self.switchToMapButton setTitle:@"map" forState:UIControlStateNormal];
    [self.switchToMapButton addTarget:self action:@selector(switchToMap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.switchToListButton = [[[UIButton alloc] initWithFrame:rect] autorelease];
    [self.switchToListButton setTitle:@"list" forState:UIControlStateNormal];
    [self.switchToListButton addTarget:self action:@selector(switchToList:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* buttonContainer = [[[UIView alloc] initWithFrame:rect] autorelease];
    [buttonContainer addSubview:self.switchToMapButton];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:buttonContainer] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchPage:)] autorelease];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.view = nil;
    self.switchToMapButton = nil;
    self.switchToListButton = nil;
    self.placeListController = nil;
    self.mapViewController = nil;
}

-(void)setPlaceList:(NSArray *)placeList{
    if (_placeList != placeList){
        [_placeList release];
        _placeList = [placeList retain];
        self.placeListController.placeList = placeList;
        self.mapViewController.placeList = placeList;
    }
}

#pragma mark - actions

-(void)switchToMap:(id)sender{
    [UIView transitionFromView:self.placeListController.view toView:self.mapViewController.view duration:transationDuration options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished){
        self.placeListController.view = nil;
    }];
    [UIView transitionFromView:self.switchToMapButton toView:self.switchToListButton duration:transationDuration options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
}

-(void)switchToList:(id)sender{
    [UIView transitionFromView:self.mapViewController.view toView:self.placeListController.view duration:transationDuration options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished){
        self.mapViewController.view = nil;
    }];
    [UIView transitionFromView:self.switchToListButton toView:self.switchToMapButton duration:transationDuration options:UIViewAnimationOptionTransitionFlipFromRight completion:NULL];
}

-(void)showSearchPage:(id)sender{
    
}

@end
