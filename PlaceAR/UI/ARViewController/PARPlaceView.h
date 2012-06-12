//
//  PARPlaceView.h
//  PlaceAR
//
//  Created by Jin Jin on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSearchResult.h"

@interface PARPlaceView : UIView

+(id)viewForPlace:(GPSearchResult*)place;

@end
