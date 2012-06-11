//
//  PARPlaceLayer.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARPlaceLayer.h"

@interface PARPlaceLayer()

@property (nonatomic, retain) CALayer* iconLayer;
@property (nonatomic, retain) CATextLayer* titleLayer;
@property (nonatomic, retain) CATextLayer* subtitleLayer;

@end

@implementation PARPlaceLayer

@synthesize iconLayer = _iconLayer;
@synthesize titleLayer = _titleLayer;
@synthesize subtitleLayer = _subtitleLayer;
@synthesize place = _place;
@synthesize directionVertical = _directionVertical;
@synthesize directionHorizontal = _directionHorizontal;

-(id)init{
    self = [super init];
    if (self){
        self.iconLayer = [CALayer layer];
        self.titleLayer = [CATextLayer layer];
        self.titleLayer.wrapped = YES;
        self.titleLayer.foregroundColor = [UIColor whiteColor].CGColor;
        self.titleLayer.backgroundColor = [UIColor clearColor].CGColor;
        self.subtitleLayer = [CATextLayer layer];
        self.subtitleLayer.wrapped = YES;
        self.subtitleLayer.foregroundColor = [UIColor whiteColor].CGColor;
        self.subtitleLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        [self addSublayer:self.iconLayer];
        [self addSublayer:self.titleLayer];
        [self addSublayer:self.subtitleLayer];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        self.borderWidth = 2.0f;
        self.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        self.cornerRadius = 5.0f;
        self.masksToBounds = YES;
        
        self.directionHorizontal = 0.0f;
        self.directionVertical = 0.0f;
    }
    
    return self;
}

-(void)dealloc{
    self.iconLayer = nil;
    self.titleLayer = nil;
    self.subtitleLayer = nil;
    self.place = nil;
    [super dealloc];
}

+(id)layerWithPlace:(GPSearchResult*)place{
    PARPlaceLayer* layer = [[[PARPlaceLayer alloc] init] autorelease];
    layer.place = place;
    layer.titleLayer.string = place.name;
    layer.subtitleLayer.string = place.vicinity;
    
    return layer;
}
 
-(void)layoutSublayers{
    [super layoutSublayers];
    CGRect frame = self.bounds;
    
    frame.size.height *= 0.5f;
    self.titleLayer.frame = frame;
    
    frame.origin.y += frame.size.height;
    self.subtitleLayer.frame = frame;
}
@end
