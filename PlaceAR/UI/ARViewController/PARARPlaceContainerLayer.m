//
//  PARARPlaceContainerLayer.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARARPlaceContainerLayer.h"
#import "PARPlaceLayer.h"
#import <CoreMotion/CoreMotion.h>

@interface PARARPlaceContainerLayer()

@property (nonatomic, retain) NSMutableDictionary* placeLayers;
@property (nonatomic, assign) CFTimeInterval lastUpdateTimestamp;

@end

@implementation PARARPlaceContainerLayer

@synthesize placeLayers = _placeLayers;
@synthesize lastUpdateTimestamp = _lastUpdateTimestamp;

-(id)init{
    self = [super init];
    if (self){
        self.placeLayers = [NSMutableDictionary dictionary];
        self.lastUpdateTimestamp = -1;
    }
    
    return self;
}

-(void)dealloc{
    self.placeLayers = nil;
    [super dealloc];
}

-(void)addPlace:(GPSearchResult*)place{
    CALayer* layer = [PARPlaceLayer layerWithPlace:place];
    [self addSublayer:layer];
    [self.placeLayers setObject:layer forKey:place];
    [self setNeedsLayout];
}

-(void)removePlace:(GPSearchResult *)place{
    CALayer* layer = [self.placeLayers objectForKey:place];
    [layer removeFromSuperlayer];
    
    [self.placeLayers removeObjectForKey:place];
}

-(void)addPlaces:(NSArray*)places{
    [self setNeedsLayout];
}

-(void)removePlaces:(NSArray *)places{
    [places enumerateObjectsUsingBlock:^(GPSearchResult* place, NSUInteger idx, BOOL* stop){
        CALayer* layer = [self.placeLayers objectForKey:place];
        [layer removeFromSuperlayer];
    }];
    [self.placeLayers removeObjectsForKeys:places];
}

-(void)layoutSublayers{
    [super layoutSublayers];
}

-(void)updateWithMotionManager:(CMMotionManager*)motionManager timestamp:(CFTimeInterval)timestamp duration:(CFTimeInterval)duration{
    if (self.lastUpdateTimestamp == -1){
        self.lastUpdateTimestamp = timestamp;
    }else{
        double radiansX = motionManager.gyroData.rotationRate.x * duration;
        double radiansY = motionManager.gyroData.rotationRate.y * duration;
        double radiansZ = motionManager.gyroData.rotationRate.z * duration;
        self.lastUpdateTimestamp = timestamp;
    }
}

@end
