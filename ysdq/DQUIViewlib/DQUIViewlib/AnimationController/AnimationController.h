//
//  AnimationController.h
//  DQUIViewlib
//
//  Created by lxw on 2018/10/11.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ViewAnimationType) {
    ViewAnimationTypeUnknown,
    ViewAnimationTypeSearchIconRotationHidden,
    ViewAnimationTypeSearchIconRotationShow,
};

typedef void(^AnimationBlock)(ViewAnimationType animType);

@interface AnimationController : NSObject
- (void)view:(UIView *)destView animation:(ViewAnimationType)animType didStart:(AnimationBlock)start completion:(AnimationBlock)completion appendTask:(dispatch_block_t)task;

- (void)view:(UIView *)destView animation:(ViewAnimationType)animType didStart:(AnimationBlock)start completion:(AnimationBlock)completion;

- (void)view:(UIView *)destView animation:(ViewAnimationType)animType completion:(AnimationBlock)completion;

- (void)view:(UIView *)destView animation:(ViewAnimationType)animType;

- (void)animationPause:(BOOL)pause;

- (void)releaseHoldAnimation;

@end

