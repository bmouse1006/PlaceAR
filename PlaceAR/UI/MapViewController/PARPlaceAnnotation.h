//
//  PARPlaceAnnotation.h
//  PlaceAR
//
//  Created by 金 津 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GooglePlaceClient.h"

@interface PARPlaceAnnotation : NSObject<MKAnnotation>

@property (nonatomic, retain) GPSearchResult* place; 

@end
