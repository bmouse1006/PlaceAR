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

@interface PARARViewController (){
    BOOL _appearring;
}

@property (nonatomic, retain) ARView* arview;

@end

@implementation PARARViewController

@synthesize placeList = _placeList;
@synthesize arview = _arview;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.placeList = nil;
    self.arview = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view, typically from a nib.

    self.arview = [[[ARView alloc] initWithFrame:self.view.bounds] autorelease];
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

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.arview.frame = self.view.bounds;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.arview.frame = self.view.bounds;
    self.arview.places = self.placeList;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.arview start];
    _appearring = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.arview stop];
    _appearring = NO;
}

-(void)resignActive:(NSNotification*)notification{
    [self.arview stop];
}

-(void)becomeActive:(NSNotification*)notification{
    if (_appearring){
        [self.arview start];
    }
}

@end
