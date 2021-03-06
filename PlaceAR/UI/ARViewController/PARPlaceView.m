//
//  PARPlaceView.m
//  PlaceAR
//
//  Created by Jin Jin on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARPlaceView.h"
#import "GPSearchResult.h"
#import <QuartzCore/QuartzCore.h>

@interface PARPlaceView ()

@property (nonatomic, retain) GPSearchResult* place;

@end

@implementation PARPlaceView

@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize place = _place;
@synthesize backgroundView = _backgroundView;

-(void)dealloc{
    self.titleLabel = nil;
    self.subtitleLabel = nil;
    self.place = nil;
    self.backgroundView = nil;
    self.distanceLabel = nil;
    [super dealloc];
}

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
    self.backgroundView.layer.cornerRadius = 6.0f;
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.borderWidth = 2.0f;
    self.backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self.titleLabel setContentEdgeInsets:UIEdgeInsetsMake(2, 4, 2, 4)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.verticalAlignment = JJTextVerticalAlignmentMiddle;
    
    [self.subtitleLabel setContentEdgeInsets:UIEdgeInsetsMake(2, 4, 2, 4)];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.subtitleLabel.textColor = [UIColor whiteColor];
    self.subtitleLabel.verticalAlignment = JJTextVerticalAlignmentMiddle;
    
    [self.distanceLabel setContentEdgeInsets:UIEdgeInsetsMake(2, 4, 2, 4)];
    self.distanceLabel.font = [UIFont systemFontOfSize:12.0f];
    self.distanceLabel.textColor = [UIColor whiteColor];
    self.distanceLabel.verticalAlignment = JJTextVerticalAlignmentMiddle;
    self.distanceLabel.textAlignment = UITextAlignmentCenter;
//    self.distanceLabel.shadowEnable = YES;
    self.distanceLabel.shadowColor = [UIColor blackColor];
    self.distanceLabel.shadowOffset = CGSizeMake(0, 2);
    self.distanceLabel.shadowBlur = 0.8f;
}

+(id)viewForPlace:(GPSearchResult*)place{
    PARPlaceView* view = [[[NSBundle mainBundle] loadNibNamed:@"PARPlaceView" owner:nil options:nil] objectAtIndex:0];
    view.place = place;
    return view;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.text = self.place.name;
    self.subtitleLabel.text = self.place.vicinity;
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
