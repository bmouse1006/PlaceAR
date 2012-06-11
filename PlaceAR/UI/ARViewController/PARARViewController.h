//
//  PARARViewController.h
//  PlaceAR
//
//  Created by 金 津 on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PARARViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, retain) NSArray* placeList;

@end
