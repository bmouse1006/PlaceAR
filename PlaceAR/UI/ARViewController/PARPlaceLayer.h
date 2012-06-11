//
//  PARPlaceLayer.h
//  PlaceAR
//
//  Created by 金 津 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "GPSearchResult.h"

@interface PARPlaceLayer : CALayer

@property (nonatomic, retain) GPSearchResult* place;
@property (nonatomic, assign) double directionVertical;
@property (nonatomic, assign) double directionHorizontal;

+(id)layerWithPlace:(GPSearchResult*)place;

@end
