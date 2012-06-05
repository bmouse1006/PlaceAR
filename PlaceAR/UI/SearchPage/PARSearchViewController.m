//
//  PARSearchViewController.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARSearchViewController.h"

@interface PARSearchViewController ()

@end

@implementation PARSearchViewController

@synthesize deemBackground = _deemBackground, mainContent = _mainContent;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.deemBackground = nil;
    self.mainContent = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarStatusChanged:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - search bar and search display delegate

#pragma mark - view appearence
-(void)statusBarStatusChanged:(NSNotification*)notification{
    CGRect frame = [[notification.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    frame.origin.y += 20.0f;
    [UIView animateWithDuration:0.2f animations:^{
        self.mainContent.frame = frame;
    }];
}

-(void)show{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    self.deemBackground.alpha = 0.0f;
    CGRect frame = self.mainContent.frame;
    frame.origin.x = 0;
    frame.origin.y = -frame.size.height;
    self.mainContent.frame = frame;
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
        self.deemBackground.alpha = 1.0f;
        CGRect frame = self.mainContent.frame;
        frame.origin.y = ([UIApplication sharedApplication].statusBarHidden)?0.0f:20.0f;
        self.mainContent.frame = frame;
    } completion:NULL];
}

@end
