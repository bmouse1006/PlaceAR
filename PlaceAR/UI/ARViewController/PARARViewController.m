//
//  PARARViewController.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARARViewController.h"
#import "PARARPlaceContainerLayer.h"
#import "ARView.h"

@interface PARARViewController ()

@property (nonatomic, retain) ARView* arview;

@end

@implementation PARARViewController

@synthesize placeList = _placeList;
@synthesize arview = _arview;

-(void)dealloc{
    self.placeList = nil;
    self.arview = nil;
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
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view, typically from a nib.

    self.arview = [[[ARView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:self.arview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.view = nil;
    self.arview = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.arview.frame = self.view.bounds;
    self.arview.places = self.placeList;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.arview start];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.arview stop];
}

@end
