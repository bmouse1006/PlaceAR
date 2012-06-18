//
//  PARPlaceView.h
//  PlaceAR
//
//  Created by Jin Jin on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJLabel.h"
#import "GPSearchResult.h"

@interface PARPlaceView : UIView

@property (nonatomic, retain) IBOutlet JJLabel* titleLabel;
@property (nonatomic, retain) IBOutlet JJLabel* subtitleLabel;
@property (nonatomic, retain) IBOutlet JJLabel* distanceLabel;
@property (nonatomic, retain) IBOutlet UIView* backgroundView;

+(id)viewForPlace:(GPSearchResult*)place;

@end
