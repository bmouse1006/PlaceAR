//
//  GPObject.h
//  GooglePlaceClientTest
//
//  Created by Jin Jin on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPObject : NSObject

@property (retain) NSDictionary* properties;

+(id)objWithProperties:(NSDictionary*)properties;

@end
