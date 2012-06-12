//
//  PARPlaceView.m
//  PlaceAR
//
//  Created by Jin Jin on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARPlaceView.h"

@implementation PARPlaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(id)viewForPlace:(GPSearchResult*)place{
    PARPlaceView* view = [[[self alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
