//
//  CLLocation+geometricaddon.h
//  GooglePlaceClientTest
//
//  Created by Jin Jin on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (geometricaddon)

-(CLLocationDirection)directionToLocation:(const CLLocation*)location;
-(CLLocationDirection)directionToCoordinate:(const CLLocationCoordinate2D)coordinate;

@end
