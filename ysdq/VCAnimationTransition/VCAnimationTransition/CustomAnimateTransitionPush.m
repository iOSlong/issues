//
//  CustomAnimateTransitionPush.m
//  animateTransition
//
//  Created by 战明 on 16/5/26.
//  Copyright © 2016年 zhanming. All rights reserved.
//

#import "CustomAnimateTransitionPush.h"

@interface CustomAnimateTransitionPush()<CAAnimationDelegate>
@property (nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation CustomAnimateTransitionPush


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    
    self.transitionContext=transitionContext;
    
    // 获取动画的源控制器和目标控制器
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC =[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //获取容器视图
    UIView *contView = [transitionContext containerView];
    
    // 都添加到container中。注意顺序
    [contView addSubview:fromVC.view];
    [contView addSubview:toVC.view];
    
    // MARK: animation-1
    static int temp = 1;
    temp ++;
    if (temp%2) {
        toVC.view.frame = CGRectMake(toVC.view.frame.origin.x, 300, toVC.view.frame.size.width, toVC.view.frame.size.height);
        [UIView animateWithDuration:0.7 animations:^{
            toVC.view.frame = CGRectMake(toVC.view.frame.origin.x, 0, toVC.view.frame.size.width, toVC.view.frame.size.height);
        } completion:^(BOOL finished) {
            [self.transitionContext completeTransition:YES];
        }];
        return;
    }
    
    // MARK: animation-2
    CGRect rectStar = CGRectMake(toVC.view.frame.origin.x, toVC.view.frame.size.height, toVC.view.frame.size.width, toVC.view.frame.size.height);
    CGRect rectFinal = toVC.view.frame;
    UIBezierPath *maskStartBP1 =  [UIBezierPath bezierPathWithRect:rectStar];
    UIBezierPath *maskFinalBP1 = [UIBezierPath bezierPathWithRect:rectFinal];
    
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.path = maskFinalBP1.CGPath; //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    toVC.view.layer.mask = maskLayer1;
    
    CABasicAnimation *maskLayerAnimation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation1.fromValue = (__bridge id)(maskStartBP1.CGPath);
    maskLayerAnimation1.toValue = (__bridge id)((maskFinalBP1.CGPath));
    maskLayerAnimation1.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation1.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionDefault];
    maskLayerAnimation1.delegate = self;
    [maskLayer1 addAnimation:maskLayerAnimation1 forKey:@"path"];

    return;
    
    //  UIButton *button = fromVC.button;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    
    //*******************************下面代码就是自定义动画了大家把想要实现的动画写在下面即可**********************//
    
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:button.frame];

    //创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
    CGPoint finalPoint;
    //判断触发点在那个象限
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
    
    
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath; //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    
    //*******************************上面代码就是自定义动画了大家把想要实现的动画写在上面即可**********************//
}

#pragma mark - CABasicAnimation的Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    //告诉 iOS 这个 transition 完成
    [self.transitionContext completeTransition:YES];
    //清除 fromVC 的 mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
