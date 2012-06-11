//
//  PARARViewController.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARARViewController.h"
#import "PARARPlaceContainerLayer.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface PARARViewController ()

@property (nonatomic, retain) AVCaptureSession* captureSession;
@property (nonatomic, assign) CADisplayLink* displayLink;
@property (nonatomic, retain) CMMotionManager* motionManager;
@property (nonatomic, retain) CLLocationManager* locationManager;

@end

@implementation PARARViewController

@synthesize placeList = _placeList;
@synthesize captureSession = _captureSession;
@synthesize annotationContainerView = _annotationContainerView;
@synthesize displayLink = _displayLink;
@synthesize motionManager = _motionManager;
@synthesize locationManager = _locationManager;
@synthesize realityView = _realityView;

-(void)dealloc{
    self.placeList = nil;
    self.captureSession = nil;
    self.annotationContainerView = nil;
    self.displayLink = nil;
    [self.motionManager stopGyroUpdates];
    [self.locationManager stopUpdatingLocation];
    self.motionManager = nil;
    self.locationManager = nil;
    self.realityView = nil;
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
    AVCaptureSession *captureSession = [[[AVCaptureSession alloc] init] autorelease];
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    if (videoInput){
        [captureSession addInput:videoInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.bounds; // Assume you want the preview layer to fill the view.
    [self.realityView.layer addSublayer:previewLayer];
    self.captureSession = captureSession;
    
    self.motionManager = [[[CMMotionManager alloc] init] autorelease];
    [self.motionManager startDeviceMotionUpdates];
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    [self updateLocation];
    
    PARARPlaceContainerLayer* containerLayer = (PARARPlaceContainerLayer*)self.annotationContainerView.layer;
    [containerLayer removeAllPlaces];
    [containerLayer addPlaces:self.placeList];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.view = nil;
    self.captureSession = nil;
    self.annotationContainerView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.captureSession startRunning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink = nil;
    [self.captureSession stopRunning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)update:(CADisplayLink*)displayLink{
    PARARPlaceContainerLayer* containerLayer = (PARARPlaceContainerLayer*)self.annotationContainerView.layer;
    [containerLayer updateWithMotionManager:self.motionManager timestamp:displayLink.timestamp duration:displayLink.duration];
}

-(void)updateLocation{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - location manager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self.locationManager stopUpdatingLocation];
    
    PARARPlaceContainerLayer* containerLayer = (PARARPlaceContainerLayer*)self.annotationContainerView.layer;
    [containerLayer updateCurrentLocationWithNewLocation:newLocation];
}

@end
