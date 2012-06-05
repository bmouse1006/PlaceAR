//
//  GooglePlaceClient.h
//  GooglePlaceClientTest
//
//  Created by Jin Jin on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "GPDetailResult.h"
#import "GPSearchResult.h"

#define GoogleClientLocalizedString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"GooglePlace"]

typedef void(^GooglePlaceSearchHandler)(NSArray* places, NSError* error);
typedef void(^GooglePlaceDetailsHandler)(GPDetailResult* detail, NSError* error);

@interface GooglePlaceClient : NSObject<ASIHTTPRequestDelegate>
+(void)setAPIKey:(NSString*)APIKey;
+(id)sharedClient;

+(NSArray*)googlePlaceTypeList;

-(void)searchPlacesWithLocation:(CLLocationCoordinate2D)location keyword:(NSString*)keyword name:(NSString*)name types:(NSArray*)types radius:(NSUInteger)radius completionHandler:(GooglePlaceSearchHandler)completionHandler context:(id)context;

-(void)queryDetailsWithPlaceReferenceCode:(NSString*)referenceCode completionHandler:(GooglePlaceDetailsHandler)completionHandler context:(id)context;

-(void)clearAndCancelRequestWithContext:(id)context;

@end
