//
//  PARPlaceNavigationController.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARPlaceNavigationController.h"
#import "PARPlaceListContainerController.h"

@interface PARPlaceNavigationController ()

@property (nonatomic, retain) PARPlaceListContainerController* listContainer;

@end

@implementation PARPlaceNavigationController

@synthesize listContainer = _listContainer;
@synthesize placeList = _placeList;

-(void)dealloc{
    self.listContainer = nil;
    self.placeList = nil;
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
    self.view.backgroundColor = [UIColor blackColor];
    self.listContainer = [[[PARPlaceListContainerController alloc] init] autorelease];
    self.listContainer.placeList = self.placeList;
    self.viewControllers = [NSArray arrayWithObject:self.listContainer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.listContainer = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setPlaceList:(NSArray *)placeList{
    if (_placeList != placeList){
        [_placeList release];
        _placeList = [placeList retain];
        self.listContainer.placeList = placeList;
    }
}

@end
