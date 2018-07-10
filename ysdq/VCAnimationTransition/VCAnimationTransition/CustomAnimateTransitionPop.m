//
//  CustomAnimateTransitionPop.m
//  animateTransition
//
//  Created by 战明 on 16/5/26.
//  Copyright © 2016年 zhanming. All rights reserved.
//

#import "CustomAnimateTransitionPop.h"
#import "HomeViewController.h"
#import "HouseViewController.h"
@implementation CustomAnimateTransitionPop
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.7f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    
    HomeViewController *fromVC = (HomeViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    HouseViewController *toVC   = (HouseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
//    UIButton *button = toVC.buttonBack;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    // 注意这个地方的添加顺序是与push相反的。
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
//    [UIView animateWithDuration:0.7 animations:^{
//        fromVC.view.frame = CGRectMake(fromVC.view.frame.origin.x, fromVC.view.frame.size.height, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
//    } completion:^(BOOL finished) {
//        [self.transitionContext completeTransition:YES];
//    }];
//    return;
    
    
    // MARK: animation-2
    CGRect rectStar = fromVC.view.frame;
    CGRect rectFinal = CGRectMake(fromVC.view.frame.origin.x, fromVC.view.frame.size.height, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
    UIBezierPath *maskStartBP1 =  [UIBezierPath bezierPathWithRect:rectStar];
    UIBezierPath *maskFinalBP1 = [UIBezierPath bezierPathWithRect:rectFinal];
    
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.path = maskFinalBP1.CGPath; //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    fromVC.view.layer.mask = maskLayer1;
    
    CABasicAnimation *maskLayerAnimation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation1.fromValue = (__bridge id)(maskStartBP1.CGPath);
    maskLayerAnimation1.toValue = (__bridge id)((maskFinalBP1.CGPath));
    maskLayerAnimation1.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation1.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionDefault];
    maskLayerAnimation1.delegate = self;
    [maskLayer1 addAnimation:maskLayerAnimation1 forKey:@"path"];
    
    return;
    
    
    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:button.frame];
    
    CGPoint finalPoint;
    
    //判断触发点在哪个象限
    if(button.frame.origin.x > (toVC.view.bounds.size.width / 2)){
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    }else{
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
        }
    }
    
    CGFloat radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(startPath.CGPath);
    pingAnimation.toValue   = (__bridge id)(finalPath.CGPath);
    pingAnimation.duration = [self transitionDuration:transitionContext];
    pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    pingAnimation.delegate = self;
    
    [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}
@end
