//
//  PARARPlaceContainerView.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "PARARPlaceContainerView.h"
#import "PARARPlaceContainerLayer.h"

@implementation PARARPlaceContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(Class)layerClass{
    return [PARARPlaceContainerLayer class];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(ctx);
//    
//    CGContextClipToRect(ctx, rect);
//    
//    [self.layer drawInContext:ctx];
//    
//    CGContextRestoreGState(ctx);
//}


@end
