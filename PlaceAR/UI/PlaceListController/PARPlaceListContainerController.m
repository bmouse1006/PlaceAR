//
//  PARPlaceListContainerController.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARPlaceListContainerController.h"
#import "PARPlaceListViewController.h"

@interface PARPlaceListContainerController ()

@property (nonatomic, retain) PARPlaceListViewController* placeList;

@end

@implementation PARPlaceListContainerController

@synthesize segControl = _segControl;
@synthesize placeList = _placeList;

-(id)init{
    self = [super init];
    if (self){
        self.placeList = [[[PARPlaceListViewController alloc] initWithNibName:@"PARPlaceListViewController" bundle:nil] autorelease];
        self.viewControllers = [NSArray arrayWithObject:self.placeList];
    }
    
    return self;
}

-(void)dealloc{
    self.segControl = nil;
    self.placeList = nil;
    [super dealloc];
}

-(void)loadView{
    [super loadView];
    self.segControl = [[[UISegmentedControl alloc] init] autorelease];
    [self popToViewController:self.placeList animated:NO];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.view = nil;
    self.segControl = nil;
}

@end
