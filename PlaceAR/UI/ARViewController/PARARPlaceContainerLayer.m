//
//  PARARPlaceContainerLayer.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARARPlaceContainerLayer.h"
#import "PARPlaceLayer.h"
#import "CLLocation+geometricaddon.h"
#import <CoreMotion/CoreMotion.h>
#import <math.h>

@interface PARARPlaceContainerLayer()

@property (nonatomic, retain) NSMutableDictionary* placeLayers;
@property (nonatomic, retain) NSMutableDictionary* directionOfLayers;
@property (nonatomic, assign) CFTimeInterval lastUpdateTimestamp;

@end

@implementation PARARPlaceContainerLayer

@synthesize placeLayers = _placeLayers;
@synthesize lastUpdateTimestamp = _lastUpdateTimestamp;
@synthesize directionOfLayers = _directionOfLayers;

-(id)init{
    self = [super init];
    if (self){
        self.placeLayers = [NSMutableDictionary dictionary];
        self.directionOfLayers = [NSMutableDictionary dictionary];
        self.lastUpdateTimestamp = -1;
    }
    
    return self;
}

-(void)dealloc{
    self.placeLayers = nil;
    self.directionOfLayers = nil;
    [super dealloc];
}

-(void)addPlace:(GPSearchResult*)place{
    CALayer* layer = [PARPlaceLayer layerWithPlace:place];
    [self addSublayer:layer];
    [self.placeLayers setObject:layer forKey:[self keyForPlace:place]];
    [self setNeedsLayout];
}

-(void)removePlace:(GPSearchResult *)place{
    CALayer* layer = [self.placeLayers objectForKey:[self keyForPlace:place]];
    [layer removeFromSuperlayer];
    
    [self.placeLayers removeObjectForKey:place];
}

-(void)addPlaces:(NSArray*)places{
    [places enumerateObjectsUsingBlock:^(GPSearchResult* place, NSUInteger idx, BOOL* stop){
        [self addPlace:place];
    }];
    [self setNeedsLayout];
}

-(void)removePlaces:(NSArray *)places{
    [places enumerateObjectsUsingBlock:^(GPSearchResult* place, NSUInteger idx, BOOL* stop){
        CALayer* layer = [self.placeLayers objectForKey:[self keyForPlace:place]];
        [layer removeFromSuperlayer];
    }];
    [self.placeLayers removeObjectsForKeys:places];
}

-(void)removeAllPlaces{
    [[self.placeLayers allValues] enumerateObjectsUsingBlock:^(CALayer* layer, NSUInteger idx, BOOL* stop){
        [layer removeFromSuperlayer];
    }];
    
    [self.placeLayers removeAllObjects];
}

-(void)layoutSublayers{
    [super layoutSublayers];
    
    static const CGFloat layerWidth = 100.0f;
    static const CGFloat layerHeight = 50.0f;
    
    static const CGFloat viewWidth = 480.0f;
    static const CGFloat viewHeight = 480.0f;
    
    CGFloat originX = (self.bounds.size.width - layerWidth)/2;
    CGFloat originY = (self.bounds.size.height - layerHeight)/2;
    
    CGRect centerRect = CGRectMake(originX, originY, layerWidth, layerHeight);
    
    [[self.placeLayers allValues] enumerateObjectsUsingBlock:^(PARPlaceLayer* placeLayer, NSUInteger idx, BOOL* stop){
        CGFloat offsetX = [self offsetWithDirection:placeLayer.directionHorizontal viewWidth:viewWidth];
        CGFloat offsetY = [self offsetWithDirection:placeLayer.directionVertical viewWidth:viewHeight];
        
        placeLayer.frame = CGRectMake(centerRect.origin.x + offsetX, centerRect.origin.y + offsetY, centerRect.size.width, centerRect.size.height);
    }];
}

-(void)updateWithMotionManager:(CMMotionManager*)motionManager timestamp:(CFTimeInterval)timestamp duration:(CFTimeInterval)duration{
    DebugLog(@"update rotate position", nil);
    if (self.lastUpdateTimestamp == -1){
        self.lastUpdateTimestamp = timestamp;
    }else{
        //x radians change used to move vertical
        double degreeX = motionManager.gyroData.rotationRate.x * duration * 180/M_PI;
        //y radians change used to move horizontal
        double degreeY = motionManager.gyroData.rotationRate.y * duration * 180/M_PI;
        //z radians change used to rotate view
        double degreeZ = motionManager.gyroData.rotationRate.z * duration * 180/M_PI;
        self.lastUpdateTimestamp = timestamp;
        [[self.placeLayers allValues] enumerateObjectsUsingBlock:^(PARPlaceLayer* placeLayer, NSUInteger idx, BOOL* stop){
            placeLayer.directionVertical += degreeX;
            placeLayer.directionHorizontal += degreeY;
        }];
        
        [self setNeedsLayout];
    }
}

-(NSArray*)visibilePlaceLayers{
    NSPredicate* filterPredicate = [NSPredicate predicateWithBlock:^BOOL(PARPlaceLayer* placeLayer, NSDictionary* binding){
        return [self isPlaceVisible:placeLayer]; 
    }];
    
    return [[self.placeLayers allValues] filteredArrayUsingPredicate:filterPredicate];
}

-(BOOL)isPlaceVisible:(PARPlaceLayer*)placeLayer{
    return CGRectIntersectsRect(self.bounds, placeLayer.bounds);
}

-(void)updateCurrentLocationWithNewLocation:(CLLocation*)newLocation{
    [[self.placeLayers allValues] enumerateObjectsUsingBlock:^(PARPlaceLayer* placeLayer, NSUInteger idx, BOOL* stop){
        placeLayer.directionHorizontal = [newLocation directionToCoordinate:placeLayer.place.coordinate];
    }];
    
    [self setNeedsLayout];
}

-(CGFloat)offsetWithDirection:(double)direction viewWidth:(CGFloat)viewWidth{
    return viewWidth * (0.5 + tan(direction*M_PI/180));
}

-(NSValue*)keyForPlace:(GPSearchResult*)place{
    return [NSValue valueWithNonretainedObject:place];
}
@end
