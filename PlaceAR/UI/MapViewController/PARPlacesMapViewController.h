//
//  PARPlacesMapViewController.h
//  PlaceAR
//
//  Created by 金 津 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PARPlacesMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) NSArray* placeList;

@property (nonatomic, retain) IBOutlet MKMapView* mapView;

@end
