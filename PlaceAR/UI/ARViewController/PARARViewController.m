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
#import <QuartzCore/QuartzCore.h>

@interface PARARViewController ()

@property (nonatomic, retain) AVCaptureSession* captureSession;
@property (nonatomic, assign) CADisplayLink* displayLink;
@property (nonatomic, retain) CMMotionManager* motionManager;

@end

@implementation PARARViewController

@synthesize placeList = _placeList;
@synthesize captureSession = _captureSession;
@synthesize annotationContainerView = _annotationContainerView;
@synthesize displayLink = _displayLink;
@synthesize motionManager = _motionManager;

-(void)dealloc{
    self.placeList = nil;
    self.captureSession = nil;
    self.annotationContainerView = nil;
    self.displayLink = nil;
    self.motionManager = nil;
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
    [self.view.layer addSublayer:previewLayer];
    self.captureSession = captureSession;
    
    self.motionManager = [[[CMMotionManager alloc] init] autorelease];
    
    [self.motionManager startDeviceMotionUpdates];
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

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self.captureSession stopRunning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)update:(CADisplayLink*)displayLink{
    PARARPlaceContainerLayer* containerLayer = (PARARPlaceContainerLayer*)self.view.layer;
    [containerLayer updateWithMotionManager:self.motionManager timestamp:displayLink.timestamp duration:displayLink.duration];
}

@end
