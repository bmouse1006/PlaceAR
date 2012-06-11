//
//  PARARPlaceContainerLayer.h
//  PlaceAR
//
//  Created by 金 津 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GPSearchResult.h"

@class CMMotionManager;

@interface PARARPlaceContainerLayer : CALayer

-(void)addPlace:(GPSearchResult*)place;
-(void)removePlace:(GPSearchResult*)place;
-(void)addPlaces:(NSArray*)places;
-(void)removePlaces:(NSArray*)places;

-(void)updateWithMotionManager:(CMMotionManager*)motionManager timestamp:(CFTimeInterval)timestamp duration:(CFTimeInterval)duration;

@end
