//
//  PresentAnimationController.m
//  VCAnimationTransition
//
//  Created by lxw on 2018/7/5.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "PresentAnimationController.h"
#import "HomeViewController.h"
#import "HouseViewController.h"

@interface PresentAnimationController()
@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, strong) UIViewController  *homeVC;
@property (nonatomic, strong) UIViewController  *houseVC;
@end

@implementation PresentAnimationController

#pragma mark - Private methods
+ (PresentAnimationController *)animatorForHomeVC:(UIViewController*)homeVC houseVC:(UIViewController*)houseVC isPresent:(BOOL)isPresent {
    PresentAnimationController *animator = [self new];
    animator.homeVC    = homeVC;
    animator.houseVC   = houseVC;
    if ([houseVC isKindOfClass:[UINavigationController class]]) {
        animator.houseVC   = [[(UINavigationController *)houseVC viewControllers] firstObject];
    }else {
        animator.houseVC   = houseVC;
    }
    animator.isPresent = isPresent;
    return animator;
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView           *containerView      = [transitionContext containerView];

    UIView           *fromView;
    UIView           *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView   = toViewController.view;
    }
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFame = [transitionContext finalFrameForViewController:toViewController];
    toView.frame = toFame;
    fromView.alpha               = 1.0f;
    toView.alpha                 = 1.0f;
//    toView.backgroundColor       = [UIColor clearColor];

    self.houseVC.view.alpha = 0.4f;
    self.houseVC.view.frame = CGRectMake(-60, 60, toFame.size.width, toFame.size.height);
    
    [containerView addSubview:toView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        self.houseVC.view.alpha = 1.0;
        self.houseVC.view.frame = toFame;
//        self.houseVC.buttonBack.imageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI_2, 0.f, 0.f, 1.f);
//        self.homeVC.buttonAction.imageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI_2, 0.f, 0.f, 1.f);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)dismissAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView           *containerView      = [transitionContext containerView];
    
    UIView           *fromView;
    UIView           *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView   = toViewController.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame   = [transitionContext finalFrameForViewController:toViewController];
    
    fromView.alpha                  = 1.0f;
//    self.houseVC.view.backgroundColor = [UIColor clearColor];
    [containerView addSubview:toView];
    [containerView bringSubviewToFront:fromView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        self.houseVC.view.alpha = 0.0f;
        self.houseVC.view.frame = CGRectMake(toView.frame.origin.x, 30, toView.frame.size.width, toView.frame.size.height);
//        self.houseVC.buttonBack.transform = CGAffineTransformIdentity;
//        self.homeVC.buttonAction.imageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark - UIViewControllerAnimatedTransitioning
// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.75;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPresent) {
        [self presentAnimateTransition:transitionContext];
    } else {
        [self dismissAnimateTransition:transitionContext];
    }
}

@end

#pragma mark - PresentViewControllerTransitioningDelegator
#pragma mark -
@interface PresentViewControllerTransitioningDelegator()
@property (nonatomic, strong) UIViewController   *fromVC;
@property (nonatomic, strong) UIViewController   *destVC;
@end

@implementation PresentViewControllerTransitioningDelegator
+ (instancetype)transitionDelegatorfromVC:(UIViewController *)fromVC ToVC:(UIViewController *)toVC {
    static PresentViewControllerTransitioningDelegator *delegator = nil;
    delegator           = [self new];
    delegator.fromVC    = fromVC;
    delegator.destVC    = toVC;
    return delegator;
}

#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [PresentAnimationController animatorForHomeVC:_fromVC houseVC:_destVC isPresent:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [PresentAnimationController animatorForHomeVC:_fromVC houseVC:_destVC isPresent:NO];
}

@end











