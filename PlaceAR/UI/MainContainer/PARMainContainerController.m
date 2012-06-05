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

#define kSearchingParamters @"PAR_kSearchingParamters"

@interface PARMainContainerController (){
    BOOL _searchingPlace;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveStartSearchingNotification:) name:NOTIFICATION_STARTSEARCHING object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShowSearchPageNotification:) name:NOTIFICATION_SHOWSEARCHPAGE object:nil];
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
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //show search UI if place list is nil;
    if ([[self lastSearchingParameters] count] == 0){
        //search UI
        [self.searchController show];
        _searchingPlace = YES;
    }else if (self.placeList == nil){
        //start search
        [self startSearchingProcessWithParameters:[self lastSearchingParameters]];
    }
    //start motion update
    [self.motionManager setDeviceMotionUpdateInterval:1];
    __block typeof(self) blockSelf = self;
    [self.motionManager startDeviceMotionUpdatesToQueue:self.motionUpdateQueue withHandler:^(CMDeviceMotion* motion, NSError* error){
        if (_searchingPlace == YES){
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

-(void)getPOIList:(NSDictionary*)parameters{
    NSString* name = [parameters objectForKey:@"name"];
    NSString* keyword = [parameters objectForKey:@"keyword"];
    NSArray* types = [parameters objectForKey:@"types"];
    self.activityLabel.message = NSLocalizedString(@"message_fetchplaces", nil);
    [self.gpClient searchPlacesWithLocation:self.currentLocation.coordinate keyword:keyword name:name types:types radius:5000 completionHandler:^(NSArray* places, NSError* error){
        if (!error){
            self.activityLabel.message = NSLocalizedString(@"message_done", nil);
            [self.activityLabel setFinished:YES];
            self.placeNavigator.placeList = places;
            self.arViewController.placeList = places;
            _searchingPlace = NO;
        }else{
#warning add eror handler code here
            DebugLog(@"place search error %@", error);
            self.activityLabel.message = NSLocalizedString(@"message_falied", nil);
            [self.activityLabel setFinished:NO];
        }
    }context:self];
    
    [self saveSearchingParameters:parameters];
}

#pragma mark - notification call back
-(void)receiveStartSearchingNotification:(NSNotification*)notificaiton{
    [self startSearchingProcessWithParameters:[notificaiton.userInfo objectForKey:@"parameters"]];
}

-(void)receiveShowSearchPageNotification:(NSNotificationCenter*)notification{
    [self.searchController show];
}

#pragma mark - searching methods
-(void)startSearchingProcessWithParameters:(NSDictionary*)parameters{
    _searchingPlace = YES;
    [self saveSearchingParameters:parameters];
    self.activityLabel = [BaseActivityLabel loadFromBundle];
    self.activityLabel.message = NSLocalizedString(@"message_fetchlocation", nil);
    [self.activityLabel show];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - access searching parameters
-(NSDictionary*)lastSearchingParameters{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSearchingParamters];
}

-(void)saveSearchingParameters:(NSDictionary*)parameters{
    [[NSUserDefaults standardUserDefaults] setObject:parameters forKey:kSearchingParamters];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - delegate of location manger
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.currentLocation = newLocation;
    [manager stopUpdatingLocation];
    self.activityLabel.message = NSLocalizedString(@"message_fetchplaces", nil);
    [self getPOIList:[self lastSearchingParameters]];
}

@end
