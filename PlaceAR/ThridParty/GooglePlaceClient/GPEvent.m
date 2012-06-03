//
//  GPEvent.m
//  GooglePlaceClientTest
//
//  Created by Jin Jin on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GPEvent.h"

@implementation GPEvent

@dynamic event_id, summary, url, startTime;

-(NSString*)event_id{
    return [self.properties objectForKey:@"event_id"];
}

-(NSString*)summary{
    return [self.properties objectForKey:@"summary"];
}

-(NSString*)url{
    return [self.properties objectForKey:@"url"];
}

-(NSDate*)startTime{
    return [NSDate dateWithTimeIntervalSince1970:[[self.properties objectForKey:@"startTime"] longValue]];
}

@end
