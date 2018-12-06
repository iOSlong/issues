//
//  AnimationController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/10/11.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "AnimationController.h"

@interface AnimationController()<CAAnimationDelegate>
@end

@implementation AnimationController {
    AnimationBlock _animCompletion;
    AnimationBlock _animStart;
    CAAnimationGroup *_animGroup;
    UIView *_animationView;
}


- (void)view:(UIView *)destView animation:(ViewAnimationType)animType {
    [self view:destView animation:animType didStart:nil completion:nil appendTask:nil];
}

- (void)view:(UIView *)destView animation:(ViewAnimationType)animType completion:(AnimationBlock)completion {
    [self view:destView animation:animType didStart:nil completion:completion appendTask:nil];
}

- (void)view:(UIView *)destView animation:(ViewAnimationType)animType didStart:(AnimationBlock)start completion:(AnimationBlock)completion {
    [self view:destView animation:animType didStart:start completion:completion appendTask:nil];
}

- (void)view:(UIView *)destView animation:(ViewAnimationType)animType didStart:(AnimationBlock)start completion:(AnimationBlock)completion appendTask:(dispatch_block_t)task {
    _animCompletion = completion;
    _animStart      = start;
    _animationView  = destView;
    switch (animType) {
        case ViewAnimationTypeSearchIconRotationHidden:
        {
            [self searchIconAnimationHiddenState:YES];
        }
            break;
        case ViewAnimationTypeSearchIconRotationShow:{
            [self searchIconAnimationHiddenState:NO];
        }
            break;
        default:
            break;
    }
    if (task) {
        task();
    }
}


- (void)animationPause:(BOOL)pause {
    if (pause) {
        [self pauseLayer:_animationView.layer];
    }else{
        [self resumeLayer:_animationView.layer];
    }
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}






#pragma mark - Animation
- (CAKeyframeAnimation *)keyframeAnimationHiddenState:(BOOL)isHidden {
    CAKeyframeAnimation *anim     = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    if (isHidden) {
        anim.values = [NSArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.2, 0.1,1,0.1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.5, 0.2,1,0.2)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-0.5, 0.2,1,0.2)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-(M_PI/2.0), 0,1,0)],
                       nil];
        anim.keyTimes = @[@(0),@(0.1),@(0.25),@(0.4),@(0.5),@(1)];
    } else {
        anim.values = [NSArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.0), 0,1,0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.1), 0.1,1,0.1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/1.9), 0.1,1,0.1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.0), 0,1,0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                       nil];
        anim.keyTimes = @[@(0),@(0.05),@(0.08),@(0.1),@(1)];
    }
    anim.autoreverses = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    return anim;
}
- (void)searchIconAnimationHiddenState:(BOOL)isHidden {
    CAKeyframeAnimation *anim       = [self keyframeAnimationHiddenState:isHidden];
    CAAnimationGroup * animGroup    = [CAAnimationGroup animation];
    animGroup.fillMode              = kCAFillModeForwards;
    animGroup.animations            = @[anim];
    animGroup.duration              = 1.2f;
    animGroup.autoreverses          = NO;
    animGroup.removedOnCompletion   = NO;
    animGroup.delegate              = self;
    _animGroup                      = animGroup;
    if (isHidden) {
        [animGroup setValue:@"groupAnimationHidden" forKey:@"AnimationKey"];
    } else {
        [animGroup setValue:@"groupAnimationShow" forKey:@"AnimationKey"];
    }
    [_animationView.layer addAnimation:animGroup forKey:nil];
}

- (ViewAnimationType)typeAnimation:(CAAnimation *)anim {
    ViewAnimationType animType = ViewAnimationTypeUnknown;
    NSString *animValue = [anim valueForKey:@"AnimationKey"];
    if ([animValue isEqualToString:@"groupAnimationShow"]) {
        animType = ViewAnimationTypeSearchIconRotationShow;
    }else if ([animValue isEqualToString:@"groupAnimationHidden"]) {
        animType = ViewAnimationTypeSearchIconRotationHidden;
    }
    return animType;
}

#pragma mark CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    [_animationView setHidden:NO];
    if (_animStart) {
        _animStart([self typeAnimation:anim]);
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if (_animStart) {
            _animStart([self typeAnimation:anim]);
        }
        _animGroup.delegate = nil;
//        __weak __typeof(self)weakSelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            [strongSelf->_animationView.layer removeAllAnimations];
//            if ([self typeAnimation:anim] == ViewAnimationTypeSearchIconRotationHidden) {
//                [strongSelf->_animationView setHidden:YES];
//            }
//        });

    }
}
- (void)releaseHoldAnimation {
    [self->_animationView.layer removeAllAnimations];
}

- (void)dealloc {
    NSLog(@"AnimationController dealloc");
}
@end
