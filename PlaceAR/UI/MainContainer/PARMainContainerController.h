//
//  PARMainContainerController.h
//  PlaceAR
//
//  Created by 金 津 on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BRTopContainer.h"
#import "PARARViewController.h"
#import "PARPlaceListViewController.h"
#import "PARInitialLoadingViewController.h"

@interface PARMainContainerController : BRTopContainer<CLLocationManagerDelegate>

@property (nonatomic, retain) IBOutlet PARPlaceListViewController* placeListController;
@property (nonatomic, retain) IBOutlet PARARViewController* arViewController;
@property (nonatomic, retain) IBOutlet PARInitialLoadingViewController* loadingViewController;

@end
