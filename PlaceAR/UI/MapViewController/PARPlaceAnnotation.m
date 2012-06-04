//
//  PARPlaceAnnotation.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARPlaceAnnotation.h"

@implementation PARPlaceAnnotation

@synthesize place = _place;

-(void)dealloc{
    self.place = nil;
    [super dealloc];
}

-(CLLocationCoordinate2D)coordinate{
    return self.place.coordinate;
}

-(NSString*)title{
    return self.place.name;
}

-(NSString*)subtitle{
    return self.place.vicinity;
}

@end
