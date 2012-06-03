//
//  BRTopContainer.m
//  BreezyReader2
//
//  Created by 金 津 on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BRTopContainer.h"
#import "UIView+util.h"

#define CGPointCenterOfRect(rect) CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2)

static double kTransitionAnimationDuration = 0.2f;

@interface BRTopContainer ()

@property (nonatomic, retain) NSMutableDictionary* boomedTransforms;

@end

@implementation BRTopContainer

@synthesize boomedTransforms = _boomedTransforms;

-(void)dealloc{
    self.boomedTransforms = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.wantsFullScreenLayout = YES;
        self.boomedTransforms = [NSMutableDictionary dictionary];
    }
    return self;
}

-(UIViewController*)topController{
    return [self.childViewControllers lastObject];
}

-(BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers{
    return YES;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    id last = [self.childViewControllers lastObject];
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if (obj != last){
            [obj didReceiveMemoryWarning];
        }
    }];
}

-(void)loadView{
    UIView* view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    view.autoresizesSubviews = NO;
    view.backgroundColor = [UIColor blackColor];
    view.contentMode = UIViewContentModeTop;
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIViewController* controller = [self.childViewControllers lastObject];
    [self addSubviewOfChildViewController:controller];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    UIViewController* controller = [self.childViewControllers lastObject];
    return [controller shouldAutorotateToInterfaceOrientation:interfaceOrientation];
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)zoomOutViewController:(UIViewController*)controller fromRect:(CGRect)rect{
    
}

-(void)addToTop:(UIViewController*)controller animated:(BOOL)animated{
    UIViewController* top = [self.childViewControllers lastObject];
    if (top == controller){
        return;
    }
    [top viewWillDisappear:YES];
    [controller viewWillAppear:YES];
    [controller willMoveToParentViewController:self];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self addSubviewOfChildViewController:controller];
    if (top == nil){
        [controller viewDidAppear:YES];
    }else{
        double duration = (animated)?kTransitionAnimationDuration:0.0f;
        controller.view.alpha = 0.0f;
        [UIView animateWithDuration:duration animations:^{
            controller.view.alpha = 1.0f;
        }completion:^(BOOL finished){
            [top.view removeFromSuperview];
            [top viewDidDisappear:YES];
            [controller viewDidAppear:YES];
        }];
    }
}

-(void)popViewController:(BOOL)animated{
    CGFloat duration = (animated)?kTransitionAnimationDuration:0.0f;
    
    UIViewController* top = [self.childViewControllers lastObject];
    if (top){
        [top willMoveToParentViewController:nil];
        [top removeFromParentViewController];
        [top didMoveToParentViewController:nil];
        UIViewController* current = [self.childViewControllers lastObject];
        [top viewWillDisappear:YES];
        [current viewWillAppear:YES];
        if (current){
//            [self.view insertSubview:current.view belowSubview:top.view];
            [self insertSubviewOfChildViewController:current belowViewOfChildViewController:top];
        }
        
        [UIView animateWithDuration:duration animations:^{
            top.view.alpha = 0.0f;
        } completion:^(BOOL finished){
            if (finished){
                [top.view removeFromSuperview];
                [top viewDidDisappear:YES];
                [current viewDidAppear:YES];
            }
        }];

    }
}

-(void)boomOutViewController:(UIViewController*)viewController fromView:(UIView*)fromView{
    
    UIViewController* preController = [self topController];
    [preController viewWillDisappear:YES];
    [viewController viewWillAppear:YES];
    
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    CGRect fromRect = [fromView convertRect:fromView.bounds toView:self.view];
    CGRect toRect = self.view.bounds;
    if ([UIApplication sharedApplication].statusBarHidden == NO && [UIApplication sharedApplication].statusBarStyle != UIBarStyleBlackTranslucent){
        toRect.size.height -= 20.0f;
        toRect.origin.y = 20.0f;
    }
    CGFloat widthScale = fromRect.size.width/toRect.size.width;
    CGFloat heightScale = fromRect.size.height/toRect.size.height;
    CGPoint fromCenter = CGPointCenterOfRect(fromRect);
    CGPoint toCenter = CGPointCenterOfRect(toRect);
    
    CGAffineTransform translate = CGAffineTransformMakeTranslation(-toCenter.x+fromCenter.x, -toCenter.y+fromCenter.y);
    CGAffineTransform scale = CGAffineTransformMakeScale(widthScale, heightScale);
    
    
    CGAffineTransform transform = CGAffineTransformConcat(scale, translate);
    [self.boomedTransforms setObject:[NSValue valueWithCGAffineTransform:transform] forKey:[NSValue valueWithNonretainedObject:viewController]];
    
    UIView* view = viewController.view;
    
//    [self.view addSubview:view];
//    view.frame = self.view.bounds;
    [self addSubviewOfChildViewController:viewController];
    view.transform = transform;
    view.alpha = 0;
    
    preController.view.userInteractionEnabled = NO;
    view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:kTransitionAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        viewController.view.transform = CGAffineTransformIdentity;
        viewController.view.alpha = 1;
        preController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);  
    }completion:^(BOOL finished){
        if (finished){
            [preController.view removeFromSuperview];
            [preController viewDidDisappear:YES];
            [viewController viewDidAppear:YES];
            preController.view.transform = CGAffineTransformIdentity;
            preController.view.userInteractionEnabled = YES;
            view.userInteractionEnabled = YES;
        }
    }];
}

-(void)boomInTopViewController{
    
    UIViewController* top = [self topController];
    NSInteger index = [self.childViewControllers indexOfObject:top];
    UIViewController* second = nil;
    if (index - 1 >= 0){
        second = [self.childViewControllers objectAtIndex:index-1];
    }
    
    [top willMoveToParentViewController:nil];
    [top removeFromParentViewController];
    [top didMoveToParentViewController:nil];
    
    NSValue* key = [NSValue valueWithNonretainedObject:top];
    CGAffineTransform transform = [[self.boomedTransforms objectForKey:key] CGAffineTransformValue];
    [self.boomedTransforms removeObjectForKey:[NSValue valueWithNonretainedObject:key]];
    
//    [self.view insertSubview:second.view belowSubview:top.view];
    [self insertSubviewOfChildViewController:second belowViewOfChildViewController:top];
    second.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    top.view.userInteractionEnabled = NO;
    second.view.userInteractionEnabled = NO;
    
//    [second viewWillAppear:YES];
    [top viewWillDisappear:YES];
    
    [UIView animateWithDuration:kTransitionAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        top.view.transform = transform; 
        top.view.alpha = 0;
        second.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        second.view.userInteractionEnabled = YES;
//        [second viewDidAppear:YES];
        [top.view removeFromSuperview];
        [top viewDidDisappear:YES];
    }];
}

-(void)slideInViewController:(UIViewController*)viewController{
    
    UIViewController* currentController = [self topController];
    [currentController viewWillDisappear:YES];
    [viewController viewWillAppear:YES];
    
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
//    [self.view addSubview:viewController.view];
    [self addSubviewOfChildViewController:viewController];
    
//    viewController.view.frame = self.view.bounds;
    
    CGAffineTransform translate = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0);
    viewController.view.transform = translate;
    
    currentController.view.userInteractionEnabled = NO;
    viewController.view.userInteractionEnabled = NO;
    
    
    [UIView animateWithDuration:kTransitionAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        viewController.view.transform = CGAffineTransformIdentity;
        currentController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }completion:^(BOOL finished){
        if (finished){
            [currentController.view removeFromSuperview];
            [currentController viewDidDisappear:YES];
            [viewController viewDidAppear:YES];
            currentController.view.transform = CGAffineTransformIdentity;
            viewController.view.userInteractionEnabled = YES;
        }
    }];
}

-(void)slideOutViewController{
    UIViewController* top = [self topController];
    
    NSInteger index = [self.childViewControllers indexOfObject:top];
    UIViewController* second = nil;
    if (index - 1 >= 0){
        second = [self.childViewControllers objectAtIndex:index-1];
    }
    [second viewWillAppear:YES];
    [top viewWillDisappear:YES];
    
    [top willMoveToParentViewController:nil];
    [top removeFromParentViewController];
    [top didMoveToParentViewController:nil];
    
//    [self.view insertSubview:second.view belowSubview:top.view];
    [self insertSubviewOfChildViewController:second belowViewOfChildViewController:top];
    second.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    top.view.userInteractionEnabled = NO;
    second.view.userInteractionEnabled = NO;
    
    
    [UIView animateWithDuration:kTransitionAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
//        [self.view bringSubviewToFront:top.view];
        CGAffineTransform translate = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0);
        top.view.transform = translate;
        second.view.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished){
        if (finished){
            [top.view removeFromSuperview];
            [top viewDidDisappear:YES];
            [second viewDidAppear:YES];
            second.view.userInteractionEnabled = YES;
        }
    }];
}

-(void)replaceTopByController:(UIViewController*)viewController animated:(BOOL)animated{
    UIViewController* top = [self topController];
    [top willMoveToParentViewController:nil];
    [top removeFromParentViewController];
    [top didMoveToParentViewController:nil];
    
    NSValue* key = [NSValue valueWithNonretainedObject:top];
    CGAffineTransform transform = [[self.boomedTransforms objectForKey:key] CGAffineTransformValue];
    [self.boomedTransforms removeObjectForKey:[NSValue valueWithNonretainedObject:key]];
    [self.boomedTransforms setObject:[NSValue valueWithCGAffineTransform:transform] forKey:[NSValue valueWithNonretainedObject:viewController]];
    
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    [top viewWillDisappear:animated];
    [viewController viewWillAppear:animated];
    viewController.view.userInteractionEnabled = NO;
    
//    [self.view addSubview:viewController.view];
    [self addSubviewOfChildViewController:viewController];
//    viewController.view.frame = self.view.bounds;
    viewController.view.alpha = 0.0f;
    [UIView animateWithDuration:kTransitionAnimationDuration animations:^{
        viewController.view.alpha = 1.0f;
        top.view.alpha = 0.0f;
    } completion:^(BOOL finished){
        [top.view removeFromSuperview];
        [top viewDidDisappear:animated];
        [viewController viewDidAppear:animated];
        viewController.view.userInteractionEnabled = YES;
    }];
}

-(void)addSubviewOfChildViewController:(UIViewController*)childController{
    [self.view addSubview:childController.view];
    if (childController.wantsFullScreenLayout == YES || [UIApplication sharedApplication].statusBarHidden == YES){
        childController.view.frame = self.view.bounds;
    }else{
        CGRect frame = self.view.bounds;
        frame.origin.y += 20.0f;
        frame.size.height -= 20.0f;
        childController.view.frame = frame;
    }
}

-(void)insertSubviewOfChildViewController:(UIViewController*)viewController1 belowViewOfChildViewController:(UIViewController*)viewController2{
    [self addSubviewOfChildViewController:viewController1];
    [self.view insertSubview:viewController1.view belowSubview:viewController2.view];
}

@end
