//
//  PARMainContainerController.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARMainContainerController.h"
#import "PARInitialLoadingViewController.h"
#import "GooglePlaceClient.h"
#import "BaseActivityLabel.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface PARMainContainerController (){
    BOOL _loadingPlace;
}

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CMMotionManager* motionManager;
@property (nonatomic, retain) NSOperationQueue* motionUpdateQueue;

@property (retain) CLLocation* currentLocation;

@property (nonatomic, assign) UIViewController* currentViewController;

@property (nonatomic, retain) GooglePlaceClient* gpClient;
@property (nonatomic, retain) NSArray* placeList;

@property (nonatomic, retain) BaseActivityLabel* activityLabel;

@end

@implementation PARMainContainerController

@synthesize placeNavigator = _placeNavigator;
@synthesize arViewController = _arViewController;
@synthesize locationManager = _locationManager;
@synthesize motionManager = _motionManager;
@synthesize motionUpdateQueue = _motionUpdateQueue;
@synthesize currentViewController = _currentViewController;
@synthesize placeList = _placeList;
@synthesize gpClient = _gpClient;
@synthesize activityLabel = _activityLabel;
@synthesize currentLocation = _currentLocation;
@synthesize loadingViewController = _loadingViewController;
@synthesize searchController = _searchController;

+(void)initialize{
    [super initialize];
    [GooglePlaceClient setAPIKey:@"AIzaSyBvmZwGwDvTmChQqTSplIjy3CDbf2icZhM"];
}

-(void)dealloc{
    self.placeNavigator = nil;
    self.arViewController = nil;
    self.motionManager = nil;
    self.locationManager = nil;
    self.motionUpdateQueue = nil;
    self.placeList = nil;
    self.gpClient = nil;
    self.activityLabel = nil;
    self.currentLocation = nil;
    self.loadingViewController = nil;
    self.searchController = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.motionUpdateQueue = [[[NSOperationQueue alloc] init] autorelease];
        self.gpClient = [GooglePlaceClient sharedClient];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.placeNavigator = [[[PARPlaceNavigationController alloc] init] autorelease];
    self.arViewController = [[[PARARViewController alloc] initWithNibName:@"PARARViewController" bundle:nil] autorelease];
    self.loadingViewController = [[[PARInitialLoadingViewController alloc] initWithNibName:@"PARInitialLoadingViewController" bundle:nil] autorelease];
    self.searchController = [[[PARSearchViewController alloc] initWithNibName:@"PARSearchViewController" bundle:nil] autorelease];
    self.motionManager = [[[CMMotionManager alloc] init] autorelease];
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    
    [self addToTop:self.loadingViewController animated:NO];
    
    self.currentViewController = self.placeNavigator;
    
    if (self.placeList == nil){
        //get POI list
//        _loadingPlace = YES;
//        self.activityLabel = [BaseActivityLabel loadFromBundle];
//        self.activityLabel.message = NSLocalizedString(@"message_fetchlocation", nil);
//        [self.activityLabel show];
//        [self.locationManager startUpdatingLocation];
        //show search UI
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //show search UI if place list is nil;
    if (self.placeList == nil){
        //search UI
        [self.searchController show];
    }
    //start motion update
    [self.motionManager setDeviceMotionUpdateInterval:1];
    __block typeof(self) blockSelf = self;
    [self.motionManager startDeviceMotionUpdatesToQueue:self.motionUpdateQueue withHandler:^(CMDeviceMotion* motion, NSError* error){
        DebugLog(@"x = %.2f, y = %.2f, z = %.2f", motion.gravity.x, motion.gravity.y, motion.gravity.z);
        if (_loadingPlace){
            return;
        }else{
            if (motion.gravity.z < 0.4 && motion.gravity.z > -0.4){
                //switch to AR view
                blockSelf.currentViewController = blockSelf.arViewController;
            }else{
                //swith to list/map view
                blockSelf.currentViewController = blockSelf.placeNavigator;
            }
            
            [blockSelf switchViewController];
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.motionManager stopDeviceMotionUpdates];
    [self.locationManager stopUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.motionManager stopDeviceMotionUpdates];
    [self.locationManager stopUpdatingLocation];
    self.placeNavigator = nil;
    self.arViewController = nil;
    self.searchController = nil;
    self.loadingViewController = nil;
    self.activityLabel = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//switch views
-(void)switchViewController{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addToTop:self.currentViewController animated:YES];  
    });
}

-(void)getPOIList:(NSString*)type{
    [self.gpClient searchPlacesWithLocation:self.currentLocation.coordinate keyword:nil name:nil types:[NSArray arrayWithObject:type] radius:5000 completionHandler:^(NSArray* places, NSError* error){
        if (!error){
            self.activityLabel.message = NSLocalizedString(@"message_done", nil);
            [self.activityLabel setFinished:YES];
            self.placeNavigator.placeList = places;
            self.arViewController.placeList = places;
            _loadingPlace = NO;
        }else{
#warning add eror handler code here
            DebugLog(@"place search error %@", error);
        }
    }context:self];
}

#pragma mark - delegate of location manger
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.currentLocation = newLocation;
    [manager stopUpdatingLocation];
    self.activityLabel.message = NSLocalizedString(@"message_fetchplaces", nil);
    [self getPOIList:@"atm"];
}

@end
