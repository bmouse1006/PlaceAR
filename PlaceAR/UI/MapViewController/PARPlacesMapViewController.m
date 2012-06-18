//
//  PARPlacesMapViewController.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARPlacesMapViewController.h"
#import "PARPlaceDetailViewController.h"
#import "PARPlaceAnnotation.h"
#import "JJImageView.h"

@interface PARPlacesMapViewController ()

@property (nonatomic, retain) NSArray* annotationList;

@end

@implementation PARPlacesMapViewController

@synthesize placeList = _placeList;
@synthesize annotationList = _annotationList;
@synthesize mapView = _mapView;

-(void)dealloc{
    self.placeList = nil;
    self.annotationList = nil;
    self.mapView = nil;
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
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self reloadMapView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mapView = nil;
    self.annotationList = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setPlaceList:(NSArray *)placeList{
    if (_placeList != placeList){
        [_placeList release];
        _placeList = [placeList retain];
        [self reloadMapView];
    }
}

-(void)reloadMapView{
    [self.mapView removeAnnotations:self.annotationList];
    self.annotationList = [self annotationsFromPlaceList:self.placeList];
    [self.mapView addAnnotations:self.annotationList];
}

-(NSArray*)annotationsFromPlaceList:(NSArray*)placeList{
    NSMutableArray* annotations = [NSMutableArray array];
    [placeList enumerateObjectsUsingBlock:^(GPSearchResult* place, NSUInteger idx, BOOL* stop){
        PARPlaceAnnotation* annotation = [[[PARPlaceAnnotation alloc] init] autorelease];
        annotation.place = place;
        [annotations addObject:annotation];
    }];
    
    return annotations;
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    static NSString* annotationIdentifier = @"mapIdentifier";
    if (annotation == self.mapView.userLocation){
        return nil;
    }else{
        MKPinAnnotationView* view = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
        view.pinColor = MKPinAnnotationColorGreen;
        view.canShowCallout = YES;
        view.animatesDrop = YES;
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        JJImageView* imageView = [[[JJImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)] autorelease];
        imageView.imageURL = [NSURL URLWithString:((PARPlaceAnnotation*)annotation).place.icon];
        imageView.backgroundColor = [UIColor clearColor];
        view.leftCalloutAccessoryView = imageView;
        
        return view;
    }
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MKAnnotationView* view = [views lastObject];
    if (view.annotation != self.mapView.userLocation){
        [self.mapView setVisibleMapRect:[self mapRectForAnnotations:self.annotationList]];
        [view setSelected:YES animated:YES];
    }
}


-(MKMapRect)mapRectForAnnotations:(NSArray *)annotations{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x-100, annotationPoint.y-100, 200, 200);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    
    return zoomRect;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    GPSearchResult* place = view.annotation;
    PARPlaceDetailViewController* detailViewController = [[[PARPlaceDetailViewController alloc] initWithNibName:@"PARPlaceDetailViewController" bundle:nil] autorelease];
    detailViewController.place = place;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
