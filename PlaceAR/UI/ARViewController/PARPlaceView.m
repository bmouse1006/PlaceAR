//
//  PARPlaceView.m
//  PlaceAR
//
//  Created by Jin Jin on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARPlaceView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PARPlaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initialize];
}

-(void)initialize{
    self.layer.cornerRadius = 5.0f;
}

+(id)viewForPlace:(GPSearchResult*)place{
    PARPlaceView* view = [[[NSBundle mainBundle] loadNibNamed:@"PARPlaceView" owner:nil options:nil] objectAtIndex:0];
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
